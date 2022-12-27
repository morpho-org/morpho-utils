// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.0;

contract CompoundMathRef {
    function mul(uint256 x, uint256 y) external pure returns (uint256) {
        return (x * y) / 1e18;
    }

    function div(uint256 x, uint256 y) external pure returns (uint256) {
        return ((1e18 * x * 1e18) / y) / 1e18;
    }
}
