// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "forge-std/Vm.sol";
import {PercentageMath} from "src/math/PercentageMath.sol";
import {PercentageMath as PercentageMathRef} from "@aave/core-v3/contracts/protocol/libraries/math/PercentageMath.sol";

contract PercentageMathFunctions {
    function percentAdd(uint256 x, uint256 y) public pure returns (uint256) {
        return PercentageMath.percentAdd(x, y);
    }

    function percentSub(uint256 x, uint256 y) public pure returns (uint256) {
        return PercentageMath.percentSub(x, y);
    }

    function percentMul(uint256 x, uint256 y) public pure returns (uint256) {
        return PercentageMath.percentMul(x, y);
    }

    function percentDiv(uint256 x, uint256 y) public pure returns (uint256) {
        return PercentageMath.percentDiv(x, y);
    }

    function weightedAvg(
        uint256 x,
        uint256 y,
        uint256 percentage
    ) public pure returns (uint256) {
        return PercentageMath.weightedAvg(x, y, percentage);
    }
}

contract PercentageMathFunctionsRef {
    function percentAdd(uint256 x, uint256 y) public pure returns (uint256) {
        return PercentageMathRef.percentMul(x, PercentageMathRef.PERCENTAGE_FACTOR + y);
    }

    function percentSub(uint256 x, uint256 y) public pure returns (uint256) {
        return PercentageMathRef.percentMul(x, PercentageMathRef.PERCENTAGE_FACTOR - y);
    }

    function percentMul(uint256 x, uint256 y) public pure returns (uint256) {
        return PercentageMathRef.percentMul(x, y);
    }

    function percentDiv(uint256 x, uint256 y) public pure returns (uint256) {
        return PercentageMathRef.percentDiv(x, y);
    }

    function weightedAvg(
        uint256 x,
        uint256 y,
        uint256 percentage
    ) public pure returns (uint256) {
        return
            PercentageMathRef.percentMul(x, PercentageMathRef.PERCENTAGE_FACTOR - percentage) +
            PercentageMathRef.percentMul(y, percentage);
    }
}

