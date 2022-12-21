// SPDX-License-Identifier: GNU AGPLv3
pragma solidity ^0.8.0;

import {CompoundMath} from "src/math/CompoundMath.sol";

contract CompoundMathMock {
    function mul(uint256 x, uint256 y) public pure returns (uint256) {
        return CompoundMath.mul(x, y);
    }

    function div(uint256 x, uint256 y) public pure returns (uint256) {
        return CompoundMath.div(x, y);
    }
}
