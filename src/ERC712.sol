// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.0;

import {IERC712} from "src/interfaces/IERC712.sol";

/// @dev The prefix used for EIP-712 signature.
string constant ERC712_MSG_PREFIX = "\x19\x01";

/// @dev The domain typehash used for the EIP-712 signature.
bytes32 constant ERC712_DOMAIN_TYPEHASH =
    keccak256("ERC712Domain(string name,uint256 chainId,address verifyingContract)");

/// @dev The highest valid value for s in an ECDSA signature pair (0 < s < secp256k1n ÷ 2 + 1).
uint256 constant MAX_VALID_ECDSA_S = 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0;

/// @notice ERC712 helpers.
/// @dev Maintains cross-chain replay protection in the event of a fork.
/// @dev Reference: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/cryptography/ERC712.sol
contract ERC712 is IERC712 {
    /// @dev The reference chainid. Used to check whether the chain forked and offer replay protection.
    uint256 private immutable _CACHED_CHAIN_ID;

    /// @dev The cached domain separator to use if chainid didnt change.
    bytes32 private immutable _CACHED_DOMAIN_SEPARATOR;

    /// @dev The name used for EIP-712 signature.
    bytes32 private immutable _NAMEHASH;

    /// @dev The nonce used inside by signers to offer signature replay protection.
    mapping(address => uint256) private _nonces;

    constructor(string memory name) {
        _NAMEHASH = keccak256(bytes(name));

        _CACHED_CHAIN_ID = block.chainid;
        _CACHED_DOMAIN_SEPARATOR = _buildDomainSeparator();
    }

    /* PUBLIC */

    /// @inheritdoc IERC712
    function DOMAIN_SEPARATOR() public view virtual returns (bytes32) {
        return block.chainid == _CACHED_CHAIN_ID ? _CACHED_DOMAIN_SEPARATOR : _buildDomainSeparator();
    }

    /// @inheritdoc IERC712
    function nonce(address user) public view virtual returns (uint256) {
        return _nonces[user];
    }

    /* INTERNAL */

    /// @dev Verifies a signature components against the provided data hash, nonce, deadline and signer.
    /// @param signature The signature to verify.
    /// @param dataHash The ERC712 message hash the signature should correspond to.
    /// @param signedNonce The nonce used along with the provided signature. Must not be an end-user input and must be proven to be signed by the signer.
    /// @param deadline The signature's maximum valid timestamp. Must not be an end-user input and must be proven to be signed by the signer.
    /// @param signer The expected signature's signer.
    function _verify(
        Signature calldata signature,
        bytes32 dataHash,
        uint256 signedNonce,
        uint256 deadline,
        address signer
    ) internal virtual {
        if (block.timestamp > deadline) revert SignatureExpired();
        if (uint256(signature.s) > MAX_VALID_ECDSA_S) revert InvalidValueS();
        // v ∈ {27, 28} (source: https://ethereum.github.io/yellowpaper/paper.pdf #308)
        if (signature.v != 27 && signature.v != 28) revert InvalidValueV();

        uint256 usedNonce = _useNonce(signer);
        if (signedNonce != usedNonce) revert InvalidNonce(usedNonce);

        bytes32 digest = _hashTypedData(dataHash);
        address recovered = ecrecover(digest, signature.v, signature.r, signature.s);

        if (recovered == address(0) || signer != recovered) revert InvalidSignature(recovered);
    }

    /// @dev Increments and returns the nonce that should have been used in the corresponding signature.
    function _useNonce(address signer) internal virtual returns (uint256 usedNonce) {
        usedNonce = _nonces[signer]++;

        emit NonceUsed(msg.sender, signer, usedNonce);
    }

    /* PRIVATE */

    /// @notice Builds a domain separator using the current chainId and contract address.
    function _buildDomainSeparator() private view returns (bytes32) {
        return keccak256(abi.encode(ERC712_DOMAIN_TYPEHASH, _NAMEHASH, block.chainid, address(this)));
    }

    /// @notice Creates an EIP-712 typed data hash
    function _hashTypedData(bytes32 dataHash) private view returns (bytes32) {
        return keccak256(abi.encodePacked(ERC712_MSG_PREFIX, DOMAIN_SEPARATOR(), dataHash));
    }
}
