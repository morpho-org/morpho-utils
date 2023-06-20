// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.0;

import {EIP712} from "src/EIP712.sol";

contract EIP712Mock is EIP712 {
    constructor(string memory name) EIP712(name) {}

    function verify(
        Signature calldata signature,
        bytes32 dataHash,
        uint256 signedNonce,
        uint256 deadline,
        address signer
    ) external {
        _verify(signature, dataHash, signedNonce, deadline, signer);
    }
}
