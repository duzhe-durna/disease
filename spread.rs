#!/usr/bin/env -S cargo +nightly -Zscript
---
package.edition = "2024"
---

use std::{
    fs::{read_dir, ReadDir},
    io,
    path::PathBuf,
    process::Command,
};

fn main() {
    let state = [
        Setup {
            src_dir: "./home".into(),
            dest_dir: home(),
        },
        Setup {
            src_dir: "./config".into(),
            dest_dir: combine_path(home(), [".config"]),
        },
        Setup {
            src_dir: "./bin".into(),
            dest_dir: combine_path(home(), [".local", "bin"]),
        },
    ]
    .into_iter()
    .map(|setup| setup.links())
    .fold(State::Ok(vec![]), State::with_links_res);

    match state {
        State::Ok(links) => {
            for link in links {
                eprintln!("{:#?}", link.exec());
            }
        }
        State::Failed(errors) => eprintln!("{errors:#?}"),
    }
}

#[derive(Debug)]
enum State {
    Ok(Vec<Link>),
    Failed(Vec<Failed>),
}

#[derive(Clone, Debug)]
struct Link {
    src: PathBuf,
    dest: PathBuf,
}

struct SrcDir(ReadDir);

#[derive(Clone, Debug)]
struct DestDir(PathBuf);

struct ValidPath(PathBuf);

#[derive(Debug)]
#[allow(dead_code)]
enum Failed {
    CouldntGetHomeDir,
    ReadingSrcDir { path: PathBuf, error: io::Error },

    DestDirIsNotADir(PathBuf),
    InvalidPath(PathBuf),

    ReadEntryErr(io::Error),
    ExecutingLinking { link: Link, error: io::Error },
    LinkingNonZeroExitCode { stderr: String, link: Link },
}

struct Setup {
    src_dir: PathBuf,
    dest_dir: PathBuf,
}

impl State {
    fn with_links_res(
        self,
        res: Result<impl Iterator<Item = Result<Link, Failed>>, Failed>,
    ) -> Self {
        match res {
            Ok(link_results) => link_results.fold(self, State::with_link_res),
            Err(error) => self.with_error(error),
        }
    }

    fn with_link_res(self, res: Result<Link, Failed>) -> Self {
        match res {
            Ok(link) => self.with_link(link),
            Err(error) => self.with_error(error),
        }
    }

    fn with_error(self, error: Failed) -> Self {
        match self {
            Self::Ok(_) => Self::Failed(vec![error]),
            Self::Failed(errors) => Self::Failed(append(error, errors)),
        }
    }

    fn with_link(self, link: Link) -> Self {
        match self {
            Self::Failed(_) => self,
            Self::Ok(links) => Self::Ok(append(link, links)),
        }
    }
}

impl Link {
    fn exec(self) -> Result<Self, Failed> {
        let output = Command::new("ln")
            .args(["-s".as_ref(), self.src.as_os_str(), self.dest.as_os_str()])
            .output()
            .map_err(|error| Failed::ExecutingLinking {
                link: self.clone(),
                error,
            })?;

        if output.status.success() {
            Ok(self)
        } else {
            Err(Failed::LinkingNonZeroExitCode {
                stderr: output.stderr.try_into().expect("utf-8 valid `ln` output"),
                link: self,
            })
        }
    }
}

impl SrcDir {
    fn new(ValidPath(path): ValidPath) -> Result<Self, Failed> {
        match read_dir(&path) {
            Ok(dir) => Ok(Self(dir)),
            Err(error) => Err(Failed::ReadingSrcDir { path, error }),
        }
    }

    fn links_to(self, DestDir(dest): DestDir) -> impl Iterator<Item = Result<Link, Failed>> {
        let Self(dir) = self;
        dir.map(move |entry_res| match entry_res {
            Ok(entry) => Ok(Link {
                dest: dest.clone(),
                src: entry.path(),
            }),
            Err(error) => Err(Failed::ReadEntryErr(error)),
        })
    }
}

impl DestDir {
    fn new(ValidPath(path): ValidPath) -> Result<Self, Failed> {
        if path.is_dir() {
            Ok(Self(path))
        } else {
            Err(Failed::DestDirIsNotADir(path))
        }
    }
}

impl ValidPath {
    fn new(raw: PathBuf) -> Result<Self, Failed> {
        match raw.canonicalize() {
            Ok(path) => Ok(Self(path)),
            Err(_) => Err(Failed::InvalidPath(raw)),
        }
    }
}

impl Setup {
    fn links(self) -> Result<impl Iterator<Item = Result<Link, Failed>>, Failed> {
        let Setup { src_dir, dest_dir } = self;

        let dest = ValidPath::new(dest_dir).and_then(DestDir::new)?;

        ValidPath::new(src_dir)
            .and_then(SrcDir::new)
            .map(|src| src.links_to(dest))
    }
}

fn home() -> PathBuf {
    std::env::home_dir()
        .ok_or(Failed::CouldntGetHomeDir)
        .unwrap()
}

fn append<I>(item: I, mut vec: Vec<I>) -> Vec<I> {
    vec.push(item);
    vec
}

fn combine_path(dir: PathBuf, parts: impl IntoIterator<Item = &'static str>) -> PathBuf {
    parts.into_iter().fold(dir, |mut dir, part| {
        dir.push(part);
        dir
    })
}

