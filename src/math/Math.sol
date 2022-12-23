// SPDX-License-Identifier: GNU AGPLv3
pragma solidity ^0.8.0;

library Math {
    function min(uint256 x, uint256 y) internal pure returns (uint256 z) {
        assembly {
            z := xor(x, mul(xor(x, y), lt(y, x)))
        }
    }

    function max(uint256 x, uint256 y) internal pure returns (uint256 z) {
        assembly {
            z := xor(x, mul(xor(x, y), gt(y, x)))
        }
    }

    /// @dev Returns max(x - y, 0).
    function zeroFloorSub(uint256 x, uint256 y) internal pure returns (uint256 z) {
        assembly {
            z := mul(gt(x, y), sub(x, y))
        }
    }

    /// @dev Returns x / y rounded up (x / y + boolAsInt(x % y > 0)).
    function divUp(uint256 x, uint256 y) internal pure returns (uint256 z) {
        assembly {
            // Revert if y = 0
            if iszero(y) {
                revert(0, 0)
            }

            z := add(gt(mod(x, y), 0), div(x, y))
        }
    }

    function roundDownPowerOf2(uint256 x) private pure returns (uint256 y) {
        assembly {
            // Use the highest set bit of x to set each of its lower bits
            x := or(x, shr(1, x))
            x := or(x, shr(2, x))
            x := or(x, shr(4, x))
            x := or(x, shr(8, x))
            x := or(x, shr(16, x))
            x := or(x, shr(32, x))
            x := or(x, shr(64, x))
            x := or(x, shr(128, x))
            // Take only the highest bit of x
            x := xor(x, shr(1, x))
            y := x
        }
    }

    /// @dev Returns the floor of log2(x) and returns 0 on input 0.
    /// @dev This computation makes use of De Bruijn sequences, their usage for computing log2 is referenced here: http://supertech.csail.mit.edu/papers/debruijn.pdf
    function log2Map(uint256 x, bytes calldata map) internal pure returns (uint256 y) {
        x = roundDownPowerOf2(x);
        assembly {
            // This De Bruijn sequence begins with the byte 0, which is important to make shifting work like a rotation on the first byte
            let deBruijnSeq := 0x00818283848586878898a8b8c8d8e8f929395969799a9b9d9e9faaeb6bedeeff
            let key := shr(248, mul(x, deBruijnSeq)) // With the multiplication it works also for 0
            y := shr(248, calldataload(add(map.offset, key))) // Look in the table and take the first byte
        }
    }
}
