#!/bin/bash

set -euxo pipefail

certoraRun \
    certora/helpers/MockMath.sol \
    --verify MockMath:certora/specs/math.spec \
    --settings -useBitVectorTheory \
    --msg "Math" \
    $@


