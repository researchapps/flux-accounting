#!/usr/bin/env python3

###############################################################
# Copyright 2020 Lawrence Livermore National Security, LLC
# (c.f. AUTHORS, NOTICE.LLNS, COPYING)
#
# This file is part of the Flux resource manager framework.
# For details, see https://github.com/flux-framework.
#
# SPDX-License-Identifier: LGPL-3.0
###############################################################
import sqlite3
import argparse
import time
import sys

import pandas as pd

from accounting import accounting_cli_functions as aclif


def main():

    parser = argparse.ArgumentParser(
        description="""
        Description: Translate command line arguments into
        SQLite instructions for the Flux Accounting Database.
        """
    )
    subparsers = parser.add_subparsers(help="sub-command help",)

    parser.add_argument(
        "-p", "--path", dest="path", help="specify location of database file"
    )

    parser.add_argument(
        "-o",
        "--output-file",
        dest="output_file",
        help="specify location of output file",
    )

    subparser_view_user = subparsers.add_parser(
        "view-user", help="view a user's information in the accounting database"
    )
    subparser_view_user.set_defaults(func="view_user")
    subparser_view_user.add_argument("username", help="username", metavar=("USERNAME"))

    subparser_add_user = subparsers.add_parser(
        "add-user", help="add a user to the accounting database"
    )
    subparser_add_user.set_defaults(func="add_user")
    subparser_add_user.add_argument(
        "--username", help="username", metavar="USERNAME",
    )
    subparser_add_user.add_argument(
        "--admin-level", help="admin level", default=1, metavar="ADMIN_LEVEL",
    )
    subparser_add_user.add_argument(
        "--account", help="account to charge jobs against", metavar="ACCOUNT",
    )
    subparser_add_user.add_argument(
        "--parent-acct", help="parent account", default="", metavar="PARENT_ACCOUNT",
    )
    subparser_add_user.add_argument(
        "--shares", help="shares", default=1, metavar="SHARES",
    )
    subparser_add_user.add_argument(
        "--max-jobs", help="max jobs", default=1, metavar="MAX_JOBS",
    )
    subparser_add_user.add_argument(
        "--max-wall-pj",
        help="max wall time per job",
        default=60,
        metavar="MAX_WALL_PJ",
    )

    subparser_delete_user = subparsers.add_parser(
        "delete-user", help="remove a user from the accounting database"
    )
    subparser_delete_user.set_defaults(func="delete_user")
    subparser_delete_user.add_argument(
        "username", help="username", metavar=("USERNAME")
    )

    subparser_edit_user = subparsers.add_parser("edit-user", help="edit a user's value")
    subparser_edit_user.set_defaults(func="edit_user")
    subparser_edit_user.add_argument(
        "--username", help="username", metavar="USERNAME",
    )
    subparser_edit_user.add_argument(
        "--field", help="column name", metavar="FIELD",
    )
    subparser_edit_user.add_argument(
        "--new-value", help="new value", metavar="VALUE",
    )

    subparser_view_jobs_by_username = subparsers.add_parser(
        "by-user", help="show jobs run by username"
    )
    subparser_view_jobs_by_username.set_defaults(func="view_jobs_run_by_username")
    subparser_view_jobs_by_username.add_argument(
        "username", help="username", metavar="USERNAME",
    )

    subparser_view_job_by_jobid = subparsers.add_parser(
        "by-jobid", help="show job info from jobid"
    )
    subparser_view_job_by_jobid.set_defaults(func="view_jobs_with_jobid")
    subparser_view_job_by_jobid.add_argument(
        "jobid", help="jobid", metavar="JOBID",
    )

    subparser_view_jobs_after_start_time = subparsers.add_parser(
        "after-start-time", help="show jobs that completed after start time"
    )
    subparser_view_jobs_after_start_time.set_defaults(func="view_jobs_after_start_time")
    subparser_view_jobs_after_start_time.add_argument(
        "start_time", help="start time", metavar="START TIME",
    )

    subparser_view_jobs_before_end_time = subparsers.add_parser(
        "before-end-time", help="show jobs that completed before end time"
    )
    subparser_view_jobs_before_end_time.set_defaults(func="view_jobs_before_end_time")
    subparser_view_jobs_before_end_time.add_argument(
        "end_time", help="end time", metavar="END TIME",
    )

    args = parser.parse_args()

    # try to open database file; will exit with -1 if database file not found
    path = args.path if args.path else "FluxAccounting.db"
    try:
        conn = sqlite3.connect("file:" + path + "?mode=rw", uri=True)
    except sqlite3.OperationalError:
        print("Unable to open database file")
        sys.exit(-1)

    # set path for output file
    output_file = args.output_file if args.output_file else None

    try:
        if args.func == "view_user":
            aclif.view_user(conn, args.username)
        elif args.func == "add_user":
            aclif.add_user(
                conn,
                args.username,
                args.admin_level,
                args.account,
                args.parent_acct,
                args.shares,
                args.max_jobs,
                args.max_wall_pj,
            )
        elif args.func == "delete_user":
            aclif.delete_user(conn, args.username)
        elif args.func == "edit_user":
            aclif.edit_user(conn, args.username, args.field, args.new_value)
        elif args.func == "view_jobs_run_by_username":
            aclif.view_jobs_run_by_username(conn, args.username, args.output_file)
        elif args.func == "view_jobs_with_jobid":
            aclif.view_jobs_with_jobid(conn, args.jobid, args.output_file)
        elif args.func == "view_jobs_after_start_time":
            aclif.view_jobs_after_start_time(conn, args.start_time, args.output_file)
        elif args.func == "view_jobs_before_end_time":
            aclif.view_jobs_before_end_time(conn, args.end_time, args.output_file)
        else:
            print(parser.print_usage())
    finally:
        conn.close()


if __name__ == "__main__":
    main()
