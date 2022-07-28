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

    function wadDiv(uint256 x, uint256 y) public pure returns (uint256) {
        return WadRayMath.wadDiv(x, y);
    }

    function rayMul(uint256 x, uint256 y) public pure returns (uint256) {
        return WadRayMath.rayMul(x, y);
    }

    function rayDiv(uint256 x, uint256 y) public pure returns (uint256) {
        return WadRayMath.rayDiv(x, y);
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

    function wadDiv(uint256 x, uint256 y) public pure returns (uint256) {
        return WadRayMathRef.wadDiv(x, y);
    }

    function rayMul(uint256 x, uint256 y) public pure returns (uint256) {
        return WadRayMathRef.rayMul(x, y);
    }

    function rayDiv(uint256 x, uint256 y) public pure returns (uint256) {
        return WadRayMathRef.rayDiv(x, y);
    }

    function rayToWad(uint256 x) public pure returns (uint256) {
        return WadRayMathRef.rayToWad(x);
    }

    function wadToRay(uint256 x) public pure returns (uint256) {
        return WadRayMathRef.wadToRay(x);
    }
}

contract TestWadRayMath is Test {
    uint256 public constant WAD = 1e18;
    uint256 public constant HALF_WAD = 0.5e18;
    uint256 public constant RAY = 1e27;
    uint256 public constant HALF_RAY = 0.5e27;
    uint256 public constant WAD_RAY_RATIO = 1e9;
    uint256 public constant HALF_WAD_RAY_RATIO = 0.5e9;
    uint256 public constant MAX_UINT256 = 2**256 - 1; // Not possible to use type(uint256).max in yul.
    uint256 public constant MAX_UINT256_MINUS_HALF_WAD = 2**256 - 1 - 0.5e18;
    uint256 public constant MAX_UINT256_MINUS_HALF_RAY = 2**256 - 1 - 0.5e27;

    WadRayMathFunctions math;
    WadRayMathFunctionsRef mathRef;

    function setUp() public {
        math = new WadRayMathFunctions();
        mathRef = new WadRayMathFunctionsRef();
    }

    /// TESTS ///

    function testWadMul(uint256 x, uint256 y) public {
        unchecked {
            if (y > 0 && x > MAX_UINT256_MINUS_HALF_WAD / y) {
                vm.expectRevert();
                WadRayMath.wadMul(x, y);
            }
        }

        assertEq(WadRayMath.wadMul(x, y), WadRayMathRef.wadMul(x, y));
    }

    function testWadDiv(uint256 x, uint256 y) public {
        unchecked {
            if (y == 0 || x > (type(uint256).max - y / 2) / WAD) {
                vm.expectRevert();
                WadRayMath.wadDiv(x, y);
            }
        }

        assertEq(WadRayMath.wadDiv(x, y), WadRayMathRef.wadDiv(x, y));
    }

    function testRayMul(uint256 x, uint256 y) public {
        unchecked {
            if (y > 0 && x > MAX_UINT256_MINUS_HALF_RAY / y) {
                vm.expectRevert();
                WadRayMath.rayMul(x, y);
            }
        }

        assertEq(WadRayMath.rayMul(x, y), WadRayMathRef.rayMul(x, y));
    }

    function testRayDiv(uint256 x, uint256 y) public {
        unchecked {
            if (y == 0 || x > (type(uint256).max - y / 2) / RAY) {
                vm.expectRevert();
                WadRayMath.rayDiv(x, y);
            }
        }

        assertEq(WadRayMath.rayDiv(x, y), WadRayMathRef.rayDiv(x, y));
    }

    function testRayToWad(uint256 x) public {
        assertEq(WadRayMath.rayToWad(x), WadRayMathRef.rayToWad(x));
    }

    function testWadToRay(uint256 x) public {
        unchecked {
            if ((x * WAD_RAY_RATIO) / WAD_RAY_RATIO != x) {
                vm.expectRevert();
                WadRayMath.wadToRay(x);
            }
        }

        assertEq(WadRayMath.wadToRay(x), WadRayMathRef.wadToRay(x));
    }

    /// GAS COMPARISONS ///

    function testGasWadMul() public view {
        math.wadMul(2 * WAD, WAD);
        mathRef.wadMul(2 * WAD, WAD);
    }

    function testGasWadDiv() public view {
        math.wadDiv(10 * WAD, WAD);
        mathRef.wadDiv(10 * WAD, WAD);
    }

    function testGasRayMul() public view {
        math.rayMul(2 * RAY, RAY);
        mathRef.rayMul(2 * RAY, RAY);
    }

    function testGasRayDiv() public view {
        math.rayDiv(10 * RAY, RAY);
        mathRef.rayDiv(10 * RAY, RAY);
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
