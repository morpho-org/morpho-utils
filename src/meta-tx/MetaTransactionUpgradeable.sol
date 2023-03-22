// SPDX-License-Identifier: GNU AGPLv3
pragma solidity ^0.8.0;

import {ERC2771ContextUpgradeable} from "openzeppelin-contracts-upgradeable/contracts/metatx/ERC2771ContextUpgradeable.sol";
import {MinimalForwarderUpgradeable} from "openzeppelin-contracts-upgradeable/contracts/metatx/MinimalForwarderUpgradeable.sol";

contract MetaTransactionUpgradeable is MinimalForwarderUpgradeable, ERC2771ContextUpgradeable {
    /* ERRORS */

    /// @notice Thrown when the `execute` function reverts.
    error FunctionCallFailed();

    /* CONSTRUCTOR */

    constructor(address trustedForwarder) ERC2771ContextUpgradeable(trustedForwarder) {}

    /* INITIALIZER */

    function __MetaTransaction_init() internal onlyInitializing {
        __MinimalForwarder_init();
    }

    function __MetaTransaction_init_unchained() internal onlyInitializing {}

    /* PUBLIC */

    function executeMetaTransaction(ForwardRequest calldata req, bytes calldata signature)
        public
        payable
        returns (bytes memory)
    {
        (bool success, bytes memory returnData) = execute(req, signature);
        if (!success) revert FunctionCallFailed();

        return returnData;
    }

    /// @dev This empty reserved space is put in place to allow future versions to add new
    ///      variables without shifting down storage in the inheritance chain.
    uint256[50] private __gap;
}
