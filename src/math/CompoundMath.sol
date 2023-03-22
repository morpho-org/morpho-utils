// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.0;

/// @title Compound Math Library.
/// @author Morpho Labs.
/// @custom:contact security@morpho.xyz
/// @dev Library to perform Compound's multiplication and division in an efficient way.
library CompoundMath {
    /* CONSTANTS */

    // Only direct number constants and references to such constants are supported by inline assembly.
    uint256 internal constant WAD = 1e18;
    uint256 internal constant MAX_UINT256 = 2 ** 256 - 1;

    /* INTERNAL */

    function mul(uint256 x, uint256 y) internal pure returns (uint256 z) {
        assembly {
            // Revert if x * y > type(uint256).max
            // <=> y > 0 and x > type(uint256).max / y
            if mul(y, gt(x, div(MAX_UINT256, y))) { revert(0, 0) }

            z := div(mul(x, y), WAD)
        }
    }

    function div(uint256 x, uint256 y) internal pure returns (uint256 z) {
        assembly {
            // Revert if x * WAD > type(uint256).max or y == 0
            // <=> x > type(uint256).max / WAD or y == 0
            if iszero(mul(y, lt(x, add(div(MAX_UINT256, WAD), 1)))) { revert(0, 0) }

            z := div(mul(WAD, x), y)
        }
    }
}
