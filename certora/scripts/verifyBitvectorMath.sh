#!/bin/bash

certoraRun \
    test/mocks/MathMock.sol \
    --verify MathMock:certora/specs/bitvectorMath.spec \
    --prover_args "-useBitVectorTheory" \
    --msg "Math" \
    "$@"
