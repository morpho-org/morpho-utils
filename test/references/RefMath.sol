// SPDX-License-Identifier: GNU AGPLv3
pragma solidity ^0.8.0;

library RefMath {
    function min(uint256 x, uint256 y) internal pure returns (uint256) {
        return x < y ? x : y;
    }

    function max(uint256 x, uint256 y) internal pure returns (uint256) {
        return x > y ? x : y;
    }

    function safeSub(uint256 x, uint256 y) internal pure returns (uint256) {
        return x >= y ? x - y : 0;
    }
}
