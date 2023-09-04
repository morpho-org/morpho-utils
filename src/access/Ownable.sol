// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.0;

import {IOwnable} from "../interfaces/access/IOwnable.sol";

/// @notice Gas-optimized Ownable helpers.
/// @dev Reference: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol
contract Ownable is IOwnable {
    address private _owner;

    /// @dev Initializes the contract setting the deployer as the initial owner.
    constructor(address initialOwner) {
        _transferOwnership(initialOwner);
    }

    /// @dev Throws if called by any account other than the owner.
    modifier onlyOwner() {
        _checkOwner();

        _;
    }

    /* PUBLIC */

    /// @inheritdoc IOwnable
    function owner() public view virtual returns (address) {
        return _owner;
    }

    /// @inheritdoc IOwnable
    function transferOwnership(address newOwner) public virtual onlyOwner {
        _transferOwnership(newOwner);
    }

    /* INTERNAL */

    /// @dev Throws if the sender is not the owner.
    function _checkOwner() internal view virtual {
        address currentOwner = owner();

        if (currentOwner != msg.sender) revert OwnershipRequired(currentOwner);
    }

    /// @dev Transfers ownership of the contract to a new account (`newOwner`). Internal function without access restriction.
    function _transferOwnership(address newOwner) internal virtual {
        address oldOwner = owner();

        _owner = newOwner;

        emit OwnershipTransferred(oldOwner, newOwner);
    }
}
