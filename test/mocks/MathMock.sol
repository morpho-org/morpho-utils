// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.0;

import {Math} from "src/math/Math.sol";

contract MathMock {
    function min(uint256 x, uint256 y) public pure returns (uint256) {
        return Math.min(x, y);
    }

    function max(uint256 x, uint256 y) public pure returns (uint256) {
        return Math.max(x, y);
    }

    function zeroFloorSub(uint256 x, uint256 y) public pure returns (uint256) {
        return Math.zeroFloorSub(x, y);
    }

    function divUp(uint256 x, uint256 y) public pure returns (uint256) {
        return Math.divUp(x, y);
    }

    function log2(uint256 x) public pure returns (uint256) {
        return Math.log2(x);
    }
}
