#!/bin/bash

set -euxo pipefail

certora/scripts/verifyCompoundMath.sh $@
certora/scripts/verifyMath.sh $@
certora/scripts/verifyPercentageMath.sh $@
certora/scripts/verifyWadRayMath.sh $@
