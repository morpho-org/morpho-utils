// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.0;

import {WadRayMathMock} from "./mocks/WadRayMathMock.sol";
import {WadRayMathRef} from "./references/WadRayMathRef.sol";
import "forge-std/Test.sol";

contract TestWadRayMath is Test {
    uint256 internal constant WAD = 1e18;
    uint256 internal constant HALF_WAD = WAD / 2;
    uint256 internal constant WAD_MINUS_ONE = WAD - 1;
    uint256 internal constant RAY = 1e27;
    uint256 internal constant HALF_RAY = RAY / 2;
    uint256 internal constant RAY_MINUS_ONE = RAY - 1;
    uint256 internal constant RAY_WAD_RATIO = RAY / WAD;
    uint256 internal constant HALF_RAY_WAD_RATIO = RAY_WAD_RATIO / 2;
    uint256 internal constant MAX_UINT256_MINUS_HALF_WAD = type(uint256).max - HALF_WAD;
    uint256 internal constant MAX_UINT256_MINUS_WAD_MINUS_ONE = type(uint256).max - WAD_MINUS_ONE;
    uint256 internal constant MAX_UINT256_MINUS_HALF_RAY = type(uint256).max - HALF_RAY;
    uint256 internal constant MAX_UINT256_MINUS_RAY_MINUS_ONE = type(uint256).max - RAY_MINUS_ONE;

    WadRayMathMock mock;
    WadRayMathRef ref;

    function setUp() public {
        mock = new WadRayMathMock();
        ref = new WadRayMathRef();
    }

    /// TESTS ///

    function testWadMulRef(uint256 x, uint256 y) public {
        vm.assume(y == 0 || x <= MAX_UINT256_MINUS_HALF_WAD / y);

        assertEq(mock.wadMul(x, y), ref.wadMul(x, y));
    }

    function testWadMulOverflow(uint256 x, uint256 y) public {
        vm.assume(y > 0 && x > MAX_UINT256_MINUS_HALF_WAD / y);

        vm.expectRevert();
        mock.wadMul(x, y);
    }

    function testWadMulDown() public {
        assertEq(mock.wadMulDown(WAD - 1, WAD - 1), WAD - 2);
    }

    function testWadMulDownRef(uint256 x, uint256 y) public {
        vm.assume(y == 0 || x <= type(uint256).max / y);

        assertEq(mock.wadMulDown(x, y), ref.wadMulDown(x, y));
    }

    function testWadMulDownOverflow(uint256 x, uint256 y) public {
        vm.assume(y > 0 && x > type(uint256).max / y);

        vm.expectRevert();
        mock.wadMulDown(x, y);
    }

    function testWadMulUp() public {
        assertEq(mock.wadMulUp(WAD - 1, WAD - 1), WAD - 1);
    }

    function testWadMulUpRef(uint256 x, uint256 y) public {
        vm.assume(y == 0 || x <= (type(uint256).max - WAD - 1) / y);

        assertEq(mock.wadMulUp(x, y), ref.wadMulUp(x, y));
    }

    function testWadMulUpOverflow(uint256 x, uint256 y) public {
        vm.assume(y > 0 && x > (type(uint256).max - WAD - 1) / y);

        vm.expectRevert();
        mock.wadMulUp(x, y);
    }

    function testWadDivRef(uint256 x, uint256 y) public {
        vm.assume(y > 0 && x <= (type(uint256).max - y / 2) / WAD);

        assertEq(mock.wadDiv(x, y), ref.wadDiv(x, y));
    }

    function testWadDivOverflow(uint256 x, uint256 y) public {
        vm.assume(x > (type(uint256).max - y / 2) / WAD);

        vm.expectRevert();
        mock.wadDiv(x, y);
    }

    function testWadDivByZero(uint256 x) public {
        vm.expectRevert();
        mock.wadDiv(x, 0);
    }

    function testWadDivDown() public {
        assertEq(mock.wadDivDown(WAD - 2, WAD - 1), WAD - 2);
    }

    function testWadDivDownRef(uint256 x, uint256 y) public {
        vm.assume(y > 0 && x <= type(uint256).max / WAD);

        assertEq(mock.wadDivDown(x, y), ref.wadDivDown(x, y));
    }

    function testWadDivDownOverflow(uint256 x, uint256 y) public {
        vm.assume(y > 0 && x > type(uint256).max / WAD);

        vm.expectRevert();
        mock.wadDivDown(x, y);
    }

    function testWadDivDownByZero(uint256 x) public {
        vm.expectRevert();
        mock.wadDivDown(x, 0);
    }

    function testWadDivUp() public {
        assertEq(mock.wadDivUp(WAD - 2, WAD - 1), WAD - 1);
    }

    function testWadDivUpRef(uint256 x, uint256 y) public {
        vm.assume(y > 0 && x <= (type(uint256).max - (y - 1)) / WAD);

        assertEq(mock.wadDivUp(x, y), ref.wadDivUp(x, y));
    }

    function testWadDivUpOverflow(uint256 x, uint256 y) public {
        vm.assume(y > 0 && x > (type(uint256).max - (y - 1)) / WAD);

        vm.expectRevert();
        mock.wadDivUp(x, y);
    }

    function testWadDivUpByZero(uint256 x) public {
        vm.expectRevert();
        mock.wadDivUp(x, 0);
    }

    function testRayMulRef(uint256 x, uint256 y) public {
        vm.assume(y == 0 || x <= MAX_UINT256_MINUS_HALF_RAY / y);

        assertEq(mock.rayMul(x, y), ref.rayMul(x, y));
    }

    function testRayMulOverflow(uint256 x, uint256 y) public {
        vm.assume(y > 0 && x > MAX_UINT256_MINUS_HALF_RAY / y);

        vm.expectRevert();
        mock.rayMul(x, y);
    }

    function testRayMulDown() public {
        assertEq(mock.rayMulDown(RAY - 1, RAY - 1), RAY - 2);
    }

    function testRayMulDownRef(uint256 x, uint256 y) public {
        vm.assume(y == 0 || x <= type(uint256).max / y);

        assertEq(mock.rayMulDown(x, y), ref.rayMulDown(x, y));
    }

    function testRayMulDownOverflow(uint256 x, uint256 y) public {
        vm.assume(y > 0 && x > type(uint256).max / y);

        vm.expectRevert();
        mock.rayMulDown(x, y);
    }

    function testRayMulUp() public {
        assertEq(mock.rayMulUp(RAY - 1, RAY - 1), RAY - 1);
    }

    function testRayMulUpRef(uint256 x, uint256 y) public {
        vm.assume(y == 0 || x <= (type(uint256).max - RAY - 1) / y);

        assertEq(mock.rayMulUp(x, y), ref.rayMulUp(x, y));
    }

    function testRayMulUpOverflow(uint256 x, uint256 y) public {
        vm.assume(y > 0 && x > (type(uint256).max - RAY - 1) / y);

        vm.expectRevert();
        mock.rayMulUp(x, y);
    }

    function testRayDivRef(uint256 x, uint256 y) public {
        vm.assume(y > 0 && x <= (type(uint256).max - y / 2) / RAY);

        assertEq(mock.rayDiv(x, y), ref.rayDiv(x, y));
    }

    function testRayDivOverflow(uint256 x, uint256 y) public {
        vm.assume(x > (type(uint256).max - y / 2) / RAY);

        vm.expectRevert();
        mock.rayDiv(x, y);
    }

    function testRayDivByZero(uint256 x) public {
        vm.expectRevert();
        mock.rayDiv(x, 0);
    }

    function testRayDivDown() public {
        assertEq(mock.rayDivDown(RAY - 2, RAY - 1), RAY - 2);
    }

    function testRayDivDownRef(uint256 x, uint256 y) public {
        vm.assume(y > 0 && x <= type(uint256).max / RAY);

        assertEq(mock.rayDivDown(x, y), ref.rayDivDown(x, y));
    }

    function testRayDivDownOverflow(uint256 x, uint256 y) public {
        vm.assume(y > 0 && x > type(uint256).max / RAY);

        vm.expectRevert();
        mock.rayDivDown(x, y);
    }

    function testRayDivDownByZero(uint256 x) public {
        vm.expectRevert();
        mock.rayDivDown(x, 0);
    }

    function testRayDivUp() public {
        assertEq(mock.rayDivUp(RAY - 2, RAY - 1), RAY - 1);
    }

    function testRayDivUpRef(uint256 x, uint256 y) public {
        vm.assume(y > 0 && x <= (type(uint256).max - (y - 1)) / RAY);

        assertEq(mock.rayDivUp(x, y), ref.rayDivUp(x, y));
    }

    function testRayDivUpOverflow(uint256 x, uint256 y) public {
        vm.assume(y > 0 && x > (type(uint256).max - (y - 1)) / RAY);

        vm.expectRevert();
        mock.rayDivUp(x, y);
    }

    function testRayDivUpByZero(uint256 x) public {
        vm.expectRevert();
        mock.rayDivUp(x, 0);
    }

    function testRayToWad(uint256 x) public {
        assertEq(mock.rayToWad(x), ref.rayToWad(x));
    }

    function testWadToRay(uint256 x) public {
        vm.assume(x <= type(uint256).max / RAY_WAD_RATIO);

        assertEq(mock.wadToRay(x), ref.wadToRay(x));
    }

    function testWadToRayOverflow(uint256 x) public {
        vm.assume(x > type(uint256).max / RAY_WAD_RATIO);

        vm.expectRevert();
        mock.wadToRay(x);
    }

    function testWadWeightedAvg(uint256 x, uint256 y, uint16 weight) public {
        vm.assume(weight <= WAD);
        vm.assume(weight == 0 || y <= MAX_UINT256_MINUS_HALF_WAD / weight);
        vm.assume(WAD - weight == 0 || x <= (type(uint256).max - y * weight - HALF_WAD) / (WAD - weight));

        assertEq(mock.wadWeightedAvg(x, y, weight), ref.wadWeightedAvg(x, y, weight));
    }

    function testWadWeightedAvgOverflow(uint256 x, uint256 y, uint256 weight) public {
        vm.assume(weight <= WAD);
        vm.assume(
            (weight != 0 && y > MAX_UINT256_MINUS_HALF_WAD / weight)
                || ((WAD - weight) != 0 && x > (type(uint256).max - y * weight - HALF_WAD) / (WAD - weight))
        );

        vm.expectRevert();
        mock.wadWeightedAvg(x, y, weight);
    }

    function testWadWeightedAvgUnderflow(uint256 x, uint256 y, uint256 weight) public {
        vm.assume(weight > WAD);

        vm.expectRevert();
        mock.wadWeightedAvg(x, y, weight);
    }

    function testWadWeightedAvgBounds(uint256 x, uint256 y) public {
        vm.assume(x <= y);
        vm.assume(y <= type(uint256).max - HALF_WAD);
        vm.assume(x <= (type(uint256).max - y - HALF_WAD) / (WAD - 1));

        uint256 avg = mock.wadWeightedAvg(x, y, 1);

        assertLe(x, avg);
        assertLe(avg, y);
    }

    function testRayWeightedAvg(uint256 x, uint256 y, uint16 weight) public {
        vm.assume(weight <= RAY);
        vm.assume(weight == 0 || y <= MAX_UINT256_MINUS_HALF_RAY / weight);
        vm.assume(RAY - weight == 0 || x <= (type(uint256).max - y * weight - HALF_RAY) / (RAY - weight));

        assertEq(mock.rayWeightedAvg(x, y, weight), ref.rayWeightedAvg(x, y, weight));
    }

    function testRayWeightedAvgOverflow(uint256 x, uint256 y, uint256 weight) public {
        vm.assume(weight <= RAY);
        vm.assume(
            (weight != 0 && y > MAX_UINT256_MINUS_HALF_RAY / weight)
                || ((RAY - weight) != 0 && x > (type(uint256).max - y * weight - HALF_RAY) / (RAY - weight))
        );

        vm.expectRevert();
        mock.rayWeightedAvg(x, y, weight);
    }

    function testRayWeightedAvgUnderflow(uint256 x, uint256 y, uint256 weight) public {
        vm.assume(weight > RAY);

        vm.expectRevert();
        mock.rayWeightedAvg(x, y, weight);
    }

    function testRayWeightedAvgBounds(uint256 x, uint256 y) public {
        vm.assume(x <= y);
        vm.assume(y <= type(uint256).max - HALF_RAY);
        vm.assume(x <= (type(uint256).max - y - HALF_RAY) / (RAY - 1));

        uint256 avg = mock.rayWeightedAvg(x, y, 1);

        assertLe(x, avg);
        assertLe(avg, y);
    }
}
