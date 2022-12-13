// SPDX-License-Identifier: GNU AGPLv3
pragma solidity ^0.8.0;

/// @title WadRayMath.
/// @author Morpho Labs.
/// @custom:contact security@morpho.xyz
/// @notice Optimized version of Aave V3 math library WadRayMath to conduct wad and ray manipulations: https://github.com/aave/aave-v3-core/blob/master/contracts/protocol/libraries/math/WadRayMath.sol
library WadRayMath {
    /// CONSTANTS ///

    // Only direct number constants and references to such constants are supported by inline assembly.
    uint256 internal constant WAD = 1e18;
    uint256 internal constant HALF_WAD = 0.5e18;
    uint256 internal constant WAD_MINUS_ONE = 1e18 - 1;
    uint256 internal constant RAY = 1e27;
    uint256 internal constant HALF_RAY = 0.5e27;
    uint256 internal constant RAY_MINUS_ONE = 1e27 - 1;
    uint256 internal constant RAY_WAD_RATIO = 1e9;
    uint256 internal constant HALF_RAY_WAD_RATIO = 0.5e9;
    uint256 internal constant MAX_UINT256 = 2**256 - 1;
    uint256 internal constant MAX_UINT256_MINUS_HALF_WAD = 2**256 - 1 - 0.5e18;
    uint256 internal constant MAX_UINT256_MINUS_HALF_RAY = 2**256 - 1 - 0.5e27;
    uint256 internal constant MAX_UINT256_MINUS_WAD_MINUS_ONE = 2**256 - 1 - (1e18 - 1);
    uint256 internal constant MAX_UINT256_MINUS_RAY_MINUS_ONE = 2**256 - 1 - (1e27 - 1);
    uint256 internal constant MAX_UINT256_WAD_RATIO = 0x12725dd1d243aba0e75fe645cc4873f9e65afe688c928e1f21;
    uint256 internal constant MAX_UINT256_RAY_RATIO = 0x4f3a68dbc8f03f243baf513267aa9a3ee524F8e028;

    /// INTERNAL ///

    /// @dev Multiplies two wad, rounding half up the result.
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

    /// @dev Multiplies two wad, flooring the result.
    /// @param x Wad.
    /// @param y Wad.
    /// @return z The result of x * y, in wad.
    function wadMulDown(uint256 x, uint256 y) internal pure returns (uint256 z) {
        // Let y > 0
        // Overflow if (x * y) > type(uint256).max
        // <=> x > type(uint256).max / y
        assembly {
            if mul(y, gt(x, div(MAX_UINT256, y))) {
                revert(0, 0)
            }

            z := div(mul(x, y), WAD)
        }
    }

    /// @dev Multiplies two wad, ceiling the result.
    /// @param x Wad.
    /// @param y Wad.
    /// @return z The result of x * y, in wad.
    function wadMulUp(uint256 x, uint256 y) internal pure returns (uint256 z) {
        // Let y > 0
        // Overflow if (x * y + WAD_MINUS_ONE) > type(uint256).max
        // <=> x * y > type(uint256).max - WAD_MINUS_ONE
        // <=> x > (type(uint256).max - WAD_MINUS_ONE) / y
        assembly {
            if mul(y, gt(x, div(MAX_UINT256_MINUS_WAD_MINUS_ONE, y))) {
                revert(0, 0)
            }

            z := div(add(mul(x, y), WAD_MINUS_ONE), WAD)
        }
    }

    /// @dev Divides two wad, rounding half up the result.
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

    /// @dev Divides two wad, flooring the result.
    /// @param x Wad.
    /// @param y Wad.
    /// @return z The result of x / y, in wad.
    function wadDivDown(uint256 x, uint256 y) internal pure returns (uint256 z) {
        // Overflow if y == 0
        // Overflow if (x * WAD) > type(uint256).max
        // <=> x > type(uint256).max / WAD
        assembly {
            if iszero(mul(y, iszero(gt(x, MAX_UINT256_WAD_RATIO)))) {
                revert(0, 0)
            }

            z := div(mul(WAD, x), y)
        }
    }

    /// @dev Divides two wad, ceiling the result.
    /// @param x Wad.
    /// @param y Wad.
    /// @return z The result of x / y, in wad.
    function wadDivUp(uint256 x, uint256 y) internal pure returns (uint256 z) {
        // Overflow if y == 0
        // Overflow if (x * WAD + y - 1) > type(uint256).max
        // <=> x * WAD > type(uint256).max - (y - 1)
        // <=> x > (type(uint256).max - (y - 1)) / WAD
        assembly {
            z := sub(y, 1)
            if iszero(mul(y, iszero(gt(x, div(sub(MAX_UINT256, z), WAD))))) {
                revert(0, 0)
            }

            z := div(add(mul(WAD, x), z), y)
        }
    }

    /// @dev Multiplies two ray, rounding half up the result.
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

    /// @dev Multiplies two ray, flooring the result.
    /// @param x Ray.
    /// @param y Ray.
    /// @return z The result of x * y, in ray.
    function rayMulDown(uint256 x, uint256 y) internal pure returns (uint256 z) {
        // Let y > 0
        // Overflow if (x * y) > type(uint256).max
        // <=> x > type(uint256).max / y
        assembly {
            if mul(y, gt(x, div(MAX_UINT256, y))) {
                revert(0, 0)
            }

            z := div(mul(x, y), RAY)
        }
    }

    /// @dev Multiplies two ray, ceiling the result.
    /// @param x Ray.
    /// @param y Wad.
    /// @return z The result of x * y, in ray.
    function rayMulUp(uint256 x, uint256 y) internal pure returns (uint256 z) {
        // Let y > 0
        // Overflow if (x * y + RAY_MINUS_ONE) > type(uint256).max
        // <=> x * y > type(uint256).max - RAY_MINUS_ONE
        // <=> x > (type(uint256).max - RAY_MINUS_ONE) / y
        assembly {
            if mul(y, gt(x, div(MAX_UINT256_MINUS_RAY_MINUS_ONE, y))) {
                revert(0, 0)
            }

            z := div(add(mul(x, y), RAY_MINUS_ONE), RAY)
        }
    }

    /// @dev Divides two ray, rounding half up the result.
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

    /// @dev Divides two ray, flooring the result.
    /// @param x Wad.
    /// @param y Wad.
    /// @return z The result of x / y, in ray.
    function rayDivDown(uint256 x, uint256 y) internal pure returns (uint256 z) {
        // Overflow if y == 0
        // Overflow if (x * RAY) > type(uint256).max
        // <=> x > type(uint256).max / RAY
        assembly {
            if iszero(mul(y, iszero(gt(x, MAX_UINT256_RAY_RATIO)))) {
                revert(0, 0)
            }

            z := div(mul(RAY, x), y)
        }
    }

    /// @dev Divides two ray, ceiling the result.
    /// @param x Wad.
    /// @param y Wad.
    /// @return z The result of x / y, in ray.
    function rayDivUp(uint256 x, uint256 y) internal pure returns (uint256 z) {
        // Overflow if y == 0
        // Overflow if (x * RAY + y - 1) > type(uint256).max
        // <=> x * RAY > type(uint256).max - (y - 1)
        // <=> x > (type(uint256).max - (y - 1)) / RAY
        assembly {
            z := sub(y, 1)
            if iszero(mul(y, iszero(gt(x, div(sub(MAX_UINT256, z), RAY))))) {
                revert(0, 0)
            }

            z := div(add(mul(RAY, x), z), y)
        }
    }

    /// @dev Casts ray down to wad.
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
        assembly {
            y := mul(RAY_WAD_RATIO, x)
            // Revert if y / RAY_WAD_RATIO != x
            if iszero(eq(div(y, RAY_WAD_RATIO), x)) {
                revert(0, 0)
            }
        }
    }
}
