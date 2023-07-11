# IRNAS's Github Actions Workflows repository

This repository contains a variety of GitHub Actions workflow files that
automate various processes.

## Table of contents 📜

<!-- vim-markdown-toc GFM -->

* [Repository structure 🗃️](#repository-structure-)
* [How to import a group of workflows into a repository 📩](#how-to-import-a-group-of-workflows-into-a-repository-)
* [Updating existing workflows 🪚🩹](#updating-existing-workflows-)

<!-- vim-markdown-toc -->

## Repository structure 🗃️

Workflows files are stored in the `workflow-templates` folder and are further
grouped in separate folders. The rest of this document will refer to these
folders as `groups`. Each group contains a `.github` folder that contains
a `workflows` folder that finally contains all workflow files with `.yaml`
extension.

Each group also contains a `README.md` document that describes what these
workflows do and how should they be used.

## How to import a group of workflows into a repository 📩

Importing of workflows is done with old-fashioned copy and paste:

1. Decide which group of workflows do you want, for example, `basic` group.
2. Checkout the default branch of your repository (should be `main`).
3. Copy the `.github` directory inside the `basic` folder into your project root
   directory (you might already have it, make sure that you don't erase present
   files).
4. Commit new files and push them to the GitHub

That's it. You can now go to the project's GitHub page and click ***Actions***
tab, workflows that you just added will be there.

## Updating existing workflows 🪚🩹

Updating existing workflows is the same as importing them except you
should update workflow files in all longlived branches, (which should be only
`main`) and commit changes to the GitHub.

This is needed because GitHub can decide from which branch it will take the
workflow file, based on that how that workflow was triggered.
