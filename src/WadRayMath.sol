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
}
