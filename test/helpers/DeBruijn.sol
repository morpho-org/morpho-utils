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
}
