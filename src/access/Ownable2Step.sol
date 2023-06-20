// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.0;

import {IOwnable2Step} from "src/interfaces/access/IOwnable2Step.sol";

import {Ownable} from "src/access/Ownable.sol";

/// @notice Gas-optimized Ownable2Step helpers.
/// @dev Reference: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable2Step.sol
contract Ownable2Step is IOwnable2Step, Ownable {
    address private _pendingOwner;

    /// @dev Initializes the contract setting the deployer as the initial owner.
    constructor(address initialOwner) Ownable(initialOwner) {}

    /* PUBLIC */

    /// @inheritdoc IOwnable2Step
    function pendingOwner() public view virtual returns (address) {
        return _pendingOwner;
    }

    /// @inheritdoc IOwnable2Step
    function acceptOwnership() public virtual {
        address sender = msg.sender;

        address pending = pendingOwner();
        if (pending != sender) revert PendingOwnershipRequired(pending);

        _transferOwnership(sender);
    }

    /// @inheritdoc IOwnable2Step
    function transferOwnership(address newOwner) public virtual override(IOwnable2Step, Ownable) onlyOwner {
        _pendingOwner = newOwner;

        emit OwnershipTransferStarted(owner(), newOwner);
    }

    /* INTERNAL */

    /// @dev Transfers ownership of the contract to a new account (`newOwner`) and deletes any pending owner. Internal function without access restriction.
    function _transferOwnership(address newOwner) internal virtual override {
        delete _pendingOwner;

        super._transferOwnership(newOwner);
    }
}
