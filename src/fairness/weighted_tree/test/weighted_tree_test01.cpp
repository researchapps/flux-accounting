/*****************************************************************************\
 *  Copyright (c) 2014 Lawrence Livermore National Security, LLC.  Produced at
 *  the Lawrence Livermore National Laboratory (cf, AUTHORS, DISCLAIMER.LLNS).
 *  LLNL-CODE-658032 All rights reserved.
 *
 *  This file is part of the Flux resource manager framework.
 *  For details, see https://github.com/flux-framework.
 *
 *  This program is free software; you can redistribute it and/or modify it
 *  under the terms of the GNU General Public License as published by the Free
 *  Software Foundation; either version 2 of the license, or (at your option)
 *  any later version.
 *
 *  Flux is distributed in the hope that it will be useful, but WITHOUT
 *  ANY WARRANTY; without even the IMPLIED WARRANTY OF MERCHANTABILITY or
 *  FITNESS FOR A PARTICULAR PURPOSE.  See the terms and conditions of the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License along
 *  with this program; if not, write to the Free Software Foundation, Inc.,
 *  59 Temple Place, Suite 330, Boston, MA 02111-1307 USA.
 *  See also:  http://www.gnu.org/licenses/
\*****************************************************************************/

#if HAVE_CONFIG_H
# include <config.h>
#endif

#include <algorithm>
#include <iostream>
#include <fstream>
#include "src/fairness/weighted_tree/test/weighted_tree_load.hpp"
#include "src/common/libtap/tap.h"

using namespace Flux::accounting;

static void test_tree_from_file (const std::string &filename,
                                 const std::vector<std::string> &expected)
{
    int rc = 0, i = 0;
    bool bo = true;
    uint64_t nlines = 0, nleaves = 0;
    std::shared_ptr<weighted_tree_node_t> root = nullptr;
    std::ifstream ifs (filename);
    std::ostringstream out;
    std::string line;

    std::stringstream buffer;
    buffer << ifs.rdbuf ();
    ifs.close ();

    while (std::getline (buffer, line)) {
        std::string token;
        std::stringstream ss (line);
        std::getline (ss, token, ',');
        std::getline (ss, token, ',');
        std::getline (ss, token, ',');
        nlines++;
        if (token != "%^+_nouser")
            nleaves++;
    }

    rc = load_weighted_tree (filename, root);

    ok ( (rc == 0),
         "%s: load a weighted tree with cluster.csv.", filename.c_str ());

    weighted_walk_t walker (root);
    walker.dprint_csv (out);

    ok ( (out.str () == buffer.str ()),
         "%s: tree data is identical with input.", filename.c_str ());
    ok ( (nlines == walker.get_tree_size ()),
         "%s: tree size is correct.", filename.c_str ());
    ok ( (nleaves == walker.get_tree_leaf_size ()),
         "%s: leaf size is correct.", filename.c_str ());

    walker.run ();

    const auto &users = walker.get_users ();
    ok ( (users.size () == expected.size ()),
         "%s: num of users is correct", filename.c_str ());
    for (i = 0; i < static_cast<int> (users.size ()); i++) {
        bo = bo && (users[i]->get_name () == expected[i]);
    }
    ok (bo, "%s: fairshare order is correct", filename.c_str ());

    return;
}

static void test_weighted_small_no_tie ()
{
    const std::string filename = "./accounts_data/small_no_tie.csv";
    std::vector<std::string> expected;
    expected.push_back ("leaf.3.1");
    expected.push_back ("leaf.3.2");
    expected.push_back ("leaf.2.1");
    expected.push_back ("leaf.2.2");
    expected.push_back ("leaf.1.3");
    expected.push_back ("leaf.1.1");
    expected.push_back ("leaf.1.2");

    test_tree_from_file (filename, expected);
}

static void test_weighted_small_tie ()
{
    const std::string filename = "./accounts_data/small_tie.csv";
    std::vector<std::string> expected;
    expected.push_back ("leaf.3.1");
    expected.push_back ("leaf.3.2");
    expected.push_back ("leaf.1.3");
    expected.push_back ("leaf.2.3");
    expected.push_back ("leaf.1.2");
    expected.push_back ("leaf.2.2");
    expected.push_back ("leaf.1.1");
    expected.push_back ("leaf.2.1");

    test_tree_from_file (filename, expected);
}

static void test_weighted_small_tie_diff_type ()
{
    const std::string filename = "./accounts_data/small_tie_diff_type.csv";
    std::vector<std::string> expected;
    expected.push_back ("leaf.3.1");
    expected.push_back ("leaf.3.2");
    expected.push_back ("leaf.0.1");
    expected.push_back ("leaf.1.3");
    expected.push_back ("leaf.1.2");
    expected.push_back ("leaf.1.1");

    test_tree_from_file (filename, expected);
}

static void test_weighted_small_tie_all ()
{
    const std::string filename = "./accounts_data/small_tie_all.csv";
    std::vector<std::string> expected;
    expected.push_back ("leaf.1.3");
    expected.push_back ("leaf.2.3");
    expected.push_back ("leaf.3.3");
    expected.push_back ("leaf.1.2");
    expected.push_back ("leaf.2.2");
    expected.push_back ("leaf.3.2");
    expected.push_back ("leaf.1.1");
    expected.push_back ("leaf.2.1");
    expected.push_back ("leaf.3.1");

    test_tree_from_file (filename, expected);
}

static void test_weighted_small_zero_shares ()
{
    const std::string filename = "./accounts_data/small_zero_shares.csv";
    std::vector<std::string> expected;
    expected.push_back ("leaf.3.1");
    expected.push_back ("leaf.3.2");
    expected.push_back ("leaf.2.3");
    expected.push_back ("leaf.1.3");
    expected.push_back ("leaf.1.2");
    expected.push_back ("leaf.1.1");
    expected.push_back ("leaf.2.1");
    expected.push_back ("leaf.2.2");

    test_tree_from_file (filename, expected);
}

static void test_weighted_minimal ()
{
    const std::string filename = "./accounts_data/minimal.csv";
    std::vector<std::string> expected;

    test_tree_from_file (filename, expected);
}

int main (int argc, char *argv[])
{
    plan (36);

    test_weighted_small_no_tie ();

    test_weighted_small_tie ();

    test_weighted_small_tie_diff_type ();

    test_weighted_small_tie_all ();

    test_weighted_small_zero_shares ();

    test_weighted_minimal ();

    done_testing ();

    return EXIT_SUCCESS;
}

/*
 * vi:tabstop=4 shiftwidth=4 expandtab
 */
