// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.0;

import {IEIP712} from "src/interfaces/IEIP712.sol";

import {EIP712_DOMAIN_TYPEHASH, MAX_VALID_ECDSA_S} from "src/EIP712.sol";
import {EIP712Mock} from "test/mocks/EIP712Mock.sol";

import "forge-std/Test.sol";

contract TestEIP712 is Test {
    string constant NAME = "Test";

    EIP712Mock mock;

    function setUp() public {
        mock = new EIP712Mock(NAME);
    }

    function testDomainSeparator() public {
        assertEq(
            IEIP712(mock).DOMAIN_SEPARATOR(),
            keccak256(abi.encode(EIP712_DOMAIN_TYPEHASH, keccak256(bytes(NAME)), block.chainid, address(this)))
        );
    }

    function testVerify(bytes32 dataHash, uint256 deadline, uint256 privateKey) public {
        privateKey = bound(privateKey, 1, type(uint256).max);
        deadline = bound(deadline, block.timestamp, type(uint256).max);

        (uint8 v, bytes32 r, bytes32 s) = vm.sign(privateKey, dataHash);

        mock.verify(IEIP712.Signature({r: r, s: s, v: v}), dataHash, 0, deadline, vm.addr(privateKey));
    }

    function testVerifySignatureExpired(bytes32 dataHash, bytes32 r, uint256 s, uint256 deadline, address signer)
        public
    {
        s = bound(s, 0, MAX_VALID_ECDSA_S);
        deadline = bound(deadline, 0, block.timestamp - 1);

        vm.expectRevert(IEIP712.SignatureExpired.selector);
        mock.verify(IEIP712.Signature({r: r, s: bytes32(s), v: 27}), dataHash, 0, deadline, signer);

        vm.expectRevert(IEIP712.SignatureExpired.selector);
        mock.verify(IEIP712.Signature({r: r, s: bytes32(s), v: 28}), dataHash, 0, deadline, signer);
    }

    function testVerifyInvalidValueS(bytes32 dataHash, bytes32 r, uint256 s, address signer) public {
        s = bound(s, MAX_VALID_ECDSA_S + 1, type(uint256).max);

        vm.expectRevert(IEIP712.InvalidValueS.selector);
        mock.verify(IEIP712.Signature({r: r, s: bytes32(s), v: 27}), dataHash, 0, block.timestamp, signer);

        vm.expectRevert(IEIP712.InvalidValueS.selector);
        mock.verify(IEIP712.Signature({r: r, s: bytes32(s), v: 28}), dataHash, 0, block.timestamp, signer);
    }

    function testVerifyInvalidValueV(bytes32 dataHash, bytes32 r, uint256 s, uint8 v, address signer) public {
        s = bound(s, 0, MAX_VALID_ECDSA_S);
        vm.assume(v != 27 && v != 28);

        vm.expectRevert(IEIP712.InvalidValueV.selector);
        mock.verify(IEIP712.Signature({r: r, s: bytes32(s), v: v}), dataHash, 0, block.timestamp, signer);
    }

    function testVerifyInvalidNonce(bytes32 dataHash, bytes32 r, uint256 s, uint256 nonce, address signer) public {
        s = bound(s, 0, MAX_VALID_ECDSA_S);
        nonce = bound(nonce, 1, type(uint256).max);

        vm.expectRevert(abi.encodeWithSelector(IEIP712.InvalidNonce.selector, 0));
        mock.verify(IEIP712.Signature({r: r, s: bytes32(s), v: 27}), dataHash, nonce, block.timestamp, signer);

        vm.expectRevert(abi.encodeWithSelector(IEIP712.InvalidNonce.selector, 0));
        mock.verify(IEIP712.Signature({r: r, s: bytes32(s), v: 28}), dataHash, nonce, block.timestamp, signer);
    }

    function testVerifyInvalidSignature(bytes32 dataHash, uint256 s, uint256 deadline, address signer) public {
        deadline = bound(deadline, block.timestamp, type(uint256).max);
        s = bound(s, 0, MAX_VALID_ECDSA_S);

        vm.expectRevert(abi.encodeWithSelector(IEIP712.InvalidSignature.selector, address(0)));
        mock.verify(IEIP712.Signature({r: 0, s: bytes32(s), v: 27}), dataHash, 0, block.timestamp, signer);

        vm.expectRevert(abi.encodeWithSelector(IEIP712.InvalidSignature.selector, address(0)));
        mock.verify(IEIP712.Signature({r: 0, s: bytes32(s), v: 28}), dataHash, 0, block.timestamp, signer);
    }
}
