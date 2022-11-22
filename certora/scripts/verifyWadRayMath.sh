#!/bin/sh

certoraRun \
    certora/helpers/MockWadRayMath.sol \
    --verify MockWadRayMath:certora/specs/wadRayMath.spec \
    --send_only \
    --msg "WadRayMath" \
    $@

