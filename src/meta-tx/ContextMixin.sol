// SPDX-License-Identifier: GNU AGPLv3
pragma solidity ^0.8.0;

abstract contract ContextMixin {
    function _msgSender() internal view returns (address sender) {
        if (msg.sender == address(this)) {
            assembly {
                sender := shr(96, calldataload(sub(calldatasize(), 20)))
            }
        } else sender = msg.sender;
    }
}
