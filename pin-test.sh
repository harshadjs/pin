#!/bin/bash
TMPDIR=/tmp/pin-test
rm -f .pin
export PIN_PROG=./pin

function _setup() {
    export PIN_CFG=$TMP/pin.config
    mkdir $TMP/cmds
    echo "HIDE_SHA1=true" > $PIN_CFG
    echo "CMDS_DIR=$TMP/cmds" >> $PIN_CFG
    echo "COLOURED_OUTPUT=false" >> $PIN_CFG
}

rm -rf $TMPDIR
mkdir $TMPDIR

for test in $(ls tests | grep -v ".out"); do
    export PIN_INPUT=tests/$test/pin-input
    mkdir $TMPDIR/$test
    export TMP=$TMPDIR/$test
    export TESTDIR=tests/$test/
    . tests/$test/script > tests/$test.out
done

for test in $(ls tests | grep -v ".out"); do
    diff tests/$test.out tests/$test/output > $TMPDIR/diff
    if [ "$?" = "0" ]; then
	echo -ne "[OK]   "
    else
	cat $TMPDIR/diff
	echo -ne "[FAIL] "
    fi
    echo  "$(cat tests/$test/name)"
done
