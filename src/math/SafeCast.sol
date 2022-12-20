// SPDX-License-Identifier: GNU AGPLv3
pragma solidity ^0.8.0;

/// @title WadRayMath.
/// @author Morpho Labs.
/// @custom:contact security@morpho.xyz
/// @notice TODO
library SafeCast {
    uint256 internal constant MAX_UINT128 = 2**128 - 1; // Not possible to use type(uint128).max in yul
    uint256 internal constant MAX_UINT96 = 2**96 - 1; // Not possible to use type(uint96).max in yul
    uint256 internal constant MAX_UINT64 = 2**64 - 1; // Not possible to use type(uint64).max in yul
    uint256 internal constant MAX_UINT32 = 2**32 - 1; // Not possible to use type(uint32).max in yul
    uint256 internal constant MAX_UINT16 = 2**16 - 1; // Not possible to use type(uint16).max in yul
    uint256 internal constant MAX_UINT8 = 2**8 - 1; // Not possible to use type(uint8).max in yul

    function toUint128(uint256 value) internal pure returns (uint128 casted) {
        assembly {
            if gt(value, MAX_UINT128) {
                revert(0, 0)
            }

            casted := value
        }
    }

    function toUint96(uint256 value) internal pure returns (uint96 casted) {
        assembly {
            if gt(value, MAX_UINT96) {
                revert(0, 0)
            }

            casted := value
        }
    }

    function toUint64(uint256 value) internal pure returns (uint64 casted) {
        assembly {
            if gt(value, MAX_UINT64) {
                revert(0, 0)
            }

            casted := value
        }
    }

    function toUint32(uint256 value) internal pure returns (uint32 casted) {
        assembly {
            if gt(value, MAX_UINT32) {
                revert(0, 0)
            }

            casted := value
        }
    }

    function toUint16(uint256 value) internal pure returns (uint16 casted) {
        assembly {
            if gt(value, MAX_UINT16) {
                revert(0, 0)
            }

            casted := value
        }
    }

    function toUint8(uint256 value) internal pure returns (uint8 casted) {
        assembly {
            if lt(MAX_UINT8, value) {
                revert(0, 0)
            }

            casted := value
        }
    }

    function toInt128(int256 value) internal pure returns (int128 downcasted) {
        assembly {
            downcasted := signextend(15, value)

            if iszero(eq(downcasted, value)) {
                revert(0, 0)
            }
        }
    }
}
