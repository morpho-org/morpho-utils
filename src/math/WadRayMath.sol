// SPDX-License-Identifier: GNU AGPLv3
pragma solidity ^0.8.0;

/// @title WadRayMath.
/// @author Morpho Labs.
/// @custom:contact security@morpho.xyz
/// @notice Optimized version of Aave V3 math library WadRayMath to conduct wad and ray manipulations: https://github.com/aave/aave-v3-core/blob/master/contracts/protocol/libraries/math/WadRayMath.sol
library WadRayMath {
    /// CONSTANTS ///

    uint256 internal constant WAD = 1e18;
    uint256 internal constant HALF_WAD = 0.5e18;
    uint256 internal constant RAY = 1e27;
    uint256 internal constant HALF_RAY = 0.5e27;
    uint256 internal constant WAD_RAY_RATIO = 1e9;
    uint256 internal constant HALF_WAD_RAY_RATIO = 0.5e9;
    uint256 internal constant MAX_UINT256 = 2**256 - 1; // Not possible to use type(uint256).max in yul.
    uint256 internal constant MAX_UINT256_MINUS_HALF_WAD = 2**256 - 1 - 0.5e18;
    uint256 internal constant MAX_UINT256_MINUS_HALF_RAY = 2**256 - 1 - 0.5e27;

    /// INTERNAL ///

    /// @dev Executes the wad-based multiplication of 2 numbers, rounded half up.
    /// @param x Wad.
    /// @param y Wad.
    /// @return z The result of x * y, in wad.
    function wadMul(uint256 x, uint256 y) internal pure returns (uint256 z) {
        // Let y > 0
        // Overflow if (x * y + HALF_WAD) > type(uint256).max
        // <=> x * y > type(uint256).max - HALF_WAD
        // <=> x > (type(uint256).max - HALF_WAD) / y
        assembly {
            if mul(y, gt(x, div(MAX_UINT256_MINUS_HALF_WAD, y))) {
                revert(0, 0)
            }

            z := div(add(mul(x, y), HALF_WAD), WAD)
        }
    }

    /// @dev Executes wad-based division of 2 numbers, rounded half up.
    /// @param x Wad.
    /// @param y Wad.
    /// @return z The result of x / y, in wad.
    function wadDiv(uint256 x, uint256 y) internal pure returns (uint256 z) {
        // Overflow if y == 0
        // Overflow if (x * WAD + y / 2) > type(uint256).max
        // <=> x * WAD > type(uint256).max - y / 2
        // <=> x > (type(uint256).max - y / 2) / WAD
        assembly {
            z := div(y, 2)
            if iszero(mul(y, iszero(gt(x, div(sub(MAX_UINT256, z), WAD))))) {
                revert(0, 0)
            }

            z := div(add(mul(WAD, x), z), y)
        }
    }

    /// @dev Executes the ray-based multiplication of 2 numbers, rounded half up.
    /// @param x Ray.
    /// @param y Ray.
    /// @return z The result of x * y, in ray.
    function rayMul(uint256 x, uint256 y) internal pure returns (uint256 z) {
        // Let y > 0
        // Overflow if (x * y + HALF_RAY) > type(uint256).max
        // <=> x * y > type(uint256).max - HALF_RAY
        // <=> x > (type(uint256).max - HALF_RAY) / y
        assembly {
            if mul(y, gt(x, div(MAX_UINT256_MINUS_HALF_RAY, y))) {
                revert(0, 0)
            }

            z := div(add(mul(x, y), HALF_RAY), RAY)
        }
    }

    /// @dev Executes the ray-based division of 2 numbers, rounded half up.
    /// @param x Ray.
    /// @param y Ray.
    /// @return z The result of x / y, in ray.
    function rayDiv(uint256 x, uint256 y) internal pure returns (uint256 z) {
        // Overflow if y == 0
        // Overflow if (x * RAY + y / 2) > type(uint256).max
        // <=> x * RAY > type(uint256).max - y / 2
        // <=> x > (type(uint256).max - y / 2) / RAY
        assembly {
            z := div(y, 2)
            if iszero(mul(y, iszero(gt(x, div(sub(MAX_UINT256, z), RAY))))) {
                revert(0, 0)
            }

            z := div(add(mul(RAY, x), z), y)
        }
    }

    /// @dev Converts ray down to wad.
    /// @param x Ray.
    /// @return y = x converted to wad, rounded half up to the nearest wad.
    function rayToWad(uint256 x) internal pure returns (uint256 y) {
        assembly {
            // If x % WAD_RAY_RATIO >= HALF_WAD_RAY_RATIO, round up.
            y := add(div(x, WAD_RAY_RATIO), iszero(lt(mod(x, WAD_RAY_RATIO), HALF_WAD_RAY_RATIO)))
        }
    }

    /// @dev Converts wad up to ray.
    /// @param x Wad.
    /// @return y = x converted in ray.
    function wadToRay(uint256 x) internal pure returns (uint256 y) {
        assembly {
            y := mul(WAD_RAY_RATIO, x)
            // Revert if y / WAD_RAY_RATIO != x
            if iszero(eq(div(y, WAD_RAY_RATIO), x)) {
                revert(0, 0)
            }
        }
    }

    /// @notice Computes the wad-based weighted average (x * (1 - p) + y * p), rounded half up.
    /// @param x The first value, with a weight of 1 - weight.
    /// @param y The second value, with a weight of weight.
    /// @param weight The weight of y, and complement of the weight of x (in wad).
    /// @return z The result of the wad-based weighted average.
    function wadWeightedAvg(
        uint256 x,
        uint256 y,
        uint256 weight
    ) internal pure returns (uint256 z) {
        // Must revert if
        //     weight > WAD
        // or if
        //     y * weight + HALF_WAD > type(uint256).max
        //     <=> weight > 0 and y > (type(uint256).max - HALF_WAD) / weight
        // or if
        //     x * (WAD - weight) + y * weight + HALF_WAD > type(uint256).max
        //     <=> (WAD - weight) > 0 and x > (type(uint256).max - HALF_WAD - y * weight) / (WAD - weight)
        assembly {
            z := sub(WAD, weight) // Temporary assignment to save gas.
            if or(
                gt(weight, WAD),
                or(
                    mul(weight, gt(y, div(MAX_UINT256_MINUS_HALF_WAD, weight))),
                    mul(z, gt(x, div(sub(MAX_UINT256_MINUS_HALF_WAD, mul(y, weight)), z)))
                )
            ) {
                revert(0, 0)
            }
            z := div(add(add(mul(x, z), mul(y, weight)), HALF_WAD), WAD)
        }
    }

    /// @notice Computes the ray-based weighted average (x * (1 - p) + y * p), rounded half up.
    /// @param x The first value, with a weight of 1 - weight.
    /// @param y The second value, with a weight of weight.
    /// @param weight The weight of y, and complement of the weight of x (in ray).
    /// @return z The result of the ray-based weighted average.
    function rayWeightedAvg(
        uint256 x,
        uint256 y,
        uint256 weight
    ) internal pure returns (uint256 z) {
        // Must revert if
        //     weight > RAY
        // or if
        //     y * weight + HALF_RAY > type(uint256).max
        //     <=> weight > 0 and y > (type(uint256).max - HALF_RAY) / weight
        // or if
        //     x * (RAY - weight) + y * weight + HALF_RAY > type(uint256).max
        //     <=> (RAY - weight) > 0 and x > (type(uint256).max - HALF_RAY - y * weight) / (RAY - weight)
        assembly {
            z := sub(RAY, weight) // Temporary assignment to save gas.
            if or(
                gt(weight, RAY),
                or(
                    mul(weight, gt(y, div(MAX_UINT256_MINUS_HALF_RAY, weight))),
                    mul(z, gt(x, div(sub(MAX_UINT256_MINUS_HALF_RAY, mul(y, weight)), z)))
                )
            ) {
                revert(0, 0)
            }
            z := div(add(add(mul(x, z), mul(y, weight)), HALF_RAY), RAY)
        }
    }
}
