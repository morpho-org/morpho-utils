#!/bin/bash

certoraRun \
    test/mocks/PercentageMathMock.sol \
    --verify PercentageMathMock:certora/specs/percentageMath.spec \
    --msg "PercentageMath" \
    $@
