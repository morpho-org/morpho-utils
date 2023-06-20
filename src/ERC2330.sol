// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.0;

import {IERC2330} from "src/interfaces/IERC2330.sol";

/// @dev Gas-optimized extsload getters to allow anyone to read storage from this contract.
///      Enables the benefit of https://eips.ethereum.org/EIPS/eip-2330 without requiring changes to the execution layer.
contract ERC2330 is IERC2330 {
    /* EXTERNAL */

    /// @inheritdoc IERC2330
    function extsload(bytes32 slot) external view returns (bytes32 value) {
        /// @solidity memory-safe-assembly
        assembly {
            value := sload(slot)
        }
    }

    /// @inheritdoc IERC2330
    function extsload(bytes32 startSlot, uint256 nSlots) external view returns (bytes memory value) {
        value = new bytes(32 * nSlots);

        /// @solidity memory-safe-assembly
        assembly {
            for { let i := 0 } lt(i, nSlots) { i := add(i, 1) } {
                mstore(add(value, mul(add(i, 1), 32)), sload(add(startSlot, i)))
            }
        }
    }
}
