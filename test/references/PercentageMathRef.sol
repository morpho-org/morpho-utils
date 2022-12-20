// SPDX-License-Identifier: GNU AGPLv3
pragma solidity ^0.8.0;

import {PercentageMath} from "@aave/core-v3/contracts/protocol/libraries/math/PercentageMath.sol";

contract PercentageMathRef {
    function percentAdd(uint256 x, uint256 y) public pure returns (uint256) {
        return PercentageMath.percentMul(x, PercentageMath.PERCENTAGE_FACTOR + y);
    }

    function percentSub(uint256 x, uint256 y) public pure returns (uint256) {
        return PercentageMath.percentMul(x, PercentageMath.PERCENTAGE_FACTOR - y);
    }

    function percentMul(uint256 x, uint256 y) public pure returns (uint256) {
        return PercentageMath.percentMul(x, y);
    }

    function percentDiv(uint256 x, uint256 y) public pure returns (uint256) {
        return PercentageMath.percentDiv(x, y);
    }

    function weightedAvg(
        uint256 x,
        uint256 y,
        uint256 percentage
    ) public pure returns (uint256) {
        return
            (x *
                (PercentageMath.PERCENTAGE_FACTOR - percentage) +
                y *
                percentage +
                PercentageMath.HALF_PERCENTAGE_FACTOR) / PercentageMath.PERCENTAGE_FACTOR;
    }
}