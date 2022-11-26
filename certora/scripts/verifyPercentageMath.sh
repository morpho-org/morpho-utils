#!/bin/bash

certoraRun \
    certora/helpers/MockPercentageMath.sol \
    --verify MockPercentageMath:certora/specs/percentageMath.spec \
    --msg "PercentageMath" \
    $@
