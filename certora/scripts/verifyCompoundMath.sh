#!/bin/bash

certoraRun \
    certora/helpers/MockCompoundMath.sol \
    --verify MockCompoundMath:certora/specs/compoundMath.spec \
    --msg "CompoundMath" \
    $@
