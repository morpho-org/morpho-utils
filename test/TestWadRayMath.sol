// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "forge-std/console.sol";
import "forge-std/Test.sol";
import "forge-std/Vm.sol";
import "src/WadRayMath.sol";
import {WadRayMath as RefWadRayMath} from "@aave/core-v3/contracts/protocol/libraries/math/WadRayMath.sol";

// Needed for gas report.
contract WadRayMathFunctions {
    function rayMul(uint256 x, uint256 y) public pure returns (uint256) {
        return WadRayMath.rayMul(x, y);
    }

    function refRayMul(uint256 x, uint256 y) public pure returns (uint256) {
        return RefWadRayMath.rayMul(x, y);
    }

    function rayDiv(uint256 x, uint256 y) public pure returns (uint256) {
        return WadRayMath.rayDiv(x, y);
    }

    function refRayDiv(uint256 x, uint256 y) public pure returns (uint256) {
        return RefWadRayMath.rayDiv(x, y);
    }
}

contract TestWadRayMath is Test {
    uint256 internal constant WAD = 1e18;
    uint256 internal constant RAY = 1e27;

    WadRayMathFunctions math;

    function setUp() public {
        math = new WadRayMathFunctions();
    }

    function testRayMul(uint128 _x, uint128 _y) public {
        uint256 x = _x;
        uint256 y = _y;
        assertEq(WadRayMath.rayMul(x, y), RefWadRayMath.rayMul(x, y));
    }

    function testRayDiv(uint128 _x, uint128 _y) public {
        vm.assume(_y > 0);
        uint256 x = _x;
        uint256 y = _y;
        assertEq(WadRayMath.rayDiv(x, y), RefWadRayMath.rayDiv(x, y));
    }

    function testGasRayMul() public view {
        math.rayMul(2 * RAY, RAY);
    }

    function testGasRefRayMul() public view {
        math.refRayMul(2 * RAY, RAY);
    }

    function testGasRayDiv() public view {
        math.rayDiv(10 * RAY, RAY);
    }

    function testGasRefRayDiv() public view {
        math.refRayDiv(10 * RAY, RAY);
    }
}
