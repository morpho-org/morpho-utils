// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.0;

import {IERC3156xFlashLender} from "src/interfaces/IERC3156xFlashLender.sol";
import {IERC3156xFlashBorrower} from "src/interfaces/IERC3156xFlashBorrower.sol";

import {SafeTransferLib, ERC20} from "solmate/utils/SafeTransferLib.sol";

/// @dev The expected success hash returned by the FlashBorrower.
bytes32 constant FLASH_BORROWER_SUCCESS_HASH = keccak256("ERC3156xFlashBorrower.onFlashLoan");

contract ERC3156xFlashLender is IERC3156xFlashLender {
    using SafeTransferLib for ERC20;

    /* PUBLIC */

    /// @inheritdoc IERC3156xFlashLender
    function maxFlashLoan(address token) public view virtual returns (uint256) {
        return ERC20(token).balanceOf(address(this));
    }

    /// @inheritdoc IERC3156xFlashLender
    function flashFee(address, uint256) public pure virtual returns (uint256) {
        return 0;
    }

    /// @inheritdoc IERC3156xFlashLender
    function flashLoan(IERC3156FlashBorrower receiver, address token, uint256 amount, bytes calldata data)
        public
        virtual
        returns (bytes memory returnData)
    {
        uint256 max = maxFlashLoan(token);
        if (amount > max) revert FlashLoanTooLarge(max);

        ERC20(token).safeTransfer(address(receiver), amount);

        uint256 fee = flashFee(token, amount);

        bytes32 successHash;
        (successHash, returnData) = receiver.onFlashLoan(msg.sender, token, amount, fee, data);
        if (successHash != FLASH_BORROWER_SUCCESS_HASH) revert InvalidFlashData(flashData);

        _accrueFee(token, amount, fee);

        ERC20(token).safeTransferFrom(address(receiver), address(this), amount + fee);
    }

    /* INTERNAL */

    function _accrueFee(address token, uint256 amount, uint256 fee) internal virtual {}
}
