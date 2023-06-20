// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.0;

import {Ownable} from "src/access/Ownable.sol";

contract OwnableMock is Ownable {
    constructor(address initialOwner) Ownable(initialOwner) {}
}
