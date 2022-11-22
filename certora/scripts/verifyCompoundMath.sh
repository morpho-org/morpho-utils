#!/bin/bash

set -euxo pipefail

certoraRun \
    certora/helpers/MockCompoundMath.sol \
    --verify MockCompoundMath:certora/specs/compoundMath.spec \
    --msg "CompoundMath" \
    $@
