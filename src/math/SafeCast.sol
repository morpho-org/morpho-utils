// SPDX-License-Identifier: GNU AGPLv3
pragma solidity ^0.8.0;

/// @title WadRayMath.
/// @author Morpho Labs.
/// @custom:contact security@morpho.xyz
/// @notice TODO
library SafeCast {
    function toUint128(uint256 value) internal pure returns (uint128) {
        assembly {
            if lt(value, shl(128, 1)) {
                mstore(0x00, value)
                return(0x00, 0x20)
            }

            revert(0, 0)
        }
    }

    function toUint96(uint256 value) internal pure returns (uint96) {
        assembly {
            if lt(value, shl(96, 1)) {
                mstore(0x00, value)
                return(0x00, 0x20)
            }

            revert(0, 0)
        }
    }

    function toUint64(uint256 value) internal pure returns (uint64) {
        assembly {
            if lt(value, shl(64, 1)) {
                mstore(0x00, value)
                return(0x00, 0x20)
            }

            revert(0, 0)
        }
    }

    function toUint32(uint256 value) internal pure returns (uint32) {
        assembly {
            if lt(value, shl(32, 1)) {
                mstore(0x00, value)
                return(0x00, 0x20)
            }

            revert(0, 0)
        }
    }

    function toUint16(uint256 value) internal pure returns (uint16) {
        assembly {
            if lt(value, shl(16, 1)) {
                mstore(0x00, value)
                return(0x00, 0x20)
            }

            revert(0, 0)
        }
    }

    function toUint8(uint256 value) internal pure returns (uint8) {
        assembly {
            if lt(value, shl(8, 1)) {
                mstore(0x00, value)
                return(0x00, 0x20)
            }

            revert(0, 0)
        }
    }
}
