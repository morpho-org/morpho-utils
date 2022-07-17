// SPDX-License-Identifier: GNU AGPLv3
pragma solidity ^0.8.0;

library Math {
    function min(uint256 x, uint256 y) internal pure returns (uint256 z) {
        assembly {
            switch lt(x, y)
            case 0 {
                z := y
            }
            default {
                z := x
            }
        }
    }

    function max(uint256 x, uint256 y) internal pure returns (uint256 z) {
        assembly {
            switch gt(x, y)
            case 0 {
                z := y
            }
            default {
                z := x
            }
        }
    }
}
