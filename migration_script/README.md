# Migration script

Migration script (`migrate_gitflow_to_tbd.sh`), helps with the migration of
projects are still using the older GitFlow branching model to the newer
Trunk-based development model.

## Downloading the script

Just run the below set of commands to download the script to your machine and
make it executable, super user permissions will be needed:

```bash
sudo wget -O /usr/bin/migrate_gitflow_to_tbd https://raw.githubusercontent.com/IRNAS/irnas-workflows-software/main/migration_script/migrate_gitflow_to_tbd.sh
sudo chmod +x /usr/bin/migrate_gitflow_to_tbd
```

## Running the script

**IMPORTANT**: Make sure that you run this script just after you have created a
new GitHub release and merged the release PR into dev. Also make sure that you
do not have any uncommitted changes and any unmerged PRs.

Expected usage:

```bash
migrate_gitflow_to_tbd PATH_TO_GIT_REPO WORKFLOW_GROUP
```

Where:

- `PATH_TO_GIT_REPO` - Relative or absolute path to the Git repository that you
  want to migrate.
- `WORKFLOW_GROUP` - Can be either _basic_ or _zephyr_. Use _basic_ if your
  project was created from a `irnas-projects-template` repo. Use _zephyr_ if
  your project was created from a `irnas-zephyr-template` repo.

Read the instructions printed by the script and follow them. **The script is not
fully automatic, some manual steps are needed at the end, follow them.**
