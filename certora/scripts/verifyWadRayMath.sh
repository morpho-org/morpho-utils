#!/bin/bash

set -euxo pipefail

certoraRun \
    certora/helpers/MockWadRayMath.sol \
    --verify MockWadRayMath:certora/specs/wadRayMath.spec \
    --msg "WadRayMath" \
    $@

