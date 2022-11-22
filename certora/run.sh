#!/bin/sh

certoraRun                                                          \
    certora/helpers/MockMath.sol                                    \
    --verify MockMath:certora/specs/math.spec                       \
    --send_only                                                     \
    --msg "Math"                                                    \
    $@

certoraRun                                                          \
    certora/helpers/MockWadRayMath.sol                              \
    --verify MockWadRayMath:certora/specs/wadRayMath.spec           \
    --send_only                                                     \
    --msg "WadRayMath"                                              \
    $@

certoraRun                                                          \
    certora/helpers/MockPercentageMath.sol                          \
    --verify MockPercentageMath:certora/specs/percentageMath.spec   \
    --send_only                                                     \
    --msg "PercentageMath"                                          \
    $@

certoraRun                                                          \
    certora/helpers/MockCompoundMath.sol                            \
    --verify MockCompoundMath:certora/specs/compoundMath.spec       \
    --send_only                                                     \
    --msg "CompoundMath"                                            \
    $@
