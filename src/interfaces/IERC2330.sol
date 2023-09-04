// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.0;

interface IERC2330 {
    /* FUNCTIONS */

    /// @dev Returns the 32-bytes value stored in this contract, at the given storage slot.
    function extsload(bytes32 slot) external view returns (bytes32 value);

    /// @dev Returns the `nSlots` 32-bytes values stored in this contract, starting from the given start slot.
    function extsload(bytes32 startSlot, uint256 nSlots) external view returns (bytes memory value);
}
