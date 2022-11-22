#!/bin/sh

certoraRun \
    certora/helpers/MockPercentageMath.sol \
    --verify MockPercentageMath:certora/specs/percentageMath.spec \
    --send_only \
    --msg "PercentageMath" \
    $@
