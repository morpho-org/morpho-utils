#!/bin/bash

certoraRun \
    test/mocks/MathMock.sol \
    --verify MathMock:certora/specs/bitvectorMath.spec \
    --settings -useBitVectorTheory \
    --msg "Math" \
    $@
