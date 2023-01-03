// SPDX-License-Identifier: GNU AGPLv3
pragma solidity ^0.8.0;

library DeBruijn {
    function isDeBruijnSequence(uint256 seq) internal pure returns (bool) {
        bool[] memory seen = new bool[](256);

        for (uint256 i; i < 256; i++) {
            uint256 x = 2**i;
            uint256 key;
            // Inline assembly to avoid overflow
            assembly {
                key := shr(248, mul(x, seq))
            }
            if (seen[key]) return false;
            seen[key] = true;
        }
        return true;
    }

    function precomputeRows(uint256 seq) internal pure returns (uint256[] memory) {
        uint256[] memory rows = new uint256[](8);

        for (uint256 i; i < 256; i++) {
            uint256 x = 2**i;

            uint256 key;
            // Inline assembly to avoid overflow
            assembly {
                key := shr(248, mul(x, seq))
            }
            uint256 rowIndex = key / 32;
            uint256 colIndex = key % 32;
            rows[rowIndex] |= i << (248 - 8 * colIndex); // big-endian memory layout
        }

        return rows;
    }
}
