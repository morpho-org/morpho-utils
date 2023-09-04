// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.0;

import {ERC20} from "@solmate/tokens/ERC20.sol";

contract ERC20Mock is ERC20 {
    constructor(string memory _name, string memory _symbol) ERC20(_name, _symbol, 18) {}
}
