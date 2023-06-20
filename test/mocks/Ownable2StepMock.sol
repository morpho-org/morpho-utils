// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.0;

import {Ownable2Step, Ownable} from "src/access/Ownable2Step.sol";

contract Ownable2StepMock is Ownable2Step {
    constructor(address initialOwner) Ownable2Step(initialOwner) {}
}
