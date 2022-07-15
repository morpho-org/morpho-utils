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
}

contract TestWadRayMath is Test {
    WadRayMathFunctions math;

    function setUp() public {
        math = new WadRayMathFunctions();
    }

    function testRayMul(uint128 _x, uint128 _y) public {
        uint256 x = _x;
        uint256 y = _y;
        assertEq(WadRayMath.rayMul(x, y), RefWadRayMath.rayMul(x, y));
    }

    function testGasRayMul() public view {
        math.rayMul(10, 10);
    }

    function testGasRefRayMul() public view {
        math.refRayMul(10, 10);
    }
}
