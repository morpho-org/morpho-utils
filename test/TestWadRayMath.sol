// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "forge-std/Vm.sol";
import "src/math/WadRayMath.sol";
import {WadRayMath as WadRayMathRef} from "@aave/core-v3/contracts/protocol/libraries/math/WadRayMath.sol";

contract WadRayMathFunctions {
    function wadMul(uint256 x, uint256 y) public pure returns (uint256) {
        return WadRayMath.wadMul(x, y);
    }

    function wadMulDown(uint256 x, uint256 y) public pure returns (uint256) {
        return WadRayMath.wadMulDown(x, y);
    }

    function wadMulUp(uint256 x, uint256 y) public pure returns (uint256) {
        return WadRayMath.wadMulUp(x, y);
    }

    function wadDiv(uint256 x, uint256 y) public pure returns (uint256) {
        return WadRayMath.wadDiv(x, y);
    }

    function wadDivDown(uint256 x, uint256 y) public pure returns (uint256) {
        return WadRayMath.wadDivDown(x, y);
    }

    function wadDivUp(uint256 x, uint256 y) public pure returns (uint256) {
        return WadRayMath.wadDivUp(x, y);
    }

    function rayMul(uint256 x, uint256 y) public pure returns (uint256) {
        return WadRayMath.rayMul(x, y);
    }

    function rayMulDown(uint256 x, uint256 y) public pure returns (uint256) {
        return WadRayMath.rayMulDown(x, y);
    }

    function rayMulUp(uint256 x, uint256 y) public pure returns (uint256) {
        return WadRayMath.rayMulUp(x, y);
    }

    function rayDiv(uint256 x, uint256 y) public pure returns (uint256) {
        return WadRayMath.rayDiv(x, y);
    }

    function rayDivDown(uint256 x, uint256 y) public pure returns (uint256) {
        return WadRayMath.rayDivDown(x, y);
    }

    function rayDivUp(uint256 x, uint256 y) public pure returns (uint256) {
        return WadRayMath.rayDivUp(x, y);
    }

    function rayToWad(uint256 x) public pure returns (uint256) {
        return WadRayMath.rayToWad(x);
    }

    function wadToRay(uint256 x) public pure returns (uint256) {
        return WadRayMath.wadToRay(x);
    }
}

