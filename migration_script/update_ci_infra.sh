#!/usr/bin/env bash
# Usage: update_ci_infra.sh
#
# Description:
#    Update CI infrastructure in a Git repository to the latest one in the
#    template repositories.
#
#    Note: Make sure that you run this script just after you have created a new
#    GitHub release and merged the release PR into dev. Also make sure that you
#    do not have any uncommitted changes and any unmerged PRs.
#

echo "Confirm the following statement: "
echo " - You don't have any uncommitted or untracked changes laying around."
echo ""
read -p "Confirm that above is true (y/n): " -r
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Aborting migration"
    exit 1
fi

read -p "Which workflow group do you want to update (basic/zephyr): " -r
WORKFLOW_GROUP=$REPLY
# Check that workflow group is valid.
if [ "$WORKFLOW_GROUP" != "basic" ] && [ "$WORKFLOW_GROUP" != "zephyr" ]; then
    echo ""
    echo "Invalid workflow group: $WORKFLOW_GROUP, aborting migration"
    exit 1
fi

# Check if we are in a git repository.
if git rev-parse --git-dir >/dev/null 2>&1; then
    :
else
    echo "This is not a git repository, aborting migration"
    exit 1
fi

# Make sure that there are no uncommitted changes or untracked files.
if [[ -n "$(git status -s)" ]]; then
    echo "This repository has untracked files, aborting migration"
    exit 1
fi

# Make sure that we are really in top level directory.
# shellcheck disable=SC2164
cd "$(git rev-parse --show-toplevel)"

# Checkout main just in case there was no dev to begin with
git checkout main

if [[ $WORKFLOW_GROUP == "basic" ]]; then
    TEMPLATE_REPO="irnas-projects-template"
else
    TEMPLATE_REPO="irnas-zephyr-template"
fi

# Get the template repo
git clone https://github.com/IRNAS/${TEMPLATE_REPO}.git

# Delete the .github directory and copy new one from the template repo.
rm -fr .github
cp -r ${TEMPLATE_REPO}/.github .

if [[ $WORKFLOW_GROUP == "basic" ]]; then
    cp ${TEMPLATE_REPO}/.gitignore .
    cp ${TEMPLATE_REPO}/.markdownlint.yaml .
    cp ${TEMPLATE_REPO}/.pre-commit-config.yaml .
    cp ${TEMPLATE_REPO}/.prettierrc .
    cp ${TEMPLATE_REPO}/committed.toml .
    cp ${TEMPLATE_REPO}/ruff.toml .
    cp ${TEMPLATE_REPO}/typos.toml .
fi

if [[ $WORKFLOW_GROUP == "zephyr" ]]; then
    # Create scripts folder if it does not exist.
    mkdir -p scripts
    cp ${TEMPLATE_REPO}/scripts/pre_changelog.md scripts
    cp ${TEMPLATE_REPO}/scripts/post_changelog.md scripts
    cp ${TEMPLATE_REPO}/scripts/codechecker-diff.sh scripts
    cp ${TEMPLATE_REPO}/scripts/update_docker_versions.sh scripts
    cp -r ${TEMPLATE_REPO}/scripts/versions scripts
    cp ${TEMPLATE_REPO}/makefile .
    cp ${TEMPLATE_REPO}/.clang-format .
    cp ${TEMPLATE_REPO}/.clang-tidy .
    cp ${TEMPLATE_REPO}/.clangd .
    cp ${TEMPLATE_REPO}/.gitignore .
    cp ${TEMPLATE_REPO}/codechecker_config.yaml .
    cp ${TEMPLATE_REPO}/.markdownlint.yaml .
    cp ${TEMPLATE_REPO}/.pre-commit-config.yaml .
    cp ${TEMPLATE_REPO}/.prettierrc .
    cp ${TEMPLATE_REPO}/committed.toml .
    cp ${TEMPLATE_REPO}/ruff.toml .
    cp ${TEMPLATE_REPO}/typos.toml .
    cp ${TEMPLATE_REPO}/.cmake-format.yaml .
fi

rm -fr ${TEMPLATE_REPO}

echo ""
echo ""
echo "***********************************************************************"
echo ""
echo "CI infrastructure was updated, review changes!"
echo ""
echo "When done, commit them with the below message:"
echo ""
echo -e "\tinfra: CI infra was updated to the latest one from ${TEMPLATE_REPO}"
echo ""
