#!/bin/sh

certoraRun                                                          \
    certora/helpers/MockCompoundMath.sol                            \
    --verify MockCompoundMath:certora/specs/compoundMath.spec       \
    --send_only                                                     \
    --msg "CompoundMath"                                            \
    $@
