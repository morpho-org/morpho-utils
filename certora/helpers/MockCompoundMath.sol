// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "src/math/CompoundMath.sol";

contract MockCompoundMath {
    function mul(uint256 x, uint256 y) public pure returns (uint256) {
        return CompoundMath.mul(x, y);
    }

    function div(uint256 x, uint256 y) public pure returns (uint256) {
        return CompoundMath.div(x, y);
    }
}