contract WadRayMathFunctionsRef {
    function wadMul(uint256 x, uint256 y) public pure returns (uint256) {
        return WadRayMathRef.wadMul(x, y);
    }
    
    function wadMulDown(uint256 x, uint256 y) public pure returns (uint256) {
        return x * y / WadRayMathRef.WAD;
    }
    
    function wadMulUp(uint256 x, uint256 y) public pure returns (uint256) {
        return (x * y + WadRayMathRef.WAD - 1) / WadRayMathRef.WAD;
    }

    function wadDiv(uint256 x, uint256 y) public pure returns (uint256) {
        return WadRayMathRef.wadDiv(x, y);
    }

    function wadDivDown(uint256 x, uint256 y) public pure returns (uint256) {
        return (x * WadRayMathRef.WAD) / y;
    }

    function wadDivUp(uint256 x, uint256 y) public pure returns (uint256) {
        return (x * WadRayMathRef.WAD + y - 1) / y;
    }

    function rayMul(uint256 x, uint256 y) public pure returns (uint256) {
        return WadRayMathRef.rayMul(x, y);
    }
    
    function rayMulDown(uint256 x, uint256 y) public pure returns (uint256) {
        return x * y / WadRayMathRef.RAY;
    }
    
    function rayMulUp(uint256 x, uint256 y) public pure returns (uint256) {
        return (x * y + WadRayMathRef.RAY - 1) / WadRayMathRef.RAY;
    }

    function rayDiv(uint256 x, uint256 y) public pure returns (uint256) {
        return WadRayMathRef.rayDiv(x, y);
    }

    function rayDivDown(uint256 x, uint256 y) public pure returns (uint256) {
        return (x * WadRayMathRef.RAY) / y;
    }

    function rayDivUp(uint256 x, uint256 y) public pure returns (uint256) {
        return (x * WadRayMathRef.RAY + y - 1) / y;
    }

    function rayToWad(uint256 x) public pure returns (uint256) {
        return WadRayMathRef.rayToWad(x);
    }

    function wadToRay(uint256 x) public pure returns (uint256) {
        return WadRayMathRef.wadToRay(x);
    }
}

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

    WadRayMathFunctions math;
    WadRayMathFunctionsRef mathRef;

    function setUp() public {
        math = new WadRayMathFunctions();
        mathRef = new WadRayMathFunctionsRef();
    }

    /// TESTS ///

    function testWadMulRef(uint256 x, uint256 y) public {
        vm.assume(y == 0 || x <= MAX_UINT256_MINUS_HALF_WAD / y);

        assertEq(WadRayMath.wadMul(x, y), WadRayMathRef.wadMul(x, y));
    }

    function testWadMulOverflow(uint256 x, uint256 y) public {
        vm.assume(y > 0 && x > MAX_UINT256_MINUS_HALF_WAD / y);

        vm.expectRevert();
        WadRayMath.wadMul(x, y);
    }

    function testWadMulDown() public {
        assertEq(WadRayMath.wadMulDown(WAD - 1, WAD - 1), WAD - 2);
    }

    function testWadMulDownRef(uint256 x, uint256 y) public {
        vm.assume(y == 0 || x <= type(uint256).max / y);

        assertEq(WadRayMath.wadMulDown(x, y), mathRef.wadMulDown(x, y));
    }

    function testWadMulDownOverflow(uint256 x, uint256 y) public {
        vm.assume(y > 0 && x > type(uint256).max / y);

        vm.expectRevert();
        WadRayMath.wadMulDown(x, y);
    }

    function testWadMulUp() public {
        assertEq(WadRayMath.wadMulUp(WAD - 1, WAD - 1), WAD - 1);
    }

    function testWadMulUpRef(uint256 x, uint256 y) public {
        vm.assume(y == 0 || x <= (type(uint256).max - WAD - 1) / y);

        assertEq(WadRayMath.wadMulUp(x, y), mathRef.wadMulUp(x, y));
    }

    function testWadMulUpOverflow(uint256 x, uint256 y) public {
        vm.assume(y > 0 && x > (type(uint256).max - WAD - 1) / y);

        vm.expectRevert();
        WadRayMath.wadMulUp(x, y);
    }

    function testWadDivRef(uint256 x, uint256 y) public {
        vm.assume(y > 0 && x <= (type(uint256).max - y / 2) / WAD);

        assertEq(WadRayMath.wadDiv(x, y), WadRayMathRef.wadDiv(x, y));
    }

    function testWadDivOverflow(uint256 x, uint256 y) public {
        vm.assume(x > (type(uint256).max - y / 2) / WAD);

        vm.expectRevert();
        WadRayMath.wadDiv(x, y);
    }

    function testWadDivByZero(uint256 x) public {
        vm.expectRevert();
        WadRayMath.wadDiv(x, 0);
    }

    function testWadDivDown() public {
        assertEq(WadRayMath.wadDivDown(WAD - 2, WAD - 1), WAD - 2);
    }

    function testWadDivDownRef(uint256 x, uint256 y) public {
        vm.assume(y > 0 && x <= type(uint256).max / WAD);

        assertEq(WadRayMath.wadDivDown(x, y), mathRef.wadDivDown(x, y));
    }

    function testWadDivDownOverflow(uint256 x, uint256 y) public {
        vm.assume(y > 0 && x > type(uint256).max / WAD);

        vm.expectRevert();
        WadRayMath.wadDivDown(x, y);
    }

    function testWadDivDownByZero(uint256 x) public {
        vm.expectRevert();
        WadRayMath.wadDivDown(x, 0);
    }

    function testWadDivUp() public {
        assertEq(WadRayMath.wadDivUp(WAD - 2, WAD - 1), WAD - 1);
    }

    function testWadDivUpRef(uint256 x, uint256 y) public {
        vm.assume(y > 0 && x <= (type(uint256).max - (y - 1)) / WAD);

        assertEq(WadRayMath.wadDivUp(x, y), mathRef.wadDivUp(x, y));
    }

    function testWadDivUpOverflow(uint256 x, uint256 y) public {
        vm.assume(y > 0 && x > (type(uint256).max - (y - 1)) / WAD);

        vm.expectRevert();
        WadRayMath.wadDivUp(x, y);
    }

    function testWadDivUpByZero(uint256 x) public {
        vm.expectRevert();
        WadRayMath.wadDivUp(x, 0);
    }

    function testRayMulRef(uint256 x, uint256 y) public {
        vm.assume(y == 0 || x <= MAX_UINT256_MINUS_HALF_RAY / y);

        assertEq(WadRayMath.rayMul(x, y), WadRayMathRef.rayMul(x, y));
    }

    function testRayMulOverflow(uint256 x, uint256 y) public {
        vm.assume(y > 0 && x > MAX_UINT256_MINUS_HALF_RAY / y);

        vm.expectRevert();
        WadRayMath.rayMul(x, y);
    }

    function testRayMulDown() public {
        assertEq(WadRayMath.rayMulDown(RAY - 1, RAY - 1), RAY - 2);
    }

    function testRayMulDownRef(uint256 x, uint256 y) public {
        vm.assume(y == 0 || x <= type(uint256).max / y);

        assertEq(WadRayMath.rayMulDown(x, y), mathRef.rayMulDown(x, y));
    }

    function testRayMulDownOverflow(uint256 x, uint256 y) public {
        vm.assume(y > 0 && x > type(uint256).max / y);

        vm.expectRevert();
        WadRayMath.rayMulDown(x, y);
    }

    function testRayMulUp() public {
        assertEq(WadRayMath.rayMulUp(RAY - 1, RAY - 1), RAY - 1);
    }

    function testRayMulUpRef(uint256 x, uint256 y) public {
        vm.assume(y == 0 || x <= (type(uint256).max - RAY - 1) / y);

        assertEq(WadRayMath.rayMulUp(x, y), mathRef.rayMulUp(x, y));
    }

    function testRayMulUpOverflow(uint256 x, uint256 y) public {
        vm.assume(y > 0 && x > (type(uint256).max - RAY - 1) / y);

        vm.expectRevert();
        WadRayMath.rayMulUp(x, y);
    }

    function testRayDivRef(uint256 x, uint256 y) public {
        vm.assume(y > 0 && x <= (type(uint256).max - y / 2) / RAY);

        assertEq(WadRayMath.rayDiv(x, y), WadRayMathRef.rayDiv(x, y));
    }

    function testRayDivOverflow(uint256 x, uint256 y) public {
        vm.assume(x > (type(uint256).max - y / 2) / RAY);

        vm.expectRevert();
        WadRayMath.rayDiv(x, y);
    }

    function testRayDivByZero(uint256 x) public {
        vm.expectRevert();
        WadRayMath.rayDiv(x, 0);
    }

    function testRayDivDown() public {
        assertEq(WadRayMath.rayDivDown(RAY - 2, RAY - 1), RAY - 2);
    }

    function testRayDivDownRef(uint256 x, uint256 y) public {
        vm.assume(y > 0 && x <= type(uint256).max / RAY);

        assertEq(WadRayMath.rayDivDown(x, y), mathRef.rayDivDown(x, y));
    }

    function testRayDivDownOverflow(uint256 x, uint256 y) public {
        vm.assume(y > 0 && x > type(uint256).max / RAY);

        vm.expectRevert();
        WadRayMath.rayDivDown(x, y);
    }

    function testRayDivDownByZero(uint256 x) public {
        vm.expectRevert();
        WadRayMath.rayDivDown(x, 0);
    }

    function testRayDivUp() public {
        assertEq(WadRayMath.rayDivUp(RAY - 2, RAY - 1), RAY - 1);
    }

    function testRayDivUpRef(uint256 x, uint256 y) public {
        vm.assume(y > 0 && x <= (type(uint256).max - (y - 1)) / RAY);

        assertEq(WadRayMath.rayDivUp(x, y), mathRef.rayDivUp(x, y));
    }

    function testRayDivUpOverflow(uint256 x, uint256 y) public {
        vm.assume(y > 0 && x > (type(uint256).max - (y - 1)) / RAY);

        vm.expectRevert();
        WadRayMath.rayDivUp(x, y);
    }

    function testRayDivUpByZero(uint256 x) public {
        vm.expectRevert();
        WadRayMath.rayDivUp(x, 0);
    }

    function testRayToWadRef(uint256 x) public {
        assertEq(WadRayMath.rayToWad(x), WadRayMathRef.rayToWad(x));
    }

    function testWadToRayRef(uint256 x) public {
        unchecked {
            vm.assume((x * RAY_WAD_RATIO) / RAY_WAD_RATIO == x);
        }

        assertEq(WadRayMath.wadToRay(x), WadRayMathRef.wadToRay(x));
    }

    function testWadToRayOverflow(uint256 x) public {
        unchecked {
            vm.assume((x * RAY_WAD_RATIO) / RAY_WAD_RATIO != x);
        }

        vm.expectRevert();
        WadRayMath.wadToRay(x);
    }

    /// GAS COMPARISONS ///

    function testGasWadMul() public view {
        math.wadMul(2 * WAD, WAD);
        mathRef.wadMul(2 * WAD, WAD);
    }

    function testGasWadMulDown() public view {
        math.wadMulDown(2 * WAD, WAD);
        mathRef.wadMulDown(2 * WAD, WAD);
    }

    function testGasWadMulUp() public view {
        math.wadMulUp(2 * WAD, WAD);
        mathRef.wadMulUp(2 * WAD, WAD);
    }

    function testGasWadDiv() public view {
        math.wadDiv(10 * WAD, WAD);
        mathRef.wadDiv(10 * WAD, WAD);
    }

    function testGasWadDivDown() public view {
        math.wadDivDown(2 * WAD, WAD);
        mathRef.wadDivDown(2 * WAD, WAD);
    }

    function testGasWadDivUp() public view {
        math.wadDivUp(2 * WAD, WAD);
        mathRef.wadDivUp(2 * WAD, WAD);
    }

    function testGasRayMul() public view {
        math.rayMul(2 * RAY, RAY);
        mathRef.rayMul(2 * RAY, RAY);
    }

    function testGasRayMulDown() public view {
        math.rayMulDown(2 * WAD, WAD);
        mathRef.rayMulDown(2 * WAD, WAD);
    }

    function testGasRayMulUp() public view {
        math.rayMulUp(2 * WAD, WAD);
        mathRef.rayMulUp(2 * WAD, WAD);
    }

    function testGasRayDiv() public view {
        math.rayDiv(10 * RAY, RAY);
        mathRef.rayDiv(10 * RAY, RAY);
    }

    function testGasRayDivDown() public view {
        math.rayDivDown(2 * WAD, WAD);
        mathRef.rayDivDown(2 * WAD, WAD);
    }

    function testGasRayDivUp() public view {
        math.rayDivUp(2 * WAD, WAD);
        mathRef.rayDivUp(2 * WAD, WAD);
    }

    function testGasRayToWad() public view {
        math.rayToWad(2 * RAY + 0.6e9);
        mathRef.rayToWad(2 * RAY + 0.6e9);
    }

    function testGasWadToRay() public view {
        math.wadToRay(2 * WAD);
        mathRef.wadToRay(2 * WAD);
    }
}
