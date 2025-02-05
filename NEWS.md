flux-accounting version 0.28.0 - 2023-10-02
-------------------------------------------

#### Fixes

* `edit-user`: fix default values for optional args (#382)

* plugin: improve check of internal user/bank map in `job.validate` (#386)

* plugin: move queue priority assignment to `job.new` callback (#388)

* `view-bank`: fix `-t` option for a sub bank with users in it (#395)

#### Features

* plugin: record bank name to jobspec in PRIORITY event (#301)

* plugin: add queue update validation (#389)

#### Testsuite

* load content module in rc scripts (#383)

* ci: remove `upload-tarball` step from workflow (#387)

* testsuite: allow sharness tests to be run by hand (#392)

flux-accounting version 0.27.0 - 2023-09-06
-------------------------------------------

#### Fixes

* `.cpp`: add `config.h` include to source code (#366)

* `.cpp`: wrap `"config.h"`, C headers in `extern "C"` (#368)

* python: remove empty `quotechar` argument from `csv.writer` object
initialization (#372)

* python: rename `rows` variable to something more descriptive (#374)

* plugin: check for `FLUX_JOB_STATE_NEW` in `validate_cb ()` (#378)

#### Testsuite

* build: add `make deb` target for test packaging (#363)

* t: reorganize `t1007-flux-account.t` into multiple sharness tests (#367)

* docker: transition `bionic` container to `jammy` (#369)

* t: add valgrind folder to flux-accounting (#373)

* ci: update github actions `main.yml` file (#375)

flux-accounting version 0.26.0 - 2023-07-07
-------------------------------------------

#### Fixes

* database: update DB schema version (#361)

#### Features

* bank_table: add new job_usage column (#359)

* `view-bank`: improve `-t` option (#359)

#### Testsuite

* t: add new Python test directory in `t/` (#358)

flux-accounting version 0.25.0 - 2023-05-04
-------------------------------------------

#### Fixes

* plugin: improve handling of submitted jobs based on data presence in
plugin (#347)

flux-accounting version 0.24.0 - 2023-05-02
-------------------------------------------

#### Fixes

* flux-accounting service: make certain commands accessible to all users (#330)

* flux-accounting service: change BindTo to BindsTo (#341)

* `view-user`: improve formatting of output of command (#342)

* `update-db`: fix SQLite statement when updating a table with no primary key
(#343)

#### Testsuite

* replace `flux mini` usage (#344)

flux-accounting version 0.23.1 - 2023-04-07
-------------------------------------------

#### Fixes

* flux-accounting service: change Requires to BindTo (#338)

flux-accounting version 0.23.0 - 2023-04-04
-------------------------------------------

#### Fixes

* bindings: raise error to caller (#327, #328, #329)

* plugin: clear queues on flux-accounting DB update (#334)

flux-accounting version 0.22.2 - 2023-03-14
-------------------------------------------

#### Fixes

* plugin: rework increment/decrement of running and active job counts for
associations (#325)

flux-accounting version 0.22.1 - 2023-03-10
-------------------------------------------

#### Fixes

* `edit-user`: make "userid" an editable field (#319)

* `view-*` commands: raise `ValueError` when item cannot be found in
flux-accounting DB (#320)

* `view-bank`: re-add `-t` option to command (#322)

flux-accounting version 0.22.0 - 2023-03-03
-------------------------------------------

#### Fixes

* `view-job-records`: fix arguments passed in via `flux-account-service.py` (#316)

#### Features

* Add new service for `flux account` commands (#308)

* Add systemd unit file for flux-accounting service (#315)

flux-accounting version 0.21.0 - 2022-12-12
-------------------------------------------

#### Features

* Add ability to edit the parent bank of a bank (#299)

#### Testsuite

* Do not assume queues default to stopped (#302)

* Stop all queues with `--all` option (#303)

flux-accounting version 0.20.1 - 2022-10-05
-------------------------------------------

#### Fixes

* Change `update-db` command to create temporary database in `/tmp` instead
of current working directory (#288)

flux-accounting version 0.20.0 - 2022-10-04
-------------------------------------------

#### Fixes

* Add additional exception messages to Python commands (#267)

* Improve dependency message for running jobs limit (#269)

* Clean up user subcommand functions (#271)

* Clean up bank subcommand functions (#275)

* Disable queue validation in multi-factor priority plugin on unknown queue,
no configured "default" queue after flux-core queue changes (#281)

* Change default values of "DNE" entry to allow multiple jobs to be submitted
(#286)

* Change install location of multi-factor priority plugin (#287)

#### Features

* Add database schema version to flux-accounting DB (#274)

* Add automatic DB upgrade to `flux account-priority-update` command if
flux-accounting database is out of date (#274)

flux-accounting version 0.19.0 - 2022-09-07
-------------------------------------------

#### Features

* Add new `plugin.query` callback to multi-factor priority plugin which returns
internal information about users and banks, active and running job counts, and
any held jobs at the time of the query (#264)

flux-accounting version 0.18.1 - 2022-08-09
-------------------------------------------

#### Fixes

* Fix `update-db` command to provide clearer exception messages when
the command fails to update a flux-accounting database (#258)

#### Features

* Add new tests for the `update-db` command for updating old versions
of a flux-accounting database (#258)

flux-accounting version 0.18.0 - 2022-08-02
-------------------------------------------

#### Fixes

* Fix `update-db` command to account for deleted columns when updating a
flux-accounting database (#252)

* Improve error message clarity from sqlite3.connect when running the
`update-db` command (#248)

#### Features

* Add ability to disable a user/bank combo in the multi-factor priority plugin
that prevents a user from submitting and running jobs (#254)

flux-accounting version 0.17.0 - 2022-06-23
-------------------------------------------

#### Fixes

* Disable requirement for a `default` queue (#237)

#### Features

* Add a new `max_nodes` column to the `association_table` which represents
the max number of nodes a user/bank combo can have across all of their
running jobs (#235)

* Add a sharness test for calculating job priorities of multiple users with
different `--urgency` values (#236)

* Add a new `export-db` command which extracts information from both the
`association_table` and `bank_table` into `.csv` files for processing (#243)

* Add a new `update-db` command which adds any new tables and/or adds any
new columns to existing tables in a flux-accounting database (#244)

flux-accounting version 0.16.0 - 2022-04-30
------------------------------------------

#### Fixes

* Fix memory corruption due to use-after-free of the "DNE" bank entry (#233)

#### Features

* Add queue priority to job priority calculation (#207)

flux-accounting version 0.15.0 - 2022-03-31
-------------------------------------------

#### Fixes

* Fix incorrect job usage calculation for users who belong to multiple banks (#219)

* Update the `pop-db` command to include the `max_active_jobs`, `max_running_jobs`
  limits defined in the `association_table` (#224)

* Remove the unused ‘deleted’ column from the `association_table` in the flux-accounting DB (#224)

* Fix the default value for the `--queues` optional argument in the `edit-user` command (#225)

#### Features

* Add an `rc1` script that populates multi-factor priority plugin with flux-accounting DB
information on instance startup or restart (#223)

* Allow multi-factor priority plugin to be loaded and hold jobs without user/bank
information (#227)

flux-accounting version 0.14.0 - 2022-02-28
-------------------------------------------

#### Fixes

* Fix incorrect listing of column names when printing table information in the flux-accounting database (#203)

* Fix `TypeError` when not specifying a value for an optional argument for the `update-usage` command (#209)

* Fix incorrect parsing of the `count_ranks()` helper function when updating job usage values (#211)

#### Features

* Add a new `max_active_jobs` limit for user/bank combos in the multi-factor priority plugin (#201)

* Add a new distcheck builder to flux-accounting CI (#206)

flux-accounting version 0.13.0 - 2022-01-31
-------------------------------------------

#### Fixes

* Improve sharness tests to use `flux account` commands directly in tests (#180)

* Change positional and optional arguments in `edit-user` command to align with other `edit-*` commands (#181)

* Fix bug in `view-user` preventing the ability to view more than one row if a user belonged to more than one bank (#187)

* Remove outdated `admin_level` column from association_table in flux-accounting database (#188)

* Fix incorrect listing of association_table headers in the `view-user` command (#193)

* Fix `UNIQUE constraint` failure when re-adding a previously deleted user to the same bank in the flux-accounting database (#193)

* Convert the `qos` argument into positional arguments for both the `view-qos` and `edit-qos` commands (#193)

#### Features

* Add new enforcement policy in multi-factor priority plugin to only count running jobs towards an "active" jobs counter (#177)

* Add section to top-level README on flux-accounting database permissions (#188)

* Add new optional arguments to `view-bank` command to view sub bank hierarchy trees or users belonging to a specific bank (#194)

* Add bulk database populate tool to upload multiple user or bank rows at one time via `.csv` file (#195)

flux-accounting version 0.12.0 - 2021-12-03
-------------------------------------------

#### Fixes

* Improve bulk update script by reducing number of sent payloads to just one payload containing all required data needed by multi-factor priority plugin (#167)

* Drop `ax_python_devel.m4` and adjust `configure.ac` since flux-accounting does not use `PYTHON_CFLAGS` or `PYTHON_LIBS` and rejects python `3.10.0` as too old (#173)

* Add LLNL code release number to flux-accounting (#175)

#### Features

* Add support for defining, configuring, and editing queues and its various limits within the flux-accounting database (#176)

flux-accounting version 0.11.0 - 2021-10-29
-------------------------------------------

#### Fixes

* Replace the "strict" merge mode with queue+rebase in Mergify (#158)

* Add missing installation of the Python bulk update script that sends updated database information to the priority plugin (#162)

* Change names of all automatic update scripts to fall under one prefix called "account" (#162)

* Change the default DB path for all flux-accounting subcommands (#170)

* Remove the positional argument for the `create-db` subcommand (#170)

* Unify the optional database path arguments for all of the `flux account` commands (#171)

#### Features

* Add new instructions to the top-level README on setting up the flux-accounting database, loading the priority plugin, and configuring the automatic update scripts (#157)

flux-accounting version 0.10.0 - 2021-09-30
-------------------------------------------

#### Fixes

* Fix bug in add-user where wrong number of arguments were passed to function (#140)

* Fix bug in edit-user to ensure an edit made in one user/bank row was only made in just that one row instead of in multiple rows in the flux-accounting database (#140)

#### Features

* Add a new front-end update script that will re-calculate users' fairshare values and update them in the flux-accounting database (#138)

* Add new Quality of Service table in the flux-accounting database, which will hold Quality of Services and their associated priorities (#143)

* Add new sharness tests for Python subcommands (#140)

* Remove pandas dependency from flux-accounting, which was required to build/install (#144)

flux-accounting version 0.9.0 - 2021-09-07
------------------------------------------

#### Fixes

* Fix bug where users couldn't be added due to a broken function header (#140)

* Fix bug where a bank's shares could not be edited (#140)

#### Features

* Add a new multi-factor priority plugin that will calculate and push a user's job priority using multiple factors (#122)

* Add a new external service that grabs flux-accounting database information and pushes it to the multi-factor priority plugin (#122)

* Add a max jobs limit to the priority plugin that will enforce a limit of active jobs on a user/bank combination in the flux-accounting database (#131)

* Add a new STDOUT writer class to write user/bank information from a flux-accounting database to STDOUT (#120)

flux-accounting version 0.8.0 - 2021-04-30
------------------------------------------

#### Fixes

* Updated headers of source files in the `fairness` directory (#113)

* Fixed module/dependency installation strategy of flux-accounting on the `bionic` Docker image (#114)

* Fixed bug where old job usage values incorrectly included old factors when applying a decay value (#118)

* Fixed bug where the all job usage factors were incorrectly updated multiple times in one half-life period (#118)

* Fixed bug where a historical job usage value was updated even in the case where no new jobs were found in the current half-life period (#118)

* Fixed bug where the last seen job timestamp was reset to 0 if no new jobs were found for a user (#118)

#### Features

* Added a new `fairshare` field to the `association_table` in a flux-accounting database (#116)

* Added a new `writer` class which will update associations with up-to-date fairshare information (#116)

    * Added a subclass `data_writer_db` which will write fairshare information to a flux-accounting SQLite database

* Added a new subcommand to `flux account` that calculates and updates historical job usage values for every association in the flux-accounting database (#118)

flux-accounting version 0.7.0 - 2021-04-02
------------------------------------------

#### Fixes

* Fixed `ModuleNotFound` error when running Python unit tests on Python `3.6` (#106)

* Removed shebang line from **flux-account.py** to prevent Python version mismatch errors (#101)

#### Features

* Added a new `reader` class which will read flux-accounting information and load it to a `weighted_tree` object (#103)

    * Added a subclass `data_reader_db` which will read and load information from a flux-accounting SQLite database

* Added a new flux subcommand: `flux shares`, which will output a flux-accounting database hierarchy containing user/bank shares and usage information (#109)

flux-accounting version 0.6.0 - 2021-01-29
------------------------------------------

#### Fixes

* Unused variables and imports removed, license in `src/fairness/` changed to LGPL (#90)

* Behavior of `delete-user`, `delete-bank` changed to keep job history of a user after they are removed from the flux-accounting DB (#92)

* `bank` argument added to the `delete-user` subcommand (#95)

#### Features

* `unittest.mock()` integrated with job-archive interface unit tests (#93)

* flux-accounting database can be loaded into weighted tree library to generate fairshare values for users (#97)

flux-accounting version 0.5.0 - 2020-12-18
------------------------------------------

#### Fixes

* `print-hierarchy`'s error output more graceful when there are no accounts (#62)

* `association_table`'s `user_name` field changed to `username` (#67)

* **accounting_cli.py**'s `account` option changed to `bank` (#70)

* variables in **print_hierarchy.cpp** moved from `global` scope (#71)

* Python code converted over to use autotools, TAP, and sharness (#73)

#### Features

* `print-hierarchy` added as a C++ implementation to weighted tree lib (#64)

* `delete-bank` recursively deletes sub banks and associations when a parent bank is deleted (#78)

* `calc_usage_factor()` calculates a user's historical job usage value based on their job history (#79)

flux-accounting version 0.4.0 - 2020-11-06
------------------------------------------

#### Fixes

* `view-job-records` subcommand parameters adjusted to be unpacked as a dictionary (#55)

* Move `view_job_records()` and its helper functions into its own Python module (#57)

#### Features

* Add a library that provides a weighted tree-based fairness (#65)

* Add autogen, automake tools to flux-accounting repo (#65)

flux-accounting version 0.3.0 - 2020-09-30
------------------------------------------

#### Fixes

* `bank_table`'s primary key is now a fixed type (#42)

* `bank_table`'s subcommands no longer impose constraints on values of shares (#44)

* `print-hierarchy`'s format improved to represent a bank and user hierarchy (#51)

flux-accounting version 0.2.0 - 2020-08-31
------------------------------------------

This release adds a new table to the flux-accounting database and a front end to flux-core's job-archive.

#### Features

* Add a new table `bank_table` that stores bank information for users to charge jobs against.

* Add a front-end interface to flux-core's job-archive to fetch job record information and sort it with customizable parameters, such as by username, before or after a specific time, or with a specific job ID.

flux-accounting version 0.1.0 - 2020-07-29
------------------------------------------

Initial release.

#### Features

* Create an accounting database which stores user account information. Can interact with database through SQLite shell or
through a command line interface to add and remove users, edit account values, and view account information.

* Add **Makefile** to allow flux-accounting to be installed alongside flux-core so that flux-accounting commands can be picked up by Flux's command driver.
