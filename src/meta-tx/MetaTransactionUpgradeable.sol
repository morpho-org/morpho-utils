// SPDX-License-Identifier: GNU AGPLv3
pragma solidity ^0.8.0;

import {MinimalForwarderUpgradeable} from "openzeppelin-contracts-upgradeable/contracts/metatx/MinimalForwarderUpgradeable.sol";
import {ContextMixin} from "./ContextMixin.sol";

contract MetaTransactionUpgradeable is ContextMixin, MinimalForwarderUpgradeable {
    error FunctionCallFailed();
    error OnlySelf();

    function executeMetaTransaction(ForwardRequest calldata req, bytes calldata signature)
        public
        payable
        returns (bytes memory)
    {
        if (req.to != address(this)) revert OnlySelf();
        (bool success, bytes memory returnData) = execute(req, signature);
        if (!success) revert FunctionCallFailed();

        return returnData;
    }
}
