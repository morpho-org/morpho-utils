// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.0;

import {IERC712} from "src/interfaces/IERC712.sol";

import {ERC712_MSG_PREFIX, ERC712_DOMAIN_TYPEHASH, MAX_VALID_ECDSA_S} from "src/ERC712.sol";
import {ERC712Mock} from "test/mocks/ERC712Mock.sol";

import "forge-std/Test.sol";

uint256 constant SECP256K1_CURVE_ORDER = 115792089237316195423570985008687907852837564279074904382605163141518161494337;

contract TestERC712 is Test {
    event NonceUsed(address indexed caller, address indexed signer, uint256 usedNonce);

    string constant NAME = "Test";

    ERC712Mock mock;

    function setUp() public {
        mock = new ERC712Mock(NAME);
    }

    function testDomainSeparator(uint64 chainId) public {
        vm.chainId(chainId);

        assertEq(
            mock.DOMAIN_SEPARATOR(),
            keccak256(abi.encode(ERC712_DOMAIN_TYPEHASH, keccak256(bytes(NAME)), chainId, address(mock)))
        );
    }

    function testVerify(bytes32 dataHash, uint256 deadline, uint256 privateKey) public {
        deadline = bound(deadline, block.timestamp, type(uint256).max);
        privateKey = bound(privateKey, 1, SECP256K1_CURVE_ORDER - 1);

        address signer = vm.addr(privateKey);
        (uint8 v, bytes32 r, bytes32 s) =
            vm.sign(privateKey, keccak256(abi.encodePacked(ERC712_MSG_PREFIX, mock.DOMAIN_SEPARATOR(), dataHash)));

        vm.expectEmit(true, true, true, true, address(mock));
        emit NonceUsed(address(this), signer, 0);

        mock.verify(IERC712.Signature({r: r, s: s, v: v}), dataHash, 0, deadline, signer);

        assertEq(mock.nonce(signer), 1);
    }

    function testVerifySignatureExpired(bytes32 dataHash, bytes32 r, uint256 s, uint256 deadline, address signer)
        public
    {
        s = bound(s, 0, MAX_VALID_ECDSA_S);
        deadline = bound(deadline, 0, block.timestamp - 1);

        vm.expectRevert(IERC712.SignatureExpired.selector);
        mock.verify(IERC712.Signature({r: r, s: bytes32(s), v: 27}), dataHash, 0, deadline, signer);

        vm.expectRevert(IERC712.SignatureExpired.selector);
        mock.verify(IERC712.Signature({r: r, s: bytes32(s), v: 28}), dataHash, 0, deadline, signer);
    }

    function testVerifyInvalidValueS(bytes32 dataHash, bytes32 r, uint256 s, address signer) public {
        s = bound(s, MAX_VALID_ECDSA_S + 1, type(uint256).max);

        vm.expectRevert(IERC712.InvalidValueS.selector);
        mock.verify(IERC712.Signature({r: r, s: bytes32(s), v: 27}), dataHash, 0, block.timestamp, signer);

        vm.expectRevert(IERC712.InvalidValueS.selector);
        mock.verify(IERC712.Signature({r: r, s: bytes32(s), v: 28}), dataHash, 0, block.timestamp, signer);
    }

    function testVerifyInvalidValueV(bytes32 dataHash, bytes32 r, uint256 s, uint8 v, address signer) public {
        s = bound(s, 0, MAX_VALID_ECDSA_S);
        vm.assume(v != 27 && v != 28);

        vm.expectRevert(IERC712.InvalidValueV.selector);
        mock.verify(IERC712.Signature({r: r, s: bytes32(s), v: v}), dataHash, 0, block.timestamp, signer);
    }

    function testVerifyInvalidNonce(bytes32 dataHash, uint256 nonce, uint256 privateKey) public {
        nonce = bound(nonce, 1, type(uint256).max);
        privateKey = bound(privateKey, 1, SECP256K1_CURVE_ORDER - 1);

        (address signer, IERC712.Signature memory signature) = _sign(privateKey, dataHash);

        vm.expectRevert(abi.encodeWithSelector(IERC712.InvalidNonce.selector, 0));
        mock.verify(signature, dataHash, nonce, block.timestamp, signer);
    }

    function testVerifyInvalidSignature(bytes32 dataHash, uint256 s, uint256 deadline, address signer) public {
        deadline = bound(deadline, block.timestamp, type(uint256).max);
        s = bound(s, 0, MAX_VALID_ECDSA_S);

        vm.expectRevert(abi.encodeWithSelector(IERC712.InvalidSignature.selector, address(0)));
        mock.verify(IERC712.Signature({r: 0, s: bytes32(s), v: 27}), dataHash, 0, block.timestamp, signer);

        vm.expectRevert(abi.encodeWithSelector(IERC712.InvalidSignature.selector, address(0)));
        mock.verify(IERC712.Signature({r: 0, s: bytes32(s), v: 28}), dataHash, 0, block.timestamp, signer);
    }

    function _sign(uint256 privateKey, bytes32 dataHash) internal returns (address, IERC712.Signature memory) {
        (uint8 v, bytes32 r, bytes32 s) =
            vm.sign(privateKey, keccak256(abi.encodePacked(ERC712_MSG_PREFIX, mock.DOMAIN_SEPARATOR(), dataHash)));

        return (vm.addr(privateKey), IERC712.Signature({r: r, s: s, v: v}));
    }
}
