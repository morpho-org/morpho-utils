// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.0;

import {IERC3156xFlashLender} from "src/interfaces/IERC3156xFlashLender.sol";
import {IERC3156xFlashBorrower} from "src/interfaces/IERC3156xFlashBorrower.sol";

import {ERC20Mock} from "test/mocks/ERC20Mock.sol";
import {ERC3156xFlashLenderMock} from "test/mocks/ERC3156xFlashLenderMock.sol";
import {ERC3156xFlashBorrowerMock} from "test/mocks/ERC3156xFlashBorrowerMock.sol";

import "forge-std/Test.sol";

contract TestERC3156xFlashBorrower is Test {
    ERC20Mock token1;
    ERC20Mock token2;
    IERC3156xFlashLender lender;
    ERC3156xFlashBorrowerMock borrower;

    function setUp() public {
        token1 = new ERC20Mock("Test Token 1", "TT1");
        token2 = new ERC20Mock("Test Token 2", "TT2");
        lender = new ERC3156xFlashLenderMock();
        borrower = new ERC3156xFlashBorrowerMock(lender);

        deal(address(token1), address(lender), type(uint256).max);
    }

    function testFlashLoan(uint256 amount) public {
        borrower.flashLoan(address(token1), amount, bytes(""));
    }

    function testFlashLoanUnauthorizedLender(address _lender, address token, uint256 amount, uint256 fee) public {
        vm.assume(_lender != address(lender));

        vm.prank(_lender);
        vm.expectRevert(IERC3156xFlashBorrower.UnauthorizedLender.selector);
        borrower.onFlashLoan(address(borrower), token, amount, fee, bytes(""));
    }

    function testFlashLoanUnauthorizedInitiator(address initiator, uint256 amount) public {
        vm.assume(initiator != address(borrower));

        vm.prank(initiator);
        vm.expectRevert(IERC3156xFlashBorrower.UnauthorizedInitiator.selector);
        lender.flashLoan(borrower, address(token1), amount, bytes(""));
    }
}
