// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.0;

import {IOwnable} from "src/interfaces/access/IOwnable.sol";
import {IOwnable2Step} from "src/interfaces/access/IOwnable2Step.sol";

import {Ownable2StepMock} from "test/mocks/Ownable2StepMock.sol";

import "forge-std/Test.sol";

contract TestOwnable2Step is Test {
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
    event OwnershipTransferStarted(address indexed previousOwner, address indexed newOwner);

    IOwnable2Step mock;

    function setUp() public {
        mock = new Ownable2StepMock(address(this));
    }

    function testConstructorOwner(address initialOwner) public {
        mock = new Ownable2StepMock(initialOwner);

        assertEq(mock.owner(), initialOwner);
    }

    function testTransferOwnership(address newOwner) public {
        vm.expectEmit(true, true, true, true, address(mock));
        emit OwnershipTransferStarted(address(this), newOwner);

        mock.transferOwnership(newOwner);

        assertEq(mock.owner(), address(this), "owner != address(this)");
        assertEq(mock.pendingOwner(), newOwner, "pendingOwner != newOwner");

        vm.prank(newOwner);
        mock.acceptOwnership();

        assertEq(mock.owner(), newOwner, "owner != newOwner");
        assertEq(mock.pendingOwner(), address(0), "pendingOwner != address(0)");
    }

    function testTransferOwnershipOnlyOwner(address pranked) public {
        vm.assume(pranked != address(this));

        vm.prank(pranked);
        vm.expectRevert(abi.encodeWithSelector(IOwnable.OwnershipRequired.selector, address(this)));
        mock.transferOwnership(pranked);
    }

    function testAcceptOwnershipOnlyOwner(address pendingOwner, address pranked) public {
        vm.assume(pranked != pendingOwner);

        mock.transferOwnership(pendingOwner);

        vm.prank(pranked);
        vm.expectRevert(abi.encodeWithSelector(IOwnable2Step.PendingOwnershipRequired.selector, pendingOwner));
        mock.acceptOwnership();
    }
}
