#!/bin/bash

certoraRun \
    test/mocks/MathMock.sol \
    --verify MathMock:certora/specs/math.spec \
    --msg "Math" \
    "$@"
