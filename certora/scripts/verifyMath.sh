#!/bin/sh

certoraRun \
    certora/helpers/MockMath.sol \
    --verify MockMath:certora/specs/math.spec \
    --send_only \
    --settings -useBitVectorTheory \
    --msg "Math" \
    $@


