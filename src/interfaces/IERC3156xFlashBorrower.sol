// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.0;

/// @dev Interface of the ERC3156x FlashBorrower, inspired by https://eips.ethereum.org/EIPS/eip-3156.
///      The FlashLender's `flashLoan` function now returns the FlashBorrower's return data.
interface IERC3156xFlashBorrower {
    /* ERRORS */

    /// @dev Thrown when the caller of the FlashBorrower's callback is not authorized.
    error UnauthorizedLender();

    /// @dev Thrown when the intiiator of the flash loan is not authorized.
    error UnauthorizedInitiator();

    /* FUNCTIONS */

    /// @dev Receive a flash loan.
    /// @param initiator The initiator of the loan.
    /// @param token The loan currency.
    /// @param amount The amount of tokens lent.
    /// @param fee The additional amount of tokens to repay.
    /// @param data Arbitrary data structure, intended to contain user-defined parameters.
    /// @return The keccak256 hash of "IERC3156xFlashBorrower.onFlashLoan" and any additional arbitrary data.
    function onFlashLoan(address initiator, address token, uint256 amount, uint256 fee, bytes calldata data)
        external
        returns (bytes32, bytes memory);
}
