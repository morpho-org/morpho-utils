#!/bin/sh

certora/scripts/verifyCompoundMath.sh $@ 1> /dev/null
certora/scripts/verifyMath.sh $@ 1> /dev/null
certora/scripts/verifyPercentageMath.sh $@ 1> /dev/null
certora/scripts/verifyWadRayMath.sh $@ 1> /dev/null
