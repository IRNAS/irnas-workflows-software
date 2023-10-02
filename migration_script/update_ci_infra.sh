#!/usr/bin/env bash
# Usage: update_ci_infra.sh PATH_TO_GIT_REPO WORKFLOW_GROUP
#
# Description:
#    Update CI infrastructure in a Git repository to the latest one in the
#    template repositories.
#
#    Note: Make sure that you run this script just after you have created a new
#    GitHub release and merged the release PR into dev. Also make sure that you
#    do not have any uncommitted changes and any unmerged PRs.
#
# Arguments:
#
#   PATH_TO_GIT_REPO    Relative or absolute path to the Git repository that you
#                       want to migrate.
#
#   WORKFLOW_GROUP      Can be either "basic" or "zephyr".
#                       Use "basic" if your project was created from a
#                       irnas-projects-template repo.
#                       Use "zephyr" if your project was created from a
#                       irnas-zephyr-template repo.

# Details:
#   If WORKFLOW_GROUP is "basic", then the following will be done:
#       1. Clone the irnas-projects-template repository and copy its .github
#       directory into the current repository.
#       2. Delete the irnas-projects-template repository.
#       3. Create a new commit with all the changes on the main and push to
#       the remote.
#
#   If WORKFLOW_GROUP is "zephyr", then the following will be done:
#       1. Clone the irnas-zephyr-template repository and copy its .github
#       directory into the current repository.
#       2. Copy scripts/requirements.txt, if it exists, only append it to the
#       existing one.
#       3. Copy scripts/pre_changelog.md and scripts/post_changelog.md files
#       4. Copy makefile.
#       5. Copy ci scripts.
#       5. Copy dotfiles.
#       6. Delete the irnas-zephyr-template repository.
#       7. Create a new commit with all the changes on the main and push to
#       the remote.

NUM_ARGS=2
# Print help text and exit if -h, or --help or insufficient number of arguments
# was given.
if [ "$1" = "-h" ] || [ "$1" = "--help" ] || [ $# -lt ${NUM_ARGS} ]; then
	sed -ne '/^#/!q;s/.\{1,2\}//;1d;p' <"$0"
	exit 1
fi

PATH_TO_GIT_REPO=$1
WORKFLOW_GROUP=$2

# Check that workflow group is valid.
if [ "$WORKFLOW_GROUP" != "basic" ] && [ "$WORKFLOW_GROUP" != "zephyr" ]; then
	echo "Invalid workflow group: $WORKFLOW_GROUP, aborting migration"
	exit 1
fi

echo "Confirm the following statement: "
echo " - You don't have any uncommited or untracked changes laying around."
echo ""
read -p "Confirm that above is true (y/n): " -r
echo ""
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
	echo "Aborting migration"
	exit 1
fi

cd $PATH_TO_GIT_REPO

# Check if we are in a git repository.
if git rev-parse --git-dir >/dev/null 2>&1; then
	:
else
	echo "This is not a git repository, aborting migration"
	exit 1
fi

# Make sure that there are no uncommitted changes or untracked files.
if [[ ! -z "$(git status -s)" ]]; then
	echo "This repository has untracked files, aborting migration"
	exit 1
fi

# Make sure that we are really in top level directory.
cd $(git rev-parse --show-toplevel)

# Checkout main just in case there was no dev to begin with
git checkout main

if [[ "$WORKFLOW_GROUP" == "basic" ]]; then
	TEMPLATE_REPO="irnas-projects-template"
else
	TEMPLATE_REPO="irnas-zephyr-template"
fi

# Get the template repo
git clone https://github.com/IRNAS/${TEMPLATE_REPO}.git

# Delete the .github directory and copy new one from the template repo.
rm -fr .github
cp -r ${TEMPLATE_REPO}/.github .

REQS_EXISTS=false
if [[ "$WORKFLOW_GROUP" == "zephyr" ]]; then
	# Create scripts folder if it does not exist.
	mkdir -p scripts
	if [ -f scripts/requirements.txt ]; then
		REQS_EXISTS=true
	else
		cp ${TEMPLATE_REPO}/scripts/requirements.txt scripts
	fi

	cp ${TEMPLATE_REPO}/scripts/pre_changelog.md scripts
	cp ${TEMPLATE_REPO}/scripts/post_changelog.md scripts
	cp ${TEMPLATE_REPO}/scripts/codechecker-diff.sh scripts
	cp ${TEMPLATE_REPO}/makefile .
	cp ${TEMPLATE_REPO}/.clang-format .
	cp ${TEMPLATE_REPO}/.clang-tidy .
	cp ${TEMPLATE_REPO}/.clangd .
	cp ${TEMPLATE_REPO}/.gitignore .
	cp ${TEMPLATE_REPO}/.gitlint .
	cp ${TEMPLATE_REPO}/.codechecker_config.yaml .
fi

rm -fr ${TEMPLATE_REPO}

echo ""
echo ""
echo "***********************************************************************"
echo ""
echo "CI infrastructure was updated."
if [[ $REQS_EXISTS ]]; then
	echo -e "\t1. You have existing scripts/requirements.txt file, please append east and west to it manually, CI expects them to be there."
fi
echo ""
echo "Review done changes, when done commit them with the below message:"
echo ""
echo -e "\tCI infrastructure was updated to the latest one from ${TEMPLATE_REPO}"
echo ""
