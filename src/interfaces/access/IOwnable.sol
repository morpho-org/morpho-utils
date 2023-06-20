// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.0;

interface IOwnable {
    /* EVENTS */

    /// @dev Emitted when owner changes from `previousOwner` to `newOwner`.
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    /* ERRORS */

    /// @dev Thrown when ownership is required to perform an action.
    error OwnershipRequired(address owner);
}
