// SPDX-License-Identifier: AGPL-3.0-only
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
        for (uint256 i = 255; i > 0; i--) {
            if (x >= 2 ** i) return i;
        }
        return 0;
    }

    function log2DichoBetween(uint256 x, uint256 start, uint256 end) internal pure returns (uint256) {
        if (end - start <= 1) return start;
        uint256 mid = (start + end) / 2;
        if (x < 2 ** mid) return log2DichoBetween(x, start, mid);
        else return log2DichoBetween(x, mid, end);
    }

    function log2Dichotomy(uint256 x) external pure returns (uint256) {
        return log2DichoBetween(x, 0, 256);
    }
}
