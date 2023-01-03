// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.0;

import {PercentageMath} from "src/math/PercentageMath.sol";

contract PercentageMathMock {
    function percentAdd(uint256 x, uint256 y) public pure returns (uint256) {
        return PercentageMath.percentAdd(x, y);
    }

    function percentSub(uint256 x, uint256 y) public pure returns (uint256) {
        return PercentageMath.percentSub(x, y);
    }

    function percentMul(uint256 x, uint256 y) public pure returns (uint256) {
        return PercentageMath.percentMul(x, y);
    }

    function percentMulDown(uint256 x, uint256 y) public pure returns (uint256) {
        return PercentageMath.percentMulDown(x, y);
    }

    function percentMulUp(uint256 x, uint256 y) public pure returns (uint256) {
        return PercentageMath.percentMulUp(x, y);
    }

    function percentDiv(uint256 x, uint256 y) public pure returns (uint256) {
        return PercentageMath.percentDiv(x, y);
    }

    function percentDivDown(uint256 x, uint256 y) public pure returns (uint256) {
        return PercentageMath.percentDivDown(x, y);
    }

    function percentDivUp(uint256 x, uint256 y) public pure returns (uint256) {
        return PercentageMath.percentDivUp(x, y);
    }

    function weightedAvg(uint256 x, uint256 y, uint256 percentage) public pure returns (uint256) {
        return PercentageMath.weightedAvg(x, y, percentage);
    }
}
