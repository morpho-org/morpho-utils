// SPDX-License-Identifier: GNU AGPLv3
pragma solidity ^0.8.0;

library DeBruijn {
    function isDeBruijnSequence(uint256 seq) public pure returns (bool) {
        uint256 shift = 2**248;

        bool[] memory seen = new bool[](256);

        for (uint256 i; i < 256; i++) {
            uint256 x = 2**i;
            uint256 frame;
            assembly {
                frame := div(mul(x, seq), shift)
            }
            if (seen[frame]) return false;
            seen[frame] = true;
        }
        return true;
    }

    function precomputeRows(uint256 seq) public pure returns (uint256[] memory) {
        uint256 shift = 2**248;
        uint256[] memory rows = new uint256[](8);

        for (uint256 i; i < 256; i++) {
            uint256 x = 2**i;

            uint256 key;
            assembly {
                key := div(mul(x, seq), shift)
            }
            uint256 rowIndex = key / 32;
            uint256 colIndex = key % 32;
            rows[rowIndex] |= i << (248 - 8 * colIndex); // big-endian memory layout
        }

        return rows;
    }
}
