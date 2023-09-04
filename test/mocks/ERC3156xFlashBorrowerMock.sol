// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.0;

import {IERC3156xFlashLender} from "src/interfaces/IERC3156xFlashLender.sol";

import {ERC3156xFlashBorrower, FLASH_BORROWER_SUCCESS_HASH} from "src/ERC3156xFlashBorrower.sol";

contract ERC3156xFlashBorrowerMock is ERC3156xFlashBorrower {
    constructor(IERC3156xFlashLender lender) ERC3156xFlashBorrower(lender) {}

    function flashLoan(address token, uint256 amount, bytes calldata data) public returns (bytes memory) {
        return _flashLoan(token, amount, data);
    }
}
