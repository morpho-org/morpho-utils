// SPDX-License-Identifier: GNU AGPLv3
pragma solidity ^0.8.0;

/// @title WadRayMath.
/// @author Morpho Labs.
/// @custom:contact security@morpho.xyz
/// @notice TODO
library SafeCast {

	uint256 internal constant MAX_UINT96 = 2**96 - 1; // Not possible to use type(uint96).max in yul

	function toUint96(uint256 value) internal pure returns(uint96 casted) {
		assembly {
			if iszero(lt(value, MAX_UINT96)) {
				revert(0, 0)
			}

			casted := value
		}
	}
}