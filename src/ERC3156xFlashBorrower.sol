// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.0;

import {IERC3156xFlashLender} from "./interfaces/IERC3156xFlashLender.sol";
import {IERC3156xFlashBorrower} from "./interfaces/IERC3156xFlashBorrower.sol";

import {SafeTransferLib, ERC20} from "@solmate/utils/SafeTransferLib.sol";

import {FLASH_BORROWER_SUCCESS_HASH} from "./ERC3156xFlashLender.sol";

contract ERC3156xFlashBorrower is IERC3156xFlashBorrower {
    using SafeTransferLib for ERC20;

    IERC3156xFlashLender private immutable _LENDER;

    constructor(IERC3156xFlashLender lender) {
        _LENDER = lender;
    }

    /* PUBLIC */

    /// @inheritdoc IERC3156xFlashBorrower
    function onFlashLoan(address initiator, address token, uint256 amount, uint256 fee, bytes calldata data)
        public
        virtual
        returns (bytes32 successHash, bytes memory returnData)
    {
        _checkFlashLoan(initiator);

        (successHash, returnData) = _onFlashLoan(initiator, token, amount, fee, data);

        ERC20(token).safeApprove(address(_LENDER), amount + fee);
    }

    /* INTERNAL */

    function _checkFlashLoan(address initiator) internal view virtual {
        if (msg.sender != address(_LENDER)) revert UnauthorizedLender();
        if (initiator != address(this)) revert UnauthorizedInitiator();
    }

    function _flashLoan(address token, uint256 amount, bytes calldata data) internal virtual returns (bytes memory) {
        return _LENDER.flashLoan(this, token, amount, data);
    }

    function _onFlashLoan(address, address, uint256, uint256, bytes calldata)
        public
        virtual
        returns (bytes32, bytes memory)
    {
        return (FLASH_BORROWER_SUCCESS_HASH, bytes(""));
    }
}
