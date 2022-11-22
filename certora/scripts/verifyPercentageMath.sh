#!/bin/bash

set -euxo pipefail

certoraRun \
    certora/helpers/MockPercentageMath.sol \
    --verify MockPercentageMath:certora/specs/percentageMath.spec \
    --msg "PercentageMath" \
    $@
