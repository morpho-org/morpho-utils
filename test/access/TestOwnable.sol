// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.0;

import {IOwnable} from "src/interfaces/access/IOwnable.sol";

import {OwnableMock} from "test/mocks/OwnableMock.sol";

import "forge-std/Test.sol";

contract TestOwnable is Test {
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    IOwnable mock;

    function setUp() public {
        mock = new OwnableMock(address(this));
    }

    function testConstructorOwner(address initialOwner) public {
        mock = new OwnableMock(initialOwner);

        assertEq(mock.owner(), initialOwner);
    }

    function testTransferOwnership(address newOwner) public {
        vm.expectEmit(true, true, true, true, address(mock));
        emit OwnershipTransferred(address(this), newOwner);

        mock.transferOwnership(newOwner);

        assertEq(mock.owner(), newOwner);
    }

    function testTransferOwnershipOnlyOwner(address pranked) public {
        vm.assume(pranked != address(this));

        vm.prank(pranked);
        vm.expectRevert(abi.encodeWithSelector(IOwnable.OwnershipRequired.selector, address(this)));
        mock.transferOwnership(pranked);
    }
}
