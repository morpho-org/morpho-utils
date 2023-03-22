// SPDX-License-Identifier: GNU AGPLv3
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "openzeppelin-contracts-upgradeable/contracts/utils/cryptography/ECDSAUpgradeable.sol";
import "src/meta-tx/MetaTransactionUpgradeable.sol";

contract TestMetaTransaction is Test, MetaTransactionUpgradeable {
    bytes32 private constant _TYPEHASH =
        keccak256("ForwardRequest(address from,address to,uint256 value,uint256 gas,uint256 nonce,bytes data)");

    function setUp() public initializer {
        __MetaTransaction_init();
    }

    constructor() MetaTransactionUpgradeable(address(this)) {}

    function succeed() public {}

    function revert() public {
        revert();
    }

    function testCallSucceed() public {
        address alice = vm.addr(1);
        ForwardRequest memory req = ForwardRequest({
            from: alice,
            to: address(this),
            value: 0,
            gas: 1_000_000,
            nonce: 0,
            data: abi.encodeWithSignature("succeed()")
        });

        bytes32 hash = ECDSAUpgradeable.toTypedDataHash(
            _domainSeparatorV4(),
            keccak256(abi.encode(_TYPEHASH, req.from, req.to, req.value, req.gas, req.nonce, keccak256(req.data)))
        );
        (uint8 v, bytes32 r, bytes32 s) = vm.sign(1, hash);

        // Adding this. so that memory parameters can be passed as argument.
        this.executeMetaTransaction(req, abi.encodePacked(r, s, v));
    }

    function testCallFailed() public {
        address alice = vm.addr(1);
        ForwardRequest memory req = ForwardRequest({
            from: alice,
            to: address(this),
            value: 0,
            gas: 1_000_000,
            nonce: 0,
            data: abi.encodeWithSignature("revert()")
        });

        bytes32 hash = ECDSAUpgradeable.toTypedDataHash(
            _domainSeparatorV4(),
            keccak256(abi.encode(_TYPEHASH, req.from, req.to, req.value, req.gas, req.nonce, keccak256(req.data)))
        );
        (uint8 v, bytes32 r, bytes32 s) = vm.sign(1, hash);

        vm.expectRevert(abi.encodeWithSelector(MetaTransactionUpgradeable.FunctionCallFailed.selector));
        // Adding this. so that memory parameters can be passed as argument.
        this.executeMetaTransaction(req, abi.encodePacked(r, s, v));
    }

    function testCallFromNotForwarderMustRevert(address caller) public {
        vm.assume(!this.isTrustedForwarder(caller));

        address alice = vm.addr(1);
        ForwardRequest memory req = ForwardRequest({
            from: alice,
            to: address(this),
            value: 0,
            gas: 1_000_000,
            nonce: 0,
            data: abi.encodeWithSignature("revert()")
        });

        bytes32 hash = ECDSAUpgradeable.toTypedDataHash(
            _domainSeparatorV4(),
            keccak256(abi.encode(_TYPEHASH, req.from, req.to, req.value, req.gas, req.nonce, keccak256(req.data)))
        );
        (uint8 v, bytes32 r, bytes32 s) = vm.sign(1, hash);

        vm.expectRevert();
        // Adding this. so that memory parameters can be passed as argument.
        this.executeMetaTransaction(req, abi.encodePacked(r, s, v));
    }
}
