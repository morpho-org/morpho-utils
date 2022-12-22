// SPDX-License-Identifier: GNU AGPLv3
pragma solidity ^0.8.0;

contract MathRef {
    function min(uint256 x, uint256 y) external pure returns (uint256) {
        return x < y ? x : y;
    }

    function max(uint256 x, uint256 y) external pure returns (uint256) {
        return x > y ? x : y;
    }

    function zeroFloorSub(uint256 x, uint256 y) external pure returns (uint256) {
        return x > y ? x - y : 0;
    }

    function divUp(uint256 x, uint256 y) external pure returns (uint256) {
        return (x + y - 1) / y;
    }

    function log2Naive(uint256 x) external pure returns (uint256) {
        for (uint256 i = 255; i > 0; i--) if (x >= 2**i) return i;
        return 0;
    }
}
