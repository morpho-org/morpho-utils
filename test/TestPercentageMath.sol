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

    function percentMulDown(uint256 x, uint256 y) public pure returns (uint256) {
        return PercentageMath.percentMulDown(x, y);
    }

    function percentMulUp(uint256 x, uint256 y) public pure returns (uint256) {
        return PercentageMath.percentMulUp(x, y);
    }

    function percentDiv(uint256 x, uint256 y) public pure returns (uint256) {
        return PercentageMath.percentDiv(x, y);
    }

    function percentDivDown(uint256 x, uint256 y) public pure returns (uint256) {
        return PercentageMath.percentDivDown(x, y);
    }

    function percentDivUp(uint256 x, uint256 y) public pure returns (uint256) {
        return PercentageMath.percentDivUp(x, y);
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
    
    function percentMulDown(uint256 x, uint256 y) public pure returns (uint256) {
        return x * y / PercentageMathRef.PERCENTAGE_FACTOR;
    }
    
    function percentMulUp(uint256 x, uint256 y) public pure returns (uint256) {
        return (x * y + PercentageMathRef.PERCENTAGE_FACTOR - 1) / PercentageMathRef.PERCENTAGE_FACTOR;
    }

    function percentDiv(uint256 x, uint256 y) public pure returns (uint256) {
        return PercentageMathRef.percentDiv(x, y);
    }

    function percentDivDown(uint256 x, uint256 y) public pure returns (uint256) {
        return (x * PercentageMathRef.PERCENTAGE_FACTOR) / y;
    }

    function percentDivUp(uint256 x, uint256 y) public pure returns (uint256) {
        return (x * PercentageMathRef.PERCENTAGE_FACTOR + y - 1) / y;
    }

    function weightedAvg(
        uint256 x,
        uint256 y,
        uint256 percentage
    ) public pure returns (uint256) {
        return
            (x *
                (PercentageMathRef.PERCENTAGE_FACTOR - percentage) +
                y *
                percentage +
                PercentageMathRef.HALF_PERCENTAGE_FACTOR) / PercentageMath.PERCENTAGE_FACTOR;
    }
}

