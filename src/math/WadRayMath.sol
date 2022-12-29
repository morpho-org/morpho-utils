// SPDX-License-Identifier: AGPL-3.0-only
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
    uint256 internal constant RAY_WAD_RATIO = 1e9;
    uint256 internal constant HALF_RAY_WAD_RATIO = 0.5e9;
    uint256 internal constant MAX_UINT256 = 2 ** 256 - 1; // Not possible to use type(uint256).max in yul.
    uint256 internal constant MAX_UINT256_MINUS_HALF_WAD = 2 ** 256 - 1 - 0.5e18;
    uint256 internal constant MAX_UINT256_MINUS_HALF_RAY = 2 ** 256 - 1 - 0.5e27;

    /// INTERNAL ///

    /// @dev Executes the wad-based multiplication of 2 numbers, rounded half up.
    /// @param x Wad.
    /// @param y Wad.
    /// @return z The result of x * y, in wad.
    function wadMul(uint256 x, uint256 y) internal pure returns (uint256 z) {
        // Overflow if
        //     x * y + HALF_WAD > type(uint256).max
        // <=> x * y > type(uint256).max - HALF_WAD
        // <=> y > 0 and x > (type(uint256).max - HALF_WAD) / y
        assembly {
            if mul(y, gt(x, div(MAX_UINT256_MINUS_HALF_WAD, y))) { revert(0, 0) }

            z := div(add(mul(x, y), HALF_WAD), WAD)
        }
    }

    /// @dev Executes wad-based division of 2 numbers, rounded half up.
    /// @param x Wad.
    /// @param y Wad.
    /// @return z The result of x / y, in wad.
    function wadDiv(uint256 x, uint256 y) internal pure returns (uint256 z) {
        // 1. Division by 0 if
        //        y == 0
        // 2. Overflow if
        //        x * WAD + y / 2 > type(uint256).max
        //    <=> x * WAD > type(uint256).max - y / 2
        //    <=> x > (type(uint256).max - y / 2) / WAD
        assembly {
            z := div(y, 2) // Temporary assignment to save gas.

            if iszero(mul(y, iszero(gt(x, div(sub(MAX_UINT256, z), WAD))))) { revert(0, 0) }

            z := div(add(mul(WAD, x), z), y)
        }
    }

    /// @dev Executes the ray-based multiplication of 2 numbers, rounded half up.
    /// @param x Ray.
    /// @param y Ray.
    /// @return z The result of x * y, in ray.
    function rayMul(uint256 x, uint256 y) internal pure returns (uint256 z) {
        // Overflow if
        //     x * y + HALF_RAY > type(uint256).max
        // <=> x * y > type(uint256).max - HALF_RAY
        // <=> y > 0 and x > (type(uint256).max - HALF_RAY) / y
        assembly {
            if mul(y, gt(x, div(MAX_UINT256_MINUS_HALF_RAY, y))) { revert(0, 0) }

            z := div(add(mul(x, y), HALF_RAY), RAY)
        }
    }

    /// @dev Executes the ray-based division of 2 numbers, rounded half up.
    /// @param x Ray.
    /// @param y Ray.
    /// @return z The result of x / y, in ray.
    function rayDiv(uint256 x, uint256 y) internal pure returns (uint256 z) {
        // 1. Division by 0 if
        //        y == 0
        // 2. Overflow if
        //        x * RAY + y / 2 > type(uint256).max
        //    <=> x * RAY > type(uint256).max - y / 2
        //    <=> x > (type(uint256).max - y / 2) / RAY
        assembly {
            z := div(y, 2) // Temporary assignment to save gas.

            if iszero(mul(y, iszero(gt(x, div(sub(MAX_UINT256, z), RAY))))) { revert(0, 0) }

            z := div(add(mul(RAY, x), z), y)
        }
    }

    /// @dev Converts ray down to wad.
    /// @param x Ray.
    /// @return y = x converted to wad, rounded half up to the nearest wad.
    function rayToWad(uint256 x) internal pure returns (uint256 y) {
        assembly {
            // If x % RAY_WAD_RATIO >= HALF_RAY_WAD_RATIO, round up.
            y := add(div(x, RAY_WAD_RATIO), iszero(lt(mod(x, RAY_WAD_RATIO), HALF_RAY_WAD_RATIO)))
        }
    }

    /// @dev Converts wad up to ray.
    /// @param x Wad.
    /// @return y = x converted in ray.
    function wadToRay(uint256 x) internal pure returns (uint256 y) {
        // Overflow if
        //     x * RAY_WAD_RATIO > type(uint256).max
        // <=> x > type(uint256).max / RAY_WAD_RATIO
        assembly {
            if gt(x, div(MAX_UINT256, RAY_WAD_RATIO)) { revert(0, 0) }

            y := mul(x, RAY_WAD_RATIO)
        }
    }

    /// @notice Computes the wad-based weighted average (x * (1 - weight) + y * weight), rounded half up.
    /// @param x The first value, with a weight of 1 - weight.
    /// @param y The second value, with a weight of weight.
    /// @param weight The weight of y, and complement of the weight of x (in wad).
    /// @return z The result of the wad-based weighted average.
    function wadWeightedAvg(uint256 x, uint256 y, uint256 weight) internal pure returns (uint256 z) {
        // 1. Underflow if
        //        weight > WAD
        // 2. Overflow if
        //        y * weight + HALF_WAD > type(uint256).max
        //    <=> weight > 0 and y > (type(uint256).max - HALF_WAD) / weight
        // 3. Overflow if
        //        x * (WAD - weight) + y * weight + HALF_WAD > type(uint256).max
        //    <=> x * (WAD - weight) > type(uint256).max - HALF_WAD - y * weight
        //    <=> WAD > weight and x > (type(uint256).max - HALF_WAD - y * weight) / (WAD - weight)
        assembly {
            z := sub(WAD, weight) // Temporary assignment to save gas.

            if or(
                gt(weight, WAD),
                or(
                    mul(weight, gt(y, div(MAX_UINT256_MINUS_HALF_WAD, weight))),
                    mul(z, gt(x, div(sub(MAX_UINT256_MINUS_HALF_WAD, mul(y, weight)), z)))
                )
            ) { revert(0, 0) }

            z := div(add(add(mul(x, z), mul(y, weight)), HALF_WAD), WAD)
        }
    }

    /// @notice Computes the ray-based weighted average (x * (1 - weight) + y * weight), rounded half up.
    /// @param x The first value, with a weight of 1 - weight.
    /// @param y The second value, with a weight of weight.
    /// @param weight The weight of y, and complement of the weight of x (in ray).
    /// @return z The result of the ray-based weighted average.
    function rayWeightedAvg(uint256 x, uint256 y, uint256 weight) internal pure returns (uint256 z) {
        // 1. Underflow if
        //        weight > RAY
        // 2. Overflow if
        //        y * weight + HALF_RAY > type(uint256).max
        //    <=> weight > 0 and y > (type(uint256).max - HALF_RAY) / weight
        // 3. Overflow if
        //        x * (RAY - weight) + y * weight + HALF_RAY > type(uint256).max
        //    <=> x * (RAY - weight) > type(uint256).max - HALF_RAY - y * weight
        //    <=> RAY > weight and x > (type(uint256).max - HALF_RAY - y * weight) / (RAY - weight)
        assembly {
            z := sub(RAY, weight) // Temporary assignment to save gas.

            if or(
                gt(weight, RAY),
                or(
                    mul(weight, gt(y, div(MAX_UINT256_MINUS_HALF_RAY, weight))),
                    mul(z, gt(x, div(sub(MAX_UINT256_MINUS_HALF_RAY, mul(y, weight)), z)))
                )
            ) { revert(0, 0) }

            z := div(add(add(mul(x, z), mul(y, weight)), HALF_RAY), RAY)
        }
    }
}
