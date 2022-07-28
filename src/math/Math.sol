// SPDX-License-Identifier: GNU AGPLv3
pragma solidity ^0.8.0;

library Math {
    function min(uint256 x, uint256 y) internal pure returns (uint256 z) {
        assembly {
            z := x
            if lt(y, x) {
                z := y
            }
        }
    }

    function max(uint256 x, uint256 y) internal pure returns (uint256 z) {
        assembly {
            z := x
            if gt(y, x) {
                z := y
            }
        }
    }

    /// @dev Returns max(x - y, 0).
    function zeroFloorSub(uint256 x, uint256 y) internal pure returns (uint256 z) {
        assembly {
            if gt(x, y) {
                z := sub(x, y)
            }
        }
    }

    /// @dev Returns x / y rounded up.
    function divUp(uint256 x, uint256 y) internal pure returns (uint256 z) {
        assembly {
            // Revert if a + b < a or a + b < b
            z := add(x, y)
            if or(iszero(y), or(lt(z, y), lt(z, x))) {
                revert(0, 0)
            }
            z := div(sub(z, 1), y)
        }
    }
}
