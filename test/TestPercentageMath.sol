// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.0;

import {PercentageMathMock} from "./mocks/PercentageMathMock.sol";
import {PercentageMathRef} from "./references/PercentageMathRef.sol";
import "forge-std/Test.sol";

contract TestPercentageMath is Test {
    uint256 internal constant PERCENTAGE_FACTOR = 100_00;
    uint256 internal constant HALF_PERCENTAGE_FACTOR = 50_00;

    PercentageMathMock mock;
    PercentageMathRef ref;

    function setUp() public {
        mock = new PercentageMathMock();
        ref = new PercentageMathRef();
    }

    /// TESTS ///

    function testPercentAdd(uint256 x, uint256 p) public {
        vm.assume(p <= type(uint256).max - PERCENTAGE_FACTOR);
        vm.assume(x <= type(uint256).max / (PERCENTAGE_FACTOR + p));

        assertEq(mock.percentAdd(x, p), ref.percentAdd(x, p));
    }

    function testPercentAddZero(uint256 x) public {
        vm.assume(x <= type(uint256).max / PERCENTAGE_FACTOR);

        assertEq(mock.percentAdd(x, 0), x);
    }

    function testPercentAddOverflow(uint256 x, uint256 p) public {
        vm.assume(p > type(uint256).max - PERCENTAGE_FACTOR);

        vm.expectRevert();
        mock.percentAdd(x, p);
    }

    function testPercentSub(uint256 x, uint256 p) public {
        vm.assume(p <= PERCENTAGE_FACTOR);
        vm.assume(p == PERCENTAGE_FACTOR || x <= type(uint256).max / (PERCENTAGE_FACTOR - p));

        assertEq(mock.percentSub(x, p), ref.percentSub(x, p));
    }

    function testPercentSubZero(uint256 x) public {
        vm.assume(x <= type(uint256).max / PERCENTAGE_FACTOR);

        assertEq(mock.percentSub(x, 0), x);
    }

    function testPercentSubMax(uint256 x) public {
        assertEq(mock.percentSub(x, PERCENTAGE_FACTOR), 0);
    }

    function testPercentSubUnderflow(uint256 x, uint256 p) public {
        vm.assume(p > PERCENTAGE_FACTOR);

        vm.expectRevert();
        mock.percentSub(x, p);
    }

    function testPercentSubOverflow(uint256 x, uint256 p) public {
        vm.assume(p <= PERCENTAGE_FACTOR);
        vm.assume(p != PERCENTAGE_FACTOR && x > type(uint256).max / (PERCENTAGE_FACTOR - p));

        vm.expectRevert();
        mock.percentSub(x, p);
    }

    function testPercentMul(uint256 x, uint256 p) public {
        vm.assume(p == 0 || x <= (type(uint256).max - HALF_PERCENTAGE_FACTOR) / p);

        assertEq(mock.percentMul(x, p), ref.percentMul(x, p));
    }

    function testPercentMulOverflow(uint256 x, uint256 p) public {
        vm.assume(p > 0 && x > (type(uint256).max - HALF_PERCENTAGE_FACTOR) / p);

        vm.expectRevert();
        mock.percentMul(x, p);
    }

    function testPercentMulDown() public {
        assertEq(mock.percentMulDown(PERCENTAGE_FACTOR - 1, PERCENTAGE_FACTOR - 1), PERCENTAGE_FACTOR - 2);
    }

    function testPercentMulDownRef(uint256 x, uint256 y) public {
        vm.assume(y == 0 || x <= type(uint256).max / y);

        assertEq(mock.percentMulDown(x, y), ref.percentMulDown(x, y));
    }

    function testPercentMulDownOverflow(uint256 x, uint256 y) public {
        vm.assume(y > 0 && x > type(uint256).max / y);

        vm.expectRevert();
        mock.percentMulDown(x, y);
    }

    function testPercentMulUp() public {
        assertEq(mock.percentMulUp(PERCENTAGE_FACTOR - 1, PERCENTAGE_FACTOR - 1), PERCENTAGE_FACTOR - 1);
    }

    function testPercentMulUpRef(uint256 x, uint256 y) public {
        vm.assume(y == 0 || x <= (type(uint256).max - PERCENTAGE_FACTOR - 1) / y);

        assertEq(mock.percentMulUp(x, y), ref.percentMulUp(x, y));
    }

    function testPercentMulUpOverflow(uint256 x, uint256 y) public {
        vm.assume(y > 0 && x > (type(uint256).max - PERCENTAGE_FACTOR - 1) / y);

        vm.expectRevert();
        mock.percentMulUp(x, y);
    }

    function testPercentDiv(uint256 x, uint256 p) public {
        vm.assume(p > 0 && x <= (type(uint256).max - p / 2) / PERCENTAGE_FACTOR);

        assertEq(mock.percentDiv(x, p), ref.percentDiv(x, p));
    }

    function testPercentDivOverflow(uint256 x, uint256 p) public {
        vm.assume(x > (type(uint256).max - p / 2) / PERCENTAGE_FACTOR);

        vm.expectRevert();
        mock.percentDiv(x, p);
    }

    function testPercentDivByZero(uint256 x) public {
        vm.expectRevert();
        mock.percentDiv(x, 0);
    }

    function testPercentDivDown() public {
        assertEq(mock.percentDivDown(PERCENTAGE_FACTOR - 2, PERCENTAGE_FACTOR - 1), PERCENTAGE_FACTOR - 2);
    }

    function testPercentDivDownRef(uint256 x, uint256 y) public {
        vm.assume(y > 0 && x <= type(uint256).max / PERCENTAGE_FACTOR);

        assertEq(mock.percentDivDown(x, y), ref.percentDivDown(x, y));
    }

    function testPercentDivDownOverflow(uint256 x, uint256 y) public {
        vm.assume(y > 0 && x > type(uint256).max / PERCENTAGE_FACTOR);

        vm.expectRevert();
        mock.percentDivDown(x, y);
    }

    function testPercentDivDownByZero(uint256 x) public {
        vm.expectRevert();
        mock.percentDivDown(x, 0);
    }

    function testPercentDivUp() public {
        assertEq(mock.percentDivUp(PERCENTAGE_FACTOR - 2, PERCENTAGE_FACTOR - 1), PERCENTAGE_FACTOR - 1);
    }

    function testPercentDivUpRef(uint256 x, uint256 y) public {
        vm.assume(y > 0 && x <= (type(uint256).max - (y - 1)) / PERCENTAGE_FACTOR);

        assertEq(mock.percentDivUp(x, y), ref.percentDivUp(x, y));
    }

    function testPercentDivUpOverflow(uint256 x, uint256 y) public {
        vm.assume(y > 0 && x > (type(uint256).max - (y - 1)) / PERCENTAGE_FACTOR);

        vm.expectRevert();
        mock.percentDivUp(x, y);
    }

    function testPercentDivUpByZero(uint256 x) public {
        vm.expectRevert();
        mock.percentDivUp(x, 0);
    }

    function testWeightedAvg(uint256 x, uint256 y, uint16 percentage) public {
        vm.assume(percentage <= PERCENTAGE_FACTOR);
        vm.assume(percentage == 0 || y <= (type(uint256).max - HALF_PERCENTAGE_FACTOR) / percentage);
        vm.assume(
            PERCENTAGE_FACTOR - percentage == 0
                || x <= (type(uint256).max - y * percentage - HALF_PERCENTAGE_FACTOR) / (PERCENTAGE_FACTOR - percentage)
        );

        assertEq(mock.weightedAvg(x, y, percentage), ref.weightedAvg(x, y, percentage));
    }

    function testWeightedAvgOverflow(uint256 x, uint256 y, uint256 percentage) public {
        vm.assume(percentage <= PERCENTAGE_FACTOR);
        vm.assume(
            (percentage != 0 && y > (type(uint256).max - HALF_PERCENTAGE_FACTOR) / percentage)
                || (
                    (PERCENTAGE_FACTOR - percentage) != 0
                        && x > (type(uint256).max - y * percentage - HALF_PERCENTAGE_FACTOR) / (PERCENTAGE_FACTOR - percentage)
                )
        );

        vm.expectRevert();
        mock.weightedAvg(x, y, percentage);
    }

    function testWeightedAvgUnderflow(uint256 x, uint256 y, uint256 percentage) public {
        vm.assume(percentage > PERCENTAGE_FACTOR);

        vm.expectRevert();
        mock.weightedAvg(x, y, percentage);
    }

    function testWeightedAvgBounds(uint256 x, uint256 y) public {
        vm.assume(x <= y);
        vm.assume(y <= type(uint256).max - HALF_PERCENTAGE_FACTOR);
        vm.assume(x <= (type(uint256).max - y - HALF_PERCENTAGE_FACTOR) / (PERCENTAGE_FACTOR - 1));

        uint256 avg = mock.weightedAvg(x, y, 1);

        assertLe(x, avg);
        assertLe(avg, y);
    }
}
