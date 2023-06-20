// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.0;

import {IOwnable} from "src/interfaces/access/IOwnable.sol";

interface IOwnable2Step is IOwnable {
    /* EVENTS */

    /// @dev Emitted when ownership transfer process is initiated.
    event OwnershipTransferStarted(address indexed previousOwner, address indexed newOwner);

    /* ERRORS */

    /// @dev Thrown when pending ownership is required to accept ownership.
    error PendingOwnershipRequired(address pendingOwner);

    /* FUNCTIONS */

    /// @dev Returns the address of the pending owner.
    function pendingOwner() external view returns (address);

    /// @dev The new owner accepts the ownership transfer.
    function acceptOwnership() external;

    /// @dev Starts the ownership transfer of the contract to a new account.
    ///      Replaces the pending transfer if there is one. Can only be called by the current owner.
    function transferOwnership(address newOwner) external;
}
