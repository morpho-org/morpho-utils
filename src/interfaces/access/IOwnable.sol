// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.0;

interface IOwnable {
    /* EVENTS */

    /// @dev Emitted when owner changes from `previousOwner` to `newOwner`.
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    /* ERRORS */

    /// @dev Thrown when ownership is required to perform an action.
    error OwnershipRequired(address owner);

    /* FUNCTIONS */

    /// @dev Returns the address of the current owner.
    function owner() external view returns (address);

    /// @notice Transfers ownership of the contract to a new account (`newOwner`). Can only be called by the current owner.
    /// @dev Ownership can be renounced by transferring ownership to `address(0)`.
    ///      Renouncing ownership will leave the contract without an owner, thereby removing any functionality that is only available to the owner.
    function transferOwnership(address newOwner) external;
}
