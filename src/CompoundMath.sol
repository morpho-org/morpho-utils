// SPDX-License-Identifier: GNU AGPLv3
pragma solidity ^0.8.0;

library CompoundMath {
    uint256 public constant SCALE = 1e36;
    uint256 public constant WAD = 1e18;

    function mul(uint256 x, uint256 y) internal pure returns (uint256 z) {
        // assembly {
        //     z := div(mul(x, y), WAD)
        // }
        return (x * y) / WAD;
    }

    function div(uint256 x, uint256 y) internal pure returns (uint256 z) {
        assembly {
            z := div(div(mul(x, SCALE), WAD), y)
        }
    }
}