contract TestPercentageMath is Test {
    uint256 internal constant PERCENTAGE_FACTOR = 1e4;
    uint256 internal constant HALF_PERCENTAGE_FACTOR = 0.5e4;
    uint256 internal constant MAX_UINT256 = 2**256 - 1;
    uint256 internal constant MAX_UINT256_MINUS_HALF_PERCENTAGE = 2**256 - 1 - 0.5e4;

    PercentageMathFunctions math;
    PercentageMathFunctionsRef mathRef;

    function setUp() public {
        math = new PercentageMathFunctions();
        mathRef = new PercentageMathFunctionsRef();
    }

    /// TESTS ///

    function testPercentAddZero(uint256 x) public {
        vm.assume(x <= MAX_UINT256 / PERCENTAGE_FACTOR);

        assertEq(PercentageMath.percentAdd(x, 0), x);
    }

    function testPercentAdd(uint256 x, uint256 y) public {
        vm.assume(y <= MAX_UINT256 - PERCENTAGE_FACTOR);
        vm.assume(x <= MAX_UINT256 / (PERCENTAGE_FACTOR + y));

        assertApproxEqAbs(PercentageMath.percentAdd(x, y), (x * (PERCENTAGE_FACTOR + y)) / PERCENTAGE_FACTOR, 1);
    }

    function testPercentAddOverflow(uint256 x, uint256 y) public {
        vm.assume(y > MAX_UINT256 - PERCENTAGE_FACTOR);

        vm.expectRevert(stdError.arithmeticError);
        PercentageMath.percentAdd(x, y);
    }

    function testPercentSubZero(uint256 x) public {
        vm.assume(x <= MAX_UINT256 / PERCENTAGE_FACTOR);

        assertEq(PercentageMath.percentSub(x, 0), x);
    }

    function testPercentSubMax(uint256 x) public {
        assertEq(PercentageMath.percentSub(x, PERCENTAGE_FACTOR), 0);
    }

    function testPercentSub(uint256 x, uint256 y) public {
        vm.assume(y <= PERCENTAGE_FACTOR);
        vm.assume(x <= MAX_UINT256 / (PERCENTAGE_FACTOR - y));

        assertApproxEqAbs(PercentageMath.percentSub(x, y), (x * (PERCENTAGE_FACTOR - y)) / PERCENTAGE_FACTOR, 1);
    }

    function testPercentSubUnderflow(uint256 x, uint256 y) public {
        vm.assume(y > PERCENTAGE_FACTOR);

        vm.expectRevert(stdError.arithmeticError);
        PercentageMath.percentSub(x, y);
    }

    function testPercentMul(uint256 x, uint256 y) public {
        vm.assume(y == 0 || x <= MAX_UINT256_MINUS_HALF_PERCENTAGE / y);

        assertEq(PercentageMath.percentMul(x, y), PercentageMathRef.percentMul(x, y));
    }

    function testPercentMulOverflow(uint256 x, uint256 y) public {
        vm.assume(y > 0 && x > MAX_UINT256_MINUS_HALF_PERCENTAGE / y);

        vm.expectRevert();
        PercentageMath.percentMul(x, y);
    }

    function testPercentDiv(uint256 x, uint256 y) public {
        vm.assume(y > 0 && x <= (MAX_UINT256 - y / 2) / PERCENTAGE_FACTOR);

        assertEq(PercentageMath.percentDiv(x, y), PercentageMathRef.percentDiv(x, y));
    }

    function testPercentDivOverflow(uint256 x, uint256 y) public {
        vm.assume(x > (MAX_UINT256 - y / 2) / PERCENTAGE_FACTOR);

        vm.expectRevert();
        PercentageMath.percentDiv(x, y);
    }

    function testPercentDivByZero(uint256 x, uint256 y) public {
        vm.assume(y == 0);

        vm.expectRevert();
        PercentageMath.percentDiv(x, y);
    }

    function testWeightedAvg(
        uint256 x,
        uint256 y,
        uint16 percentage
    ) public {
        vm.assume(percentage <= PERCENTAGE_FACTOR);
        if (percentage > 0) vm.assume(y <= MAX_UINT256_MINUS_HALF_PERCENTAGE / percentage);
        if (percentage < PERCENTAGE_FACTOR)
            vm.assume(x <= MAX_UINT256_MINUS_HALF_PERCENTAGE / (PERCENTAGE_FACTOR - percentage));

        assertApproxEqAbs(
            PercentageMath.weightedAvg(x, y, percentage),
            ((x * (PERCENTAGE_FACTOR - percentage)) + (y * percentage)) / PERCENTAGE_FACTOR,
            1
        );
    }

    function testWeightedAvgUnderflow(
        uint256 x,
        uint256 y,
        uint256 percentage
    ) public {
        vm.assume(percentage > PERCENTAGE_FACTOR);

        vm.expectRevert(stdError.arithmeticError);
        PercentageMath.weightedAvg(x, y, percentage);
    }

    /// GAS COMPARISONS ///

    function testGasPercentageAdd() public view {
        math.percentAdd(1 ether, 1_000);
        mathRef.percentAdd(1 ether, 1_000);
    }

    function testGasPercentageSub() public view {
        math.percentSub(1 ether, 1_000);
        mathRef.percentSub(1 ether, 1_000);
    }

    function testGasPercentageMul() public view {
        math.percentMul(1 ether, 1_000);
        mathRef.percentMul(1 ether, 1_000);
    }

    function testGasPercentageDiv() public view {
        math.percentDiv(1 ether, 1_000);
        mathRef.percentDiv(1 ether, 1_000);
    }

    function testGasPercentageAvg() public view {
        math.weightedAvg(1 ether, 2 ether, 5_000);
        mathRef.weightedAvg(1 ether, 2 ether, 5_000);
    }
}
