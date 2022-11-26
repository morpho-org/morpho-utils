#!/bin/bash

certoraRun \
    certora/helpers/MockMath.sol \
    --verify MockMath:certora/specs/math.spec \
    --settings -useBitVectorTheory \
    --msg "Math" \
    $@


