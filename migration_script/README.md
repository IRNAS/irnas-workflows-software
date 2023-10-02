# Migration and CI update scripts

Migration script (`migrate_gitflow_to_tbd.sh`), helps with the migration of
projects are still using the older GitFlow branching model to the newer
Trunk-based development model.

CI update script (`update_ci_infra.sh`) updates CI infrastructure in a Git
repository to the latest one in the template repositories.

## Downloading the script

Just run the below set of commands to download the scripts to your machine and
make them executable, super user permissions will be needed:

```bash
sudo wget -O /usr/bin/migrate_gitflow_to_tbd https://raw.githubusercontent.com/IRNAS/irnas-workflows-software/main/migration_script/migrate_gitflow_to_tbd.sh
sudo wget -O /usr/bin/update_ci_infra https://raw.githubusercontent.com/IRNAS/irnas-workflows-software/main/migration_script/update_ci_infra.sh
sudo chmod +x /usr/bin/migrate_gitflow_to_tbd
sudo chmod +x /usr/bin/update_ci_infra
```

## Running the script

**IMPORTANT**: Make sure that you run this script just after you have created a
new GitHub release and merged the release PR into dev. Also make sure that you
do not have any uncommitted changes and any unmerged PRs.

Expected usages:

```bash
# If you want to migrate to the TBD-style repo.
migrate_gitflow_to_tbd PATH_TO_GIT_REPO
# If you only want to update CI workflows related files.
update_ci_infra PATH_TO_GIT_REPO WORKFLOW_GROUP
```

Where:

- `PATH_TO_GIT_REPO` - Relative or absolute path to the Git repository that you
  want to migrate.
- `WORKFLOW_GROUP` - Can be either _basic_ or _zephyr_. Use _basic_ if your
  project was created from a `irnas-projects-template` repo. Use _zephyr_ if
  your project was created from a `irnas-zephyr-template` repo.

Read the instructions printed by the script and follow them. **The scripts are
not fully automatic, some manual steps are needed at the end, follow them.**