contract TestPercentageMath is Test {
    uint256 internal constant PERCENTAGE_FACTOR = 1e4;
    uint256 internal constant HALF_PERCENTAGE_FACTOR = 0.5e4;
    uint256 internal constant PERCENTAGE_FACTOR_MINUS_ONE = PERCENTAGE_FACTOR - 1;
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

    function testPercentAdd(uint256 x, uint256 p) public {
        vm.assume(p <= MAX_UINT256 - PERCENTAGE_FACTOR);
        vm.assume(x <= MAX_UINT256 / (PERCENTAGE_FACTOR + p));

        assertEq(PercentageMath.percentAdd(x, p), mathRef.percentAdd(x, p));
    }

    function testPercentAddOverflow(uint256 x, uint256 p) public {
        vm.assume(p > MAX_UINT256 - PERCENTAGE_FACTOR);

        vm.expectRevert();
        PercentageMath.percentAdd(x, p);
    }

    function testPercentSubZero(uint256 x) public {
        vm.assume(x <= MAX_UINT256 / PERCENTAGE_FACTOR);

        assertEq(PercentageMath.percentSub(x, 0), x);
    }

    function testPercentSubMax(uint256 x) public {
        assertEq(PercentageMath.percentSub(x, PERCENTAGE_FACTOR), 0);
    }

    function testPercentSub(uint256 x, uint256 p) public {
        vm.assume(p <= PERCENTAGE_FACTOR);
        vm.assume(p == PERCENTAGE_FACTOR || x <= MAX_UINT256 / (PERCENTAGE_FACTOR - p));

        assertEq(PercentageMath.percentSub(x, p), mathRef.percentSub(x, p));
    }

    function testPercentSubUnderflow(uint256 x, uint256 p) public {
        vm.assume(p > PERCENTAGE_FACTOR);

        vm.expectRevert();
        PercentageMath.percentSub(x, p);
    }

    function testPercentSubOverflow(uint256 x, uint256 p) public {
        vm.assume(p <= PERCENTAGE_FACTOR);
        vm.assume(p != PERCENTAGE_FACTOR && x > MAX_UINT256 / (PERCENTAGE_FACTOR - p));

        vm.expectRevert();
        PercentageMath.percentSub(x, p);
    }

    function testPercentMul(uint256 x, uint256 p) public {
        vm.assume(p == 0 || x <= MAX_UINT256_MINUS_HALF_PERCENTAGE / p);

        assertEq(PercentageMath.percentMul(x, p), PercentageMathRef.percentMul(x, p));
    }

    function testPercentMulOverflow(uint256 x, uint256 p) public {
        vm.assume(p > 0 && x > MAX_UINT256_MINUS_HALF_PERCENTAGE / p);

        vm.expectRevert();
        PercentageMath.percentMul(x, p);
    }

    function testPercentMulDown() public {
        assertEq(PercentageMath.percentMulDown(PERCENTAGE_FACTOR - 1, PERCENTAGE_FACTOR - 1), PERCENTAGE_FACTOR - 2);
    }

    function testPercentMulDownRef(uint256 x, uint256 y) public {
        vm.assume(y == 0 || x <= type(uint256).max / y);

        assertEq(PercentageMath.percentMulDown(x, y), mathRef.percentMulDown(x, y));
    }

    function testPercentMulDownOverflow(uint256 x, uint256 y) public {
        vm.assume(y > 0 && x > type(uint256).max / y);

        vm.expectRevert();
        PercentageMath.percentMulDown(x, y);
    }

    function testPercentMulUp() public {
        assertEq(PercentageMath.percentMulUp(PERCENTAGE_FACTOR - 1, PERCENTAGE_FACTOR - 1), PERCENTAGE_FACTOR - 1);
    }

    function testPercentMulUpRef(uint256 x, uint256 y) public {
        vm.assume(y == 0 || x <= (type(uint256).max - PERCENTAGE_FACTOR - 1) / y);

        assertEq(PercentageMath.percentMulUp(x, y), mathRef.percentMulUp(x, y));
    }

    function testPercentMulUpOverflow(uint256 x, uint256 y) public {
        vm.assume(y > 0 && x > (type(uint256).max - PERCENTAGE_FACTOR - 1) / y);

        vm.expectRevert();
        PercentageMath.percentMulUp(x, y);
    }

    function testPercentDiv(uint256 x, uint256 p) public {
        vm.assume(p > 0 && x <= (MAX_UINT256 - p / 2) / PERCENTAGE_FACTOR);

        assertEq(PercentageMath.percentDiv(x, p), PercentageMathRef.percentDiv(x, p));
    }

    function testPercentDivOverflow(uint256 x, uint256 p) public {
        vm.assume(x > (MAX_UINT256 - p / 2) / PERCENTAGE_FACTOR);

        vm.expectRevert();
        PercentageMath.percentDiv(x, p);
    }

    function testPercentDivByZero(uint256 x) public {
        vm.expectRevert();
        PercentageMath.percentDiv(x, 0);
    }

    function testPercentDivDown() public {
        assertEq(PercentageMath.percentDivDown(PERCENTAGE_FACTOR - 2, PERCENTAGE_FACTOR - 1), PERCENTAGE_FACTOR - 2);
    }

    function testPercentDivDownRef(uint256 x, uint256 y) public {
        vm.assume(y > 0 && x <= type(uint256).max / PERCENTAGE_FACTOR);

        assertEq(PercentageMath.percentDivDown(x, y), mathRef.percentDivDown(x, y));
    }

    function testPercentDivDownOverflow(uint256 x, uint256 y) public {
        vm.assume(y > 0 && x > type(uint256).max / PERCENTAGE_FACTOR);

        vm.expectRevert();
        PercentageMath.percentDivDown(x, y);
    }

    function testPercentDivDownByZero(uint256 x) public {
        vm.expectRevert();
        PercentageMath.percentDivDown(x, 0);
    }

    function testPercentDivUp() public {
        assertEq(PercentageMath.percentDivUp(PERCENTAGE_FACTOR - 2, PERCENTAGE_FACTOR - 1), PERCENTAGE_FACTOR - 1);
    }

    function testPercentDivUpRef(uint256 x, uint256 y) public {
        vm.assume(y > 0 && x <= (type(uint256).max - (y - 1)) / PERCENTAGE_FACTOR);

        assertEq(PercentageMath.percentDivUp(x, y), mathRef.percentDivUp(x, y));
    }

    function testPercentDivUpOverflow(uint256 x, uint256 y) public {
        vm.assume(y > 0 && x > (type(uint256).max - (y - 1)) / PERCENTAGE_FACTOR);

        vm.expectRevert();
        PercentageMath.percentDivUp(x, y);
    }

    function testPercentDivUpByZero(uint256 x) public {
        vm.expectRevert();
        PercentageMath.percentDivUp(x, 0);
    }

    function testWeightedAvg(
        uint256 x,
        uint256 y,
        uint16 percentage
    ) public {
        vm.assume(percentage <= PERCENTAGE_FACTOR);
        vm.assume(percentage == 0 || y <= (MAX_UINT256 - HALF_PERCENTAGE_FACTOR) / percentage);
        vm.assume(
            PERCENTAGE_FACTOR - percentage == 0 ||
                x <= (MAX_UINT256 - y * percentage - HALF_PERCENTAGE_FACTOR) / (PERCENTAGE_FACTOR - percentage)
        );

        assertEq(PercentageMath.weightedAvg(x, y, percentage), mathRef.weightedAvg(x, y, percentage));
    }

    function testWeightedAvgOverflow(
        uint256 x,
        uint256 y,
        uint256 percentage
    ) public {
        vm.assume(percentage <= PERCENTAGE_FACTOR);
        vm.assume(
            (percentage != 0 && y > (MAX_UINT256 - HALF_PERCENTAGE_FACTOR) / percentage) ||
                ((PERCENTAGE_FACTOR - percentage) != 0 &&
                    x > (MAX_UINT256 - y * percentage - HALF_PERCENTAGE_FACTOR) / (PERCENTAGE_FACTOR - percentage))
        );

        vm.expectRevert();
        PercentageMath.weightedAvg(x, y, percentage);
    }

    function testWeightedAvgUnderflow(
        uint256 x,
        uint256 y,
        uint256 percentage
    ) public {
        vm.assume(percentage > PERCENTAGE_FACTOR);

        vm.expectRevert();
        PercentageMath.weightedAvg(x, y, percentage);
    }

    function testWeightedAvgOutOfBounds() public {
        uint256 x = 5000;
        uint256 y = 5000;
        uint256 percentage = 1;

        uint256 weightedAvg = PercentageMath.weightedAvg(x, y, percentage);

        assertLe(x, weightedAvg);
        assertLe(weightedAvg, y);
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

    function testGasPercentageMulDown() public view {
        math.percentMulDown(1 ether, 1_000);
        mathRef.percentMulDown(1 ether, 1_000);
    }

    function testGasPercentageMulUp() public view {
        math.percentMulUp(1 ether, 1_000);
        mathRef.percentMulUp(1 ether, 1_000);
    }

    function testGasPercentageDiv() public view {
        math.percentDiv(1 ether, 1_000);
        mathRef.percentDiv(1 ether, 1_000);
    }

    function testGasPercentageDivDown() public view {
        math.percentDivDown(1 ether, 1_000);
        mathRef.percentDivDown(1 ether, 1_000);
    }

    function testGasPercentageDivUp() public view {
        math.percentDivUp(1 ether, 1_000);
        mathRef.percentDivUp(1 ether, 1_000);
    }

    function testGasPercentageAvg() public view {
        math.weightedAvg(1 ether, 2 ether, 5_000);
        mathRef.weightedAvg(1 ether, 2 ether, 5_000);
    }
}
