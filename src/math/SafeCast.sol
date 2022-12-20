// SPDX-License-Identifier: GNU AGPLv3
pragma solidity ^0.8.0;

/// @title WadRayMath.
/// @author Morpho Labs.
/// @custom:contact security@morpho.xyz
/// @notice TODO
library SafeCast {
    function toUint128(uint256 value) internal pure returns (uint128 casted) {
        assembly {
            if iszero(lt(value, shl(128, 1))) {
				revert(0, 0)
            }

			casted := value
        }
    }

    function toUint96(uint256 value) internal pure returns (uint96 casted) {
        assembly {
            if iszero(lt(value, shl(96, 1))) {
            	revert(0, 0)
            }
			
			casted := value
        }
    }

    function toUint64(uint256 value) internal pure returns (uint64 casted) {
        assembly {
            if iszero(lt(value, shl(64, 1))) {
            	revert(0, 0)
            }

			casted := value

        }
    }

    function toUint32(uint256 value) internal pure returns (uint32 casted) {
        assembly {
            if iszero(lt(value, shl(32, 1))) {
            	revert(0, 0)
            }

			casted := value

        }
    }

    function toUint16(uint256 value) internal pure returns (uint16 casted) {
        assembly {
            if iszero(lt(value, shl(16, 1))) {
            	revert(0, 0)
            }

			casted := value

        }
    }

    function toUint8(uint256 value) internal pure returns (uint8 casted) {
        assembly {
            if iszero(lt(value, shl(8, 1))) {
            	revert(0, 0)
            }

			casted := value
        }
    }

	function toInt128(int256 value) internal pure returns (int128 casted) {
		assembly {
            if iszero(lt(value, shl(127, 1))) {
            	revert(0, 0)
            }

			casted := value
        }
	}
}
