// SPDX-License-Identifier: AGPL-3.0-only
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
        // Division by 0 if
        //    y = 0
        assembly {
            if iszero(y) { revert(0, 0) }

            z := add(gt(mod(x, y), 0), div(x, y))
        }
    }

    /// @dev Returns the floor of log2(x) and returns 0 when x = 0.
    /// @dev Uses a method by dichotomy to find the highest bit set of x.
    function log2(uint256 x) internal pure returns (uint256 y) {
        assembly {
            // Finds if x has a 1 on the first 128 bits. If not then do nothing.
            // If that is the case then the result is more than 128.
            let z := shl(7, gt(x, 0xffffffffffffffffffffffffffffffff))
            y := z
            x := shr(z, x)

            // Using y as an accumulator, we can now focus on the last 128 bits of x.
            // Repeat this process to divide the number of bits to handle by 2 every time.
            z := shl(6, gt(x, 0xffffffffffffffff))
            y := add(y, z)
            x := shr(z, x)

            z := shl(5, gt(x, 0xffffffff))
            y := add(y, z)
            x := shr(z, x)

            x := or(x, shr(1, x))
            x := or(x, shr(2, x))
            x := or(x, shr(4, x))
            x := or(x, shr(8, x))
            x := or(x, shr(16, x))
            let deBruijnSeq := 0x07c4acdd
            let offset := shr(24, and(0xf8000000, mul(deBruijnSeq, x)))
            y := add(y, shr(248, shl(offset, 0x0009010a0d15021d0b0e10121619031e080c141c0f111807131b17061a05041f)))
        }
    }
}
