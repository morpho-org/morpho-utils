// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "forge-std/Vm.sol";
import "src/math/Math.sol";
import "./references/MathRef.sol";

contract MathFunctions {
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
}

contract MathFunctionsRef {
    function min(uint256 x, uint256 y) public pure returns (uint256) {
        return MathRef.min(x, y);
    }

    function max(uint256 x, uint256 y) public pure returns (uint256) {
        return MathRef.max(x, y);
    }

    function zeroFloorSub(uint256 x, uint256 y) public pure returns (uint256) {
        return MathRef.zeroFloorSub(x, y);
    }

    function divUp(uint256 x, uint256 y) public pure returns (uint256) {
        return MathRef.divUp(x, y);
    }
}

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

    function testSafeSub(uint256 x, uint256 y) public {
        assertEq(math.zeroFloorSub(x, y), mathRef.zeroFloorSub(x, y));
    }

    function testDivUpRevertWhenDivByZero(uint256 x) public {
        vm.expectRevert();
        Math.divUp(x, 0);
    }

    function testDivUpWhenNumSmaller(uint256 x, uint256 y) public {
        vm.assume(x > 0);
        vm.assume(x < y);
        assertEq(math.divUp(x, y), 1);
    }

    function testDivUpWhenOperandsEqual(uint256 x) public {
        vm.assume(x > 0);
        assertEq(math.divUp(x, x), 1);
    }

    function testDivUpWhenNumLargerAndDivisible(uint256 x, uint256 y) public {
        vm.assume(y > 0);
        vm.assume(x > y);
        vm.assume(x % y == 0);
        assertEq(math.divUp(x, y), x / y);
    }

    function testDivUpWhenNumLargerAndNotDivisible(uint256 x, uint256 y) public {
        vm.assume(y > 0);
        vm.assume(x > y);
        vm.assume(x % y != 0);
        assertEq(math.divUp(x, y), x / y + 1);
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

    function testGasSafeSub() public view {
        math.zeroFloorSub(10, 11);
        mathRef.zeroFloorSub(10, 11);
    }

    function testGasDivUp() public view {
        math.divUp(20, 10);
        mathRef.divUp(20, 10);
    }
}
