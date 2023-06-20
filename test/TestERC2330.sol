// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.0;

import {IERC2330} from "src/interfaces/IERC2330.sol";

import {ERC2330Mock} from "test/mocks/ERC2330Mock.sol";

import "forge-std/Test.sol";

contract TestERC2330 is Test {
    ERC2330Mock mock;

    function setUp() public {
        mock = new ERC2330Mock();
    }

    function testExtsload() public {
        assertEq(
            mock.extsload(0x0000000000000000000000000000000000000000000000000000000000000000),
            0x0000000000000000000000000000000100000000000000000000000000000001
        );
        assertEq(
            mock.extsload(0x0000000000000000000000000000000000000000000000000000000000000001),
            0x0000000000000000000000000000000000000000000000000000000000000002
        );
    }

    function testExtsloadMultiple() public {
        (bytes32 var1, bytes32 var2) = abi.decode(
            mock.extsload(0x0000000000000000000000000000000000000000000000000000000000000000, 2), (bytes32, bytes32)
        );

        assertEq(var1, 0x0000000000000000000000000000000100000000000000000000000000000001);
        assertEq(var2, 0x0000000000000000000000000000000000000000000000000000000000000002);
    }
}
