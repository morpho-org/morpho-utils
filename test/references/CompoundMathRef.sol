// SPDX-License-Identifier: GNU AGPLv3
pragma solidity ^0.8.0;

library CompoundMathRef {
    function mul(uint256 x, uint256 y) internal pure returns (uint256) {
        return (x * y) / 1e18;
    }

    function div(uint256 x, uint256 y) internal pure returns (uint256) {
        return ((1e18 * x * 1e18) / y) / 1e18;
    }
}
