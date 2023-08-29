# Zephyr

## Description

Workflows in this group extend the workflows in [Basic](../basic/README.md)
group and introduce several new functionalities which aid in the development of
the projects using Zephyr.

Specifically, they provide:

- Everything that [Basic](../basic/README.md) workflows already do: changelog
  preparation, tagging, publishing GitHub releases, etc.,
- Running _builds_ on Pull Requests and during releases processes,
- Running _tests_ on Pull Requests,
- Caching of West modules and toolchains downloaded by East to speed up the
  project setup,
- A way to change what _build_ means for each project,
- A way to specify which artefacts are attached to the published GitHub releases
  for each project,
- A tag and Changelog cleanup steps when _build_ goes wrong and
- A way to add custom text to the release notes.

## Dependencies

Workflows in this group expect specific files to be present in the repository to
function properly. If you created your repository from `irnas-zephyr-template`
then you are all set with basic defaults.

Needed files (relative to project's root dir):

- `scripts/requirements.txt`, can be empty,
- `makefile` - Specific content is expected, see section
  [How to configure _build_](#how-to-configure-build).

### How to use

This group contains the following workflows:

- `create-release.yaml`
- `publish-release.yaml`
- `build.yaml`
- `label_pr.yaml`
- `twister.yaml`

They can be used in two different scenarios:

- During a release process
- In Pull Requests

#### Release process

To trigger a release process just follow the instructions in the Basic's
[How to use](../basic/README.md#how-to-use) section.

Everything that is described in that section still applies, with some
modifications:

- After creating a release tag and a new changelog section a `build.yaml`
  workflow is called.
- `build.yaml` runs a _build_ process.
- After that `publish-release.yaml` takes any resulting _build_ artefacts and
  creates a GitHub release with them.

If anything goes wrong during `build.yaml` and `publish-release.yaml` workflows
then the created release tag and Changelog update commit are deleted from the
`main` branch.

#### Pull requests

`build.yaml` (aka. _build_ process) and `twister.yaml` are automatically
triggered whenever a PR is opened, reopened or a new commit is pushed to the PR.

## How to configure _build_

Besides a bit of Zephyr-specific environment setup and caching, the `build.yaml`
is very generic and makes no assumptions about what a Zephyr project needs to do
to build artefacts and create releases. The generic approach comes from using
Make and the `makefile` file present in the project's root directory.

After running the equivalent of the below commands:

```bash
# Clone the repo into the `project` folder
# mkdir -p <project_name>/project
# cd <project_name>/project
# git clone <project_url> .

# Check the cache for West modules and East toolchain and extract if found
# Check the cache for Python dependencies based on scripts/requirements.txt
```

the `build.yaml` starts to execute `make` commands in the following order:

```bash
make install-dep
make project-setup
make pre-build
make build
make pre-package    # Used in the release process, skipped during PRs
```

It is up to the developer to decide what these commands do. A good starting
point is the
[makefile](https://github.com/IRNAS/irnas-zephyr-template/blob/main/makefile)
that is provided by `irnas-zephyr-template` repo by default.

Note: all `make` commands are executed from the root of the cloned repository.
Even if some command would `cd` into some other folder, the next command would
still execute from the root.

Expected behaviour of each `make` command:

- `make install-dep` - Installs tooling needed by the project.
- `make project-setup` - Sets up the project and any tooling that might depend
  on it.
- `make pre-build` - Runs commands that need to run before the _build_.
- `make build` - The _build_, the heart of the workflow. This could be a single
  build command or a set of build commands.
- `make pre-package` - Only used in the release process, it is skipped if the
  workflow was triggered due to a PR. Use it to package build artefacts.

### Packaging build artefacts

In release processes, the `build.yaml` will collect any files found in the
`artefacts` folder of the project's root directory and attach them to the newly
created a GitHub release as release artefacts.

The developer can use the `make pre-package` command to create the `artefacts`
folder and move any files of interest inside it.

Packaging of build artefacts is done only in release processes, it is skipped if
the workflow was triggered due to a PR.

### Adding extra text to the Release notes

Some projects need additional information in the Release Notes apart from the
changelog notes, maybe general usage instructions, an explanation of the build
artefacts or some dynamically generated report.

To do that the `make pre-package` command can copy into the `artefacts` folder
the `pre_changelog.md` and `post_changelog.md` markdown files.

Contents of these files then become a part of the Release Notes in the following
way:

```markdown
# Release notes

{Contents of the pre_changelog.md}

{Contents of the changelog for this version}

{Contents of the post_changelog.md}
```

If a section is not used, the corresponding file can be empty.
`pre_changelog.md` and `post_changelog.md` files are not attached to the created
release, even though they are present in the `artefacts` folder.

## Twister workflow

Twister workflow performs the same project setup as `build.yaml` does before it
starts executing the following `make` commands:

```bash
make install-dep
make install-test-dep
make project-setup
make test
make test-report-ci     # Runs always, even if "make test" failed
make coverage-report-ci # Runs if make test succeded
```

Expected behaviour of `make` commands (those that weren't already described
above):

- `make install-test-dep` - Installs tooling needed by the testing.
- `make test` - Runs tests with enabled coverage.
- `make test-report-ci` - Creates test report. Runs always, even if `make test`
  failed.
- `make coverage-report-ci` - Creates coverage report.

### Artefacts and reports

Workflow will then:

- Publish test report and
- if the `make test` command is successful, it will also publish code coverage
  summary as a comment on the PR.

To see the test report you can click `Details` (next to any Twister check in the
PR) -> `Summary`.

Artefact `test-report` will also contain `test-report.html` which can be viewed
in browser.

![ci-checks](./ci-checks.png)

![ci-summary](./ci-summary.png)

## A short note about Make

Make is a build automation tool, often used for managing source code
dependencies and executing compiler commands.

It can do many things, but our use of it is very simple. If we create a
`makefile` file with the below content:

```makefile
pre-build:
    echo "Running pre-build target"

build:
    echo "Running build target"
```

And then run `make pre-build` or `make build`, we would be greeted with one of
the above messages. We essentially aliased `make pre-build` and `make build`
commands to do something arbitrary.

To learn more about Make read the excellent
[Memfault's Interrupt blog](https://interrupt.memfault.com/blog/gnu-make-guidelines)
about it.
