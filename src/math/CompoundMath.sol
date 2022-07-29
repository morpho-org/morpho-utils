// SPDX-License-Identifier: GNU AGPLv3
pragma solidity ^0.8.0;

/// @title Compound Math Library.
/// @author Morpho Labs.
/// @custom:contact security@morpho.xyz
/// @dev Library to perform Compound's multiplication and division in an efficient way.
library CompoundMath {
    /// CONSTANTS ///

    uint256 public constant SCALE = 1e36;
    uint256 public constant WAD = 1e18;

    /// INTERNAL ///

    function mul(uint256 x, uint256 y) internal pure returns (uint256 z) {
        assembly {
            z := mul(x, y)
            // Revert if x > 0 and (x * y) / x != x
            if iszero(or(iszero(x), eq(div(z, x), y))) {
                revert(0, 0)
            }

            z := div(z, WAD)
        }
    }

    function div(uint256 x, uint256 y) internal pure returns (uint256 z) {
        assembly {
            z := mul(x, SCALE)
            // Revert if y > 0 or x > 0 and (x * SCALE) / x != SCALE
            if or(iszero(y), iszero(or(iszero(x), eq(div(z, x), SCALE)))) {
                revert(0, 0)
            }

            z := div(div(z, y), WAD)
        }
    }
}
