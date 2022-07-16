// SPDX-License-Identifier: GNU AGPLv3
pragma solidity ^0.8.0;

/// @title WadRayMath.
/// @author Morpho Labs.
/// @custom:contact security@morpho.xyz
/// @notice Library to conduct wad and ray manipulations inspired Aave's libraries.
library WadRayMath {
    /// CONSTANTS ///

    uint256 internal constant WAD = 1e18;
    uint256 internal constant HALF_WAD = 0.5e18;
    uint256 internal constant RAY = 1e27;
    uint256 internal constant HALF_RAY = 0.5e27;
    uint256 internal constant WAD_RAY_RATIO = 1e9;

    /// INTERNAL ///

    function wadMul(uint256 x, uint256 y) internal pure returns (uint256 z) {
        // Let y > 0
        // Overflow if (x * y + HALF_WAD) > type(uint256).max
        // <=> x * y > type(uint256).max - HALF_WAD
        // <=> x > type(uint256).max - HALF_WAD / y
        assembly {
            if and(y, gt(x, div(sub(not(0), HALF_WAD), y))) {
                revert(0, 0)
            }

            z := div(add(mul(x, y), HALF_WAD), WAD)
        }
    }

    function wadDiv(uint256 x, uint256 y) internal pure returns (uint256 z) {
        // Overflow if y == 0
        // Overflow if (x * WAD + y / 2) > type(uint256).max
        // <=> x * WAD > type(uint256).max - y / 2
        // <=> x > (type(uint256).max - y / 2) / WAD
        assembly {
            if or(iszero(y), gt(x, div(sub(not(0), div(y, 2)), WAD))) {
                revert(0, 0)
            }

            z := div(add(mul(x, WAD), div(y, 2)), y)
        }
    }

    function rayMul(uint256 x, uint256 y) internal pure returns (uint256 z) {
        // Let y > 0
        // Overflow if (x * y + HALF_RAY) > type(uint256).max
        // <=> x * y > type(uint256).max - HALF_RAY
        // <=> x > type(uint256).max - HALF_RAY / y
        assembly {
            if and(y, gt(x, div(sub(not(0), HALF_RAY), y))) {
                revert(0, 0)
            }

            z := div(add(mul(x, y), HALF_RAY), RAY)
        }
    }

    function rayDiv(uint256 x, uint256 y) internal pure returns (uint256 z) {
        // Overflow if y == 0
        // Overflow if (x * RAY + y / 2) > type(uint256).max
        // <=> x * RAY > type(uint256).max - y / 2
        // <=> x > (type(uint256).max - y / 2) / RAY
        assembly {
            if or(iszero(y), gt(x, div(sub(not(0), div(y, 2)), RAY))) {
                revert(0, 0)
            }

            z := div(add(mul(x, RAY), div(y, 2)), y)
        }
    }

    function rayToWad(uint256 x) internal pure returns (uint256 y) {
        assembly {
            y := div(x, WAD_RAY_RATIO)
            if iszero(lt(mod(x, WAD_RAY_RATIO), div(WAD_RAY_RATIO, 2))) {
                y := add(y, 1)
            }
        }
    }

    function wadToRay(uint256 x) internal pure returns (uint256 y) {
        assembly {
            y := mul(x, WAD_RAY_RATIO)
            if iszero(eq(div(y, WAD_RAY_RATIO), x)) {
                revert(0, 0)
            }
        }
    }
}
