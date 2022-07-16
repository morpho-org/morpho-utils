// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "src/Math.sol";
import "./references/MathRef.sol";

contract TestMath is Test {
    function testMin(uint256 x, uint256 y) public {
        assertEq(Math.min(x, y), MathRef.min(x, y));
    }

    function testMax(uint256 x, uint256 y) public {
        assertEq(Math.max(x, y), MathRef.max(x, y));
    }

    function testGasMin() public pure {
        Math.min(1, 2);
        Math.min(2, 1);
    }

    function testGasMinRef() public pure {
        MathRef.min(1, 2);
        MathRef.min(2, 1);
    }

    function testGasMax() public pure {
        Math.max(1, 2);
        Math.max(2, 1);
    }

    function testGasMaxRef() public pure {
        MathRef.max(1, 2);
        MathRef.max(2, 1);
    }
}
