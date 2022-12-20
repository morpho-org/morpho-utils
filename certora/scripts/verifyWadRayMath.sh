#!/bin/bash

certoraRun \
    test/mocks/WadRayMathMock.sol \
    --verify WadRayMathMock:certora/specs/wadRayMath.spec \
    --msg "WadRayMath" \
    $@

