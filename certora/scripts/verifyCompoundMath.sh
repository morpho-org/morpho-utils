#!/bin/bash

certoraRun \
    test/mocks/CompoundMathMock.sol \
    --verify CompoundMathMock:certora/specs/compoundMath.spec \
    --msg "CompoundMath" \
    $@
