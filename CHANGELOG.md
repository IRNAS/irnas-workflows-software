# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/) format.

## [Unreleased]

## [0.6.0] - 2023-12-20

### Added

-   `twister-rpi.yaml` which is used to run Twister tests on a device connected to a Raspberry Pi.
-   Docs related to `twister-rpi.yaml` and self-hosted workflows.

### Changed

-   Migrate `build.yaml`, `twister.yaml` and `codechecker.yaml` to `self-hosted` runners.

## [0.5.0] - 2023-10-02

### Changed

-   Split `migrate_gitflow_to_tbd.sh` script into another, `update_ci_infra.sh`
    script. First one now only does the branching model migration, second on
    updates the files related to the CI infrastructure.

## [0.4.0] - 2023-10-01

### Added

-   CodeChecker workflow. On every push to the `main` branch it builds the
    firmware, analyses it and stores the analysis to the CodeChecker server.
    In PRs it builds, analyses the state of the feature branch and compares it
    against the last server analysis.

### Changed

-   Improve existing `build.yaml` and `twister.yaml` workflows.
    -   APT dependencies are now installed directly in the workflows instead
        of in the makefiles. They can now be cached, which means faster setup
        time of required workflow environments.
    -   `make install-test-dep` target was completely removed due to the above
        change.
    -   Build workflow is now triggered on every push to the `main` branch.
        Only new `make quick-build` target is run in that case, everything
        else stays the same.
    -   `make build` was renamed to the `make release` to better convey its
        purpose.
-   Documentation in **workflow-templates/zephyr/README.md** was updated
    accordingly.

### Fixed

-   Fixed incorrect caching of `nrfutil-toolchain-manager.exe`.

## [0.3.0] - 2023-09-06

### Added

-   Twister workflow. This workflow runs whenever a PR is opened, reopened or a
    commit is pushed to it. It sets up the project and runs a `make test`
    command.
-   Migration script. This script helps with the migration of projects are still
    using the older GitFlow branching model to the newer Trunk-based development
    model.

## [0.2.1] - 2023-07-11

### Fixed

-   Fix workflow files used by the repo itself.

## [0.2.0] - 2023-07-11

### Changed

-   Deprecated contents of the _Basic_ group and moved them into _Old Basic_
    group. _Basic_ group now contains workflow files suited for trunk based
    development.

## [0.1.0] - 2022-06-07

### Added

-   Project structure.
-   Instruction in Readme file.
-   First workflow group: _Basic_ that contains workflows and instructions.
-   Second workflow group: _Zephyr_ that contains workflows and instructions.
-   Workflow files for automating releases of this repository.

[Unreleased]: https://github.com/IRNAS/irnas-workflows-software/compare/v0.6.0...HEAD

[0.6.0]: https://github.com/IRNAS/irnas-workflows-software/compare/v0.5.0...v0.6.0

[0.5.0]: https://github.com/IRNAS/irnas-workflows-software/compare/v0.4.0...v0.5.0

[0.4.0]: https://github.com/IRNAS/irnas-workflows-software/compare/v0.3.0...v0.4.0

[0.3.0]: https://github.com/IRNAS/irnas-workflows-software/compare/v0.2.1...v0.3.0

[0.2.1]: https://github.com/IRNAS/irnas-workflows-software/compare/v0.2.0...v0.2.1

[0.2.0]: https://github.com/IRNAS/irnas-workflows-software/compare/v0.1.0...v0.2.0

[0.1.0]: https://github.com/IRNAS/irnas-workflows-software/compare/698dae5a57b59f1f6b5014ded7f686b168b32d04...v0.1.0
