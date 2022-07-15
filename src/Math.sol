// SPDX-License-Identifier: GNU AGPLv3
pragma solidity ^0.8.0;

library Math {
    function min(uint256 x, uint256 y) internal pure returns (uint256 z) {
        assembly {
            switch iszero(lt(x, y))
            case 1 {
                z := y
            }
            default {
                z := x
            }
        }
    }

    function max(uint256 x, uint256 y) internal pure returns (uint256 z) {
        assembly {
            switch iszero(gt(x, y))
            case 1 {
                z := y
            }
            default {
                z := x
            }
        }
    }
}
