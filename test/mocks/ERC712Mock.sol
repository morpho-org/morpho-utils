// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.0;

import {ERC712} from "src/ERC712.sol";

contract ERC712Mock is ERC712 {
    constructor(string memory name) ERC712(name) {}

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
