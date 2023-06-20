// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.0;

import {IOwnable2Step} from "src/interfaces/access/IOwnable2Step.sol";

import {Ownable} from "src/access/Ownable.sol";

/// @notice Gas-optimized Ownable2Step helpers.
/// @dev Reference: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable2Step.sol
abstract contract Ownable2Step is IOwnable2Step, Ownable {
    address private _pendingOwner;

    /* PUBLIC */

    /**
     * @dev Returns the address of the pending owner.
     */
    function pendingOwner() public view virtual returns (address) {
        return _pendingOwner;
    }

    /**
     * @dev The new owner accepts the ownership transfer.
     */
    function acceptOwnership() public virtual {
        address sender = msg.sender;

        address pending = pendingOwner();
        if (pending != sender) revert PendingOwnershipRequired(pending);

        _transferOwnership(sender);
    }

    /**
     * @dev Starts the ownership transfer of the contract to a new account. Replaces the pending transfer if there is one.
     * Can only be called by the current owner.
     */
    function transferOwnership(address newOwner) public virtual override onlyOwner {
        _pendingOwner = newOwner;

        emit OwnershipTransferStarted(owner(), newOwner);
    }

    /* INTERNAL */

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`) and deletes any pending owner.
     * Internal function without access restriction.
     */
    function _transferOwnership(address newOwner) internal virtual override {
        delete _pendingOwner;

        super._transferOwnership(newOwner);
    }
}
