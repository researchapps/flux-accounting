#!/bin/bash

test_description='Test flux-account commands'
. `dirname $0`/sharness.sh
FLUX_ACCOUNT=${SHARNESS_TEST_SRCDIR}/../src/cmd/flux-account.py
DB_PATH=$(pwd)/FluxAccountingTest.db

test_expect_success 'create flux-accounting DB' '
	flux python ${FLUX_ACCOUNT} -p $(pwd)/FluxAccountingTest.db create-db
'

test_expect_success 'add some banks to the DB' '
	flux python ${FLUX_ACCOUNT} -p ${DB_PATH} add-bank root 1 &&
	flux python ${FLUX_ACCOUNT} -p ${DB_PATH} add-bank --parent-bank=root A 1 &&
	flux python ${FLUX_ACCOUNT} -p ${DB_PATH} add-bank --parent-bank=root B 1 &&
	flux python ${FLUX_ACCOUNT} -p ${DB_PATH} add-bank --parent-bank=root C 1
'

test_expect_success 'add some users to the DB' '
	flux python ${FLUX_ACCOUNT} -p ${DB_PATH} add-user --username=user5011 --userid=5011 --bank=A &&
	flux python ${FLUX_ACCOUNT} -p ${DB_PATH} add-user --username=user5012 --userid=5012 --bank=A &&
	flux python ${FLUX_ACCOUNT} -p ${DB_PATH} add-user --username=user5013 --userid=5013 --bank=B &&
	flux python ${FLUX_ACCOUNT} -p ${DB_PATH} add-user --username=user5014 --userid=5014 --bank=C
'

test_expect_success 'add some QOS to the DB' '
	flux python ${FLUX_ACCOUNT} -p ${DB_PATH} add-qos --qos=standby --priority=0 &&
	flux python ${FLUX_ACCOUNT} -p ${DB_PATH} add-qos --qos=expedite --priority=10000
	flux python ${FLUX_ACCOUNT} -p ${DB_PATH} add-qos --qos=special --priority=99999
'

test_expect_success 'add a QOS to an existing user account' '
	flux python ${FLUX_ACCOUNT} -p ${DB_PATH} edit-user --username=user5011 --field=qos --new-value="expedite"
'

test_expect_success 'trying to add a non-existent QOS to a user account should return an error' '
	flux python ${FLUX_ACCOUNT} -p ${DB_PATH} edit-user --username=user5011 --field=qos --new-value="foo" > bad_qos.out &&
	grep "QOS specified does not exist in qos_table" bad_qos.out
'

test_expect_success 'trying to add a user with a non-existent QOS should also return an error' '
	flux python ${FLUX_ACCOUNT} -p ${DB_PATH} add-user --username=user5015 --userid=5015 --bank=A --qos="foo" > bad_qos2.out &&
	grep "QOS specified does not exist in qos_table" bad_qos2.out
'

test_expect_success 'add multiple QOS to an existing user account' '
	flux python ${FLUX_ACCOUNT} -p ${DB_PATH} edit-user --username=user5012 --field=qos --new-value="expedite,standby" &&
	flux python ${FLUX_ACCOUNT} -p ${DB_PATH} view-user user5012 > user5012.out &&
	grep "expedite,standby" user5012.out
'

test_expect_success 'edit a QOS priority' '
	flux python ${FLUX_ACCOUNT} -p ${DB_PATH} edit-qos --qos=expedite --priority=20000 &&
	flux python ${FLUX_ACCOUNT} -p ${DB_PATH} view-qos --qos=expedite > edited_qos.out &&
	grep "20000" edited_qos.out
'

test_expect_success 'remove a QOS' '
	flux python ${FLUX_ACCOUNT} -p ${DB_PATH} delete-qos --qos=special &&
	flux python ${FLUX_ACCOUNT} -p ${DB_PATH} view-qos --qos=special > deleted_qos.out &&
	grep "QOS not found in qos_table" deleted_qos.out
'

test_expect_success 'trying to view a bank that does not exist in the DB should return an error message' '
	flux python ${FLUX_ACCOUNT} -p ${DB_PATH} view-bank foo > bad_bank.out &&
	grep "Bank not found in bank_table" bad_bank.out
'

test_expect_success 'trying to view a bank that does exist in the DB should return some information' '
	cat <<-EOF >good_bank.expected &&
	bank_id: 2
	bank: A
	parent_bank: root
	shares: 1
	EOF
	flux python ${FLUX_ACCOUNT} -p ${DB_PATH} view-bank A > good_bank.test &&
	test_cmp good_bank.expected good_bank.test
'

test_expect_success 'trying to view a user who does not exist in the DB should return an error message' '
	flux python ${FLUX_ACCOUNT} -p ${DB_PATH} view-user user9999 > bad_user.out &&
	grep "User not found in association_table" bad_user.out
'

test_expect_success 'trying to view a user that does exist in the DB should return some information' '
	flux python ${FLUX_ACCOUNT} -p ${DB_PATH} view-user user5011 > good_user.test &&
	grep "creation_time" good_user.test
'

test_expect_success 'edit a field in a user account' '
	flux python ${FLUX_ACCOUNT} -p ${DB_PATH} edit-user --username=user5011 --field=shares --new-value=50
'

test_expect_success 'edit a field in a bank account' '
	flux python ${FLUX_ACCOUNT} -p ${DB_PATH} edit-bank C --shares=50 &&
	cat <<-EOF >edited_bank.expected &&
	bank_id: 4
	bank: C
	parent_bank: root
	shares: 50
	EOF
	flux python ${FLUX_ACCOUNT} -p ${DB_PATH} view-bank C > edited_bank.test &&
	test_cmp edited_bank.expected edited_bank.test
'

test_expect_success 'remove a bank (and any corresponding users that belong to that bank)' '
	flux python ${FLUX_ACCOUNT} -p ${DB_PATH} delete-bank C
'

test_expect_success 'make sure both the DB and the user are successfully removed from DB' '
	flux python ${FLUX_ACCOUNT} -p ${DB_PATH} view-bank C > deleted_bank.out &&
	grep "Bank not found in bank_table" deleted_bank.out &&
	flux python ${FLUX_ACCOUNT} -p ${DB_PATH} view-user user5014 > deleted_user.out &&
	grep "User not found in association_table" deleted_user.out
'

test_expect_success 'remove a user account' '
	flux python ${FLUX_ACCOUNT} -p ${DB_PATH} delete-user user5012 A
'

test_expect_success 'make sure the user is successfully removed from the DB' '
	flux python ${FLUX_ACCOUNT} -p ${DB_PATH} view-user user5012 > deleted_user.out &&
	grep "User not found in association_table" deleted_user.out
'

test_expect_success 'remove flux-accounting DB' '
	rm $(pwd)/FluxAccountingTest.db
'

test_done
