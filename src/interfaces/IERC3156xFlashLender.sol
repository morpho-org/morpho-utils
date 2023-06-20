// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts v4.4.1 (interfaces/IERC3156FlashLender.sol)

pragma solidity ^0.8.0;

import {IERC3156xFlashBorrower} from "./IERC3156xFlashBorrower.sol";

/// @dev Interface of the ERC3156x FlashLender, inspired by https://eips.ethereum.org/EIPS/eip-3156.
///      The FlashLender's `flashLoan` function now returns the FlashBorrower's return data.
interface IERC3156xFlashLender {
    /* EVENTS */

    /// @dev Emitted when a flash loan is initiated.
    event FlashLoan(address indexed initiator, address indexed receiver, address indexed token, uint256 amount);

    /* ERRORS */

    /// @dev Thrown when the requested flash loan amount is larger than the maximum flash loan allowed.
    error FlashLoanTooLarge(uint256 maxFlashLoan);

    /// @dev Thrown when the FlashBorrower's success hash is invalid.
    error InvalidSuccessHash(bytes32 successHash);

    /* FUNCTIONS */

    /// @dev The amount of currency available to be lended.
    /// @param token The loan currency.
    /// @return The amount of `token` that can be borrowed.
    function maxFlashLoan(address token) external view returns (uint256);

    /// @dev The fee to be charged for a given loan.
    /// @param token The loan currency.
    /// @param amount The amount of tokens lent.
    /// @return The amount of `token` to be charged for the loan, on top of the returned principal.
    function flashFee(address token, uint256 amount) external view returns (uint256);

    /// @dev Initiate a flash loan.
    /// @param receiver The receiver of the tokens in the loan, and the receiver of the callback.
    /// @param token The loan currency.
    /// @param amount The amount of tokens lent.
    /// @param data Arbitrary data structure, intended to contain user-defined parameters.
    function flashLoan(IERC3156xFlashBorrower receiver, address token, uint256 amount, bytes calldata data)
        external
        returns (bytes memory);
}
