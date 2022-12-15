// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import {PercentageMathMock} from "./mocks/PercentageMathMock.sol";
import {PercentageMathRef} from "./references/PercentageMathRef.sol";
import "forge-std/Test.sol";

contract TestPercentageMath is Test {
    uint256 internal constant PERCENTAGE_FACTOR = 100_00;
    uint256 internal constant HALF_PERCENTAGE_FACTOR = 50_00;
    uint256 internal constant MAX_UINT256 = type(uint256).max;
    uint256 internal constant MAX_UINT256_MINUS_HALF_PERCENTAGE = type(uint256).max - HALF_PERCENTAGE_FACTOR;

    PercentageMathMock mock;
    PercentageMathRef ref;

    function setUp() public {
        mock = new PercentageMathMock();
        ref = new PercentageMathRef();
    }

    /// TESTS ///

    function testPercentAdd(uint256 x, uint256 p) public {
        vm.assume(p <= MAX_UINT256 - PERCENTAGE_FACTOR);
        vm.assume(x <= MAX_UINT256 / (PERCENTAGE_FACTOR + p));

        assertEq(mock.percentAdd(x, p), ref.percentAdd(x, p));
    }

    function testPercentSub(uint256 x, uint256 p) public {
        vm.assume(p <= PERCENTAGE_FACTOR);
        vm.assume(p == PERCENTAGE_FACTOR || x <= MAX_UINT256 / (PERCENTAGE_FACTOR - p));

        assertEq(mock.percentSub(x, p), ref.percentSub(x, p));
    }

    function testPercentMul(uint256 x, uint256 p) public {
        vm.assume(p == 0 || x <= MAX_UINT256_MINUS_HALF_PERCENTAGE / p);

        assertEq(mock.percentMul(x, p), ref.percentMul(x, p));
    }

    function testPercentDiv(uint256 x, uint256 p) public {
        vm.assume(p > 0 && x <= (MAX_UINT256 - p / 2) / PERCENTAGE_FACTOR);

        assertEq(mock.percentDiv(x, p), ref.percentDiv(x, p));
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

        assertEq(mock.weightedAvg(x, y, percentage), ref.weightedAvg(x, y, percentage));
    }
}
