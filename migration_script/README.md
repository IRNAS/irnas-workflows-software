# Migration and CI update scripts

Migration script (`migrate_gitflow_to_tbd.sh`), helps with the migration of
projects are still using the older GitFlow branching model to the newer
Trunk-based development model.

CI update script (`update_ci_infra.sh`) updates CI infrastructure in a Git
repository to the latest one in the template repositories.

## Running the scripts

**IMPORTANT**: Make sure that you run this script just after you have created a
new GitHub release and merged the release PR into dev. Also make sure that you
do not have any uncommitted changes and any unmerged PRs.

**Additionaly, make sure that you run the commands from the project's git
root dir**:

```bash
# If you want to migrate to the TBD-style repo.
bash <(curl -Ss https://raw.githubusercontent.com/IRNAS/irnas-workflows-software/main/migration_script/migrate_gitflow_to_tbd.sh)
# If you want to update CI workflows related files.
bash <(curl -Ss https://raw.githubusercontent.com/IRNAS/irnas-workflows-software/main/migration_script/update_ci_infra.sh)
```

Read the instructions printed by the script and follow them. **The scripts are
not fully automatic, some manual steps are needed at the end, follow them.**
