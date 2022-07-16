// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "forge-std/console.sol";
import "forge-std/Test.sol";
import "forge-std/Vm.sol";
import "src/WadRayMath.sol";
import {WadRayMath as WadRayMathRef} from "@aave/core-v3/contracts/protocol/libraries/math/WadRayMath.sol";

// Needed for gas report.
contract WadRayMathFunctions {
    function rayMul(uint256 x, uint256 y) public pure returns (uint256) {
        return WadRayMath.rayMul(x, y);
    }

    function rayMulRef(uint256 x, uint256 y) public pure returns (uint256) {
        return WadRayMathRef.rayMul(x, y);
    }

    function rayDiv(uint256 x, uint256 y) public pure returns (uint256) {
        return WadRayMath.rayDiv(x, y);
    }

    function rayDivRef(uint256 x, uint256 y) public pure returns (uint256) {
        return WadRayMathRef.rayDiv(x, y);
    }

    function wadMul(uint256 x, uint256 y) public pure returns (uint256) {
        return WadRayMath.wadMul(x, y);
    }

    function wadMulRef(uint256 x, uint256 y) public pure returns (uint256) {
        return WadRayMathRef.wadMul(x, y);
    }

    function wadDiv(uint256 x, uint256 y) public pure returns (uint256) {
        return WadRayMath.wadDiv(x, y);
    }

    function wadDivRef(uint256 x, uint256 y) public pure returns (uint256) {
        return WadRayMathRef.wadDiv(x, y);
    }

    function rayToWad(uint256 x) public pure returns (uint256) {
        return WadRayMath.rayToWad(x);
    }

    function rayToWadRef(uint256 x) public pure returns (uint256) {
        return WadRayMathRef.rayToWad(x);
    }

    function wadToRay(uint256 x) public pure returns (uint256) {
        return WadRayMath.wadToRay(x);
    }

    function wadToRayRef(uint256 x) public pure returns (uint256) {
        return WadRayMathRef.wadToRay(x);
    }
}

contract TestWadRayMath is Test {
    uint256 internal constant WAD = 1e18;
    uint256 internal constant RAY = 1e27;

    WadRayMathFunctions math;

    function setUp() public {
        math = new WadRayMathFunctions();
    }

    /// TESTS ///

    function testRayMul(uint128 _x, uint128 _y) public {
        uint256 x = _x;
        uint256 y = _y;
        assertEq(WadRayMath.rayMul(x, y), WadRayMathRef.rayMul(x, y));
    }

    function testRayDiv(uint128 _x, uint128 _y) public {
        vm.assume(_y > 0);
        uint256 x = _x;
        uint256 y = _y;
        assertEq(WadRayMath.rayDiv(x, y), WadRayMathRef.rayDiv(x, y));
    }

    function testWadMul(uint128 _x, uint128 _y) public {
        uint256 x = _x;
        uint256 y = _y;
        assertEq(WadRayMath.wadMul(x, y), WadRayMathRef.wadMul(x, y));
    }

    function testWadDiv(uint128 _x, uint128 _y) public {
        vm.assume(_y > 0);
        uint256 x = _x;
        uint256 y = _y;
        assertEq(WadRayMath.wadDiv(x, y), WadRayMathRef.wadDiv(x, y));
    }

    function testRayToWad(uint128 _x) public {
        uint256 x = _x;
        assertEq(WadRayMath.rayToWad(x), WadRayMathRef.rayToWad(x));
    }

    function testWadToRay(uint128 _x) public {
        uint256 x = _x;
        assertEq(WadRayMath.wadToRay(x), WadRayMathRef.wadToRay(x));
    }

    /// GAS COMPARISONS ///

    function testGasRayMul() public view {
        math.rayMul(2 * RAY, RAY);
    }

    function testGasRayMulRef() public view {
        math.rayMulRef(2 * RAY, RAY);
    }

    function testGasRayDiv() public view {
        math.rayDiv(10 * RAY, RAY);
    }

    function testGasRayDivRef() public view {
        math.rayDivRef(10 * RAY, RAY);
    }

    function testGasWadMul() public view {
        math.wadMul(2 * WAD, WAD);
    }

    function testGasWadMulRef() public view {
        math.wadMulRef(2 * WAD, WAD);
    }

    function testGasWadDiv() public view {
        math.wadDiv(10 * WAD, WAD);
    }

    function testGasWadDivRef() public view {
        math.wadDivRef(10 * WAD, WAD);
    }

    function testGasRayToWad() public view {
        math.rayToWad(2 * RAY + 0.6e9);
    }

    function testGasRayToWadRef() public view {
        math.rayToWadRef(2 * RAY + 0.6e9);
    }

    function testGasWadToRay() public view {
        math.wadToRay(2 * WAD);
    }

    function testGasWadToRayRef() public view {
        math.wadToRayRef(2 * WAD);
    }
}
