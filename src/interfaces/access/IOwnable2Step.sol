// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.0;

import {IOwnable} from "src/interfaces/access/IOwnable.sol";

interface IOwnable2Step is IOwnable {
    /* EVENTS */

    event OwnershipTransferStarted(address indexed previousOwner, address indexed newOwner);

    /* ERRORS */

    /// @dev Thrown when pending ownership is required to accept ownership.
    error PendingOwnershipRequired(address pendingOwner);
}
