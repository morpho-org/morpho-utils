// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.0;

import {IEIP712} from "src/interfaces/IEIP712.sol";

/// @dev The prefix used for EIP-712 signature.
string constant EIP712_MSG_PREFIX = "\x19\x01";

/// @dev The domain typehash used for the EIP-712 signature.
bytes32 constant EIP712_DOMAIN_TYPEHASH =
    keccak256("EIP712Domain(string name,uint256 chainId,address verifyingContract)");

/// @dev The highest valid value for s in an ECDSA signature pair (0 < s < secp256k1n ÷ 2 + 1).
uint256 constant MAX_VALID_ECDSA_S = 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0;

/// @notice EIP712 helpers.
/// @dev Maintains cross-chain replay protection in the event of a fork.
/// @dev Reference: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/cryptography/EIP712.sol
contract EIP712 is IEIP712 {
    /// @dev The reference chainid. Used to check whether the chain forked and offer replay protection.
    uint256 private immutable _CACHED_CHAIN_ID;

    /// @dev The cached domain separator to use if chainid didnt change.
    bytes32 private immutable _CACHED_DOMAIN_SEPARATOR;

    /// @dev The name used for EIP-712 signature.
    bytes32 private immutable _NAMEHASH;

    constructor(string memory name) {
        _NAMEHASH = keccak256(abi.encodePacked(name));

        _CACHED_CHAIN_ID = block.chainid;
        _CACHED_DOMAIN_SEPARATOR = _buildDomainSeparator(EIP712_DOMAIN_TYPEHASH, _NAMEHASH);
    }

    /// @inheritdoc IEIP712
    function DOMAIN_SEPARATOR() public view returns (bytes32) {
        return block.chainid == _CACHED_CHAIN_ID
            ? _CACHED_DOMAIN_SEPARATOR
            : _buildDomainSeparator(EIP712_DOMAIN_TYPEHASH, _NAMEHASH);
    }

    /* INTERNAL */

    function _verify(Signature calldata signature, bytes32 dataHash, uint256 deadline, address signer) internal view {
        if (block.timestamp >= deadline) revert SignatureExpired();
        if (uint256(signature.s) > MAX_VALID_ECDSA_S) revert InvalidValueS();
        // v ∈ {27, 28} (source: https://ethereum.github.io/yellowpaper/paper.pdf #308)
        if (signature.v != 27 && signature.v != 28) revert InvalidValueV();

        bytes32 digest = _hashTypedData(dataHash);
        address recovered = ecrecover(digest, signature.v, signature.r, signature.s);

        if (recovered == address(0) || signer != recovered) revert InvalidSignature();
    }

    /* PRIVATE */

    /// @notice Builds a domain separator using the current chainId and contract address.
    function _buildDomainSeparator(bytes32 typeHash, bytes32 nameHash) private view returns (bytes32) {
        return keccak256(abi.encode(typeHash, nameHash, block.chainid, address(this)));
    }

    /// @notice Creates an EIP-712 typed data hash
    function _hashTypedData(bytes32 dataHash) private view returns (bytes32) {
        return keccak256(abi.encodePacked(EIP712_MSG_PREFIX, DOMAIN_SEPARATOR(), dataHash));
    }
}
