// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.0;

interface IERC712 {
    /* STRUCTS */

    struct Signature {
        uint8 v;
        bytes32 r;
        bytes32 s;
    }

    /* EVENTS */

    /// @dev Emitted when a signer's nonce is incremented.
    event NonceUsed(address indexed caller, address indexed signer, uint256 usedNonce);

    /* ERRORS */

    /// @notice Thrown when the s part of the ECDSA signature is invalid.
    error InvalidValueS();

    /// @notice Thrown when the v part of the ECDSA signature is invalid.
    error InvalidValueV();

    /// @notice Thrown when the signer of the ECDSA signature is invalid.
    error InvalidSignature(address recovered);

    /// @notice Thrown when the nonce is invalid.
    error InvalidNonce(uint256 nonce);

    /// @notice Thrown when the signature deadline is expired.
    error SignatureExpired();

    /* FUNCTIONS */

    /// @notice Returns the domain separator for the current chain.
    /// @dev Uses cached version if chainid and address are unchanged from construction.
    function DOMAIN_SEPARATOR() external view returns (bytes32);

    /// @notice Returns the given signer's nonce to be used in the next ERC712 signature.
    function nonce(address signer) external view returns (uint256);
}
