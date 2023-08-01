#!/usr/bin/env bash
# Usage: migrate_gitflow_to_tbd.sh PATH_TO_GIT_REPO WORKFLOW_GROUP
#
# Description:
#    Migrate a Gitflow repository to a Trunk-based development style repository.
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
#       1. Delete master branch, locally and remotely.
#       2. Rename dev branch to main, locally and remotely.
#       3. Delete contents of the .github directory.
#       4. Clone the irnas-projects-template repository and copy its .github
#       directory into the current repository.
#       5. Delete the irnas-projects-template repository.
#       6. Create a new commit with all the changes on the main and push to
#       the remote.
#
#   If WORKFLOW_GROUP is "zephyr", then the following will be done:
#       1.-3. Same as above.
#       4. Clone the irnas-zephyr-template repository and copy its .github
#       directory into the current repository.
#       5. Copy scripts/requirements.txt, if it exists, only append it to the
#       existing one.
#       6. Copy scripts/pre_changelog.md and scripts/post_changelog.md files
#       7. Copy makefile.
#       8. Delete the irnas-zephyr-template repository.
#       9. Create a new commit with all the changes on the main and push to
#       the remote.
#
#       Manually change of the default branch and deletion of the dev branch in
#       GitHub UI will be needed in the end.

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

echo "Confirm the following statements: "
echo " - You have just created a new GitHub release."
echo " - You have merged the release PR into dev branch."
echo " - You don't have any uncommited or untracked changes laying around."
echo " - You have no unmerged PRs."
echo ""
read -p "Confirm that above is true (yes/no): " -r
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

# Make sure that the state of the repository is as expected.
git checkout master
git pull
git checkout dev
git pull

if [[ ! -z "$(git diff master dev)" ]]; then
	echo "This repository has some changes between master and dev, aborting migration"
	exit 1
fi

# Delete master branch
git branch -d master
git push origin --delete master

# Rename dev to main
git checkout dev
git branch -m dev main
git push origin -u main

# We can not delete dev branch because it is the default branch and
# GitHub does not allow that.

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
	cp ${TEMPLATE_REPO}/makefile .
fi

rm -fr ${TEMPLATE_REPO}

# Add new line to .gitignore
echo '!.github/workflows/build.yaml' >>.gitignore

# Commit and push the changes.
git add .
git commit -m "Migrate to trunk-based development workflow"
git push

# Get the organization and repository name of the current repository.
ORG_REPO=$(git config --get remote.origin.url | sed 's/.*\/\([^ ]*\/[^.]*\).*/\1/')

echo ""
echo ""
echo "***********************************************************************"
echo ""
echo "Automatic migration is done, please do the following manually:"
echo ""
echo -e "\t1. Open https://github.com/$ORG_REPO/settings"
echo -e "\t2. Under 'Default branch' click two arrows button, select 'main' and click 'Update'"
echo -e "\t3. Open https://github.com/$ORG_REPO/branches"
echo -e "\t4. Delete the 'dev' branch"
if [[ $REQS_EXISTS ]]; then
	echo -e "\t5. You have existing scripts/requirements.txt file, please append east and west to it manually, CI expects them to be there."
	echo -e "\t6. Commit and push the changes to the remote."
fi
echo ""
echo "Thats it, you are done!"
