// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.0;

import {ERC2330} from "src/ERC2330.sol";

contract ERC2330Mock is ERC2330 {
    uint128 private _var11;
    uint128 private _var12;
    uint256 private _var2;

    constructor() {
        _var11 = 1;
        _var12 = 1;
        _var2 = 2;
    }
}
