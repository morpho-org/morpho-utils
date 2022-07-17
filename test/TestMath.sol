// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "src/Math.sol";
import "./references/MathRef.sol";

contract TestMath is Test {
    MathFunctions math;
    MathFunctionsRef mathRef;

    function setUp() public {
        math = new MathFunctions();
        mathRef = new MathFunctionsRef();
    }

    /// TESTS ///

    function testMin(uint256 x, uint256 y) public {
        assertEq(math.min(x, y), mathRef.min(x, y));
    }

    function testMax(uint256 x, uint256 y) public {
        assertEq(math.max(x, y), mathRef.max(x, y));
    }

    // GAS COMPARISONS ///

    function testGasMin() public view {
        math.min(1, 2);
        math.min(2, 1);
        mathRef.min(1, 2);
        mathRef.min(2, 1);
    }

    function testGasMax() public view {
        math.max(1, 2);
        math.max(2, 1);
        mathRef.max(1, 2);
        mathRef.max(2, 1);
    }
}

contract MathFunctions {
    function min(uint256 x, uint256 y) public pure returns (uint256) {
        return Math.min(x, y);
    }

    function max(uint256 x, uint256 y) public pure returns (uint256) {
        return Math.max(x, y);
    }
}

contract MathFunctionsRef {
    function min(uint256 x, uint256 y) public pure returns (uint256) {
        return MathRef.min(x, y);
    }

    function max(uint256 x, uint256 y) public pure returns (uint256) {
        return MathRef.max(x, y);
    }
}
