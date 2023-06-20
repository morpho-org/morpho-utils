// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.0;

import {IERC3156xFlashLender} from "src/interfaces/IERC3156xFlashLender.sol";
import {IERC3156xFlashBorrower} from "src/interfaces/IERC3156xFlashBorrower.sol";

import {FLASH_BORROWER_SUCCESS_HASH} from "src/ERC3156xFlashLender.sol";
import {SafeTransferLib, ERC20} from "solmate/utils/SafeTransferLib.sol";

import {ERC20Mock} from "test/mocks/ERC20Mock.sol";
import {ERC3156xFlashLenderMock} from "test/mocks/ERC3156xFlashLenderMock.sol";

import "forge-std/Test.sol";

contract TestERC3156xFlashLenderBase is Test, IERC3156xFlashBorrower {
    ERC20Mock token1;
    ERC20Mock token2;
    IERC3156xFlashLender lender;

    function setUp() public {
        token1 = new ERC20Mock("Test Token 1", "TT1");
        token2 = new ERC20Mock("Test Token 2", "TT2");
        lender = new ERC3156xFlashLenderMock();

        deal(address(token1), address(lender), type(uint256).max);
    }

    function onFlashLoan(address, address, uint256, uint256, bytes calldata)
        public
        virtual
        returns (bytes32, bytes memory)
    {
        return (FLASH_BORROWER_SUCCESS_HASH, bytes(""));
    }
}

contract TestERC3156xFlashLender is TestERC3156xFlashLenderBase {
    using SafeTransferLib for ERC20;

    function testFlashLoanTooLarge(address initiator, uint256 amount) public {
        amount = bound(amount, 1, type(uint256).max);

        vm.prank(initiator);
        vm.expectRevert(abi.encodeWithSelector(IERC3156xFlashLender.FlashLoanTooLarge.selector, 0));
        lender.flashLoan(this, address(token2), amount, bytes(""));
    }
}

contract TestERC3156xFlashLenderSuccess is TestERC3156xFlashLenderBase {
    using SafeTransferLib for ERC20;

    address expectedInitiator;
    uint256 expectedAmount;
    uint256 expectedFee;
    bytes expectedData;

    function testFlashLoan(address initiator, uint256 amount) public {
        expectedInitiator = initiator;
        expectedAmount = amount;
        expectedFee = lender.flashFee(address(token1), amount);
        expectedData = bytes("Hello");

        vm.prank(initiator);
        lender.flashLoan(this, address(token1), amount, expectedData);
    }

    function onFlashLoan(address initiator, address token, uint256 amount, uint256 fee, bytes calldata data)
        public
        virtual
        override
        returns (bytes32, bytes memory)
    {
        assertEq(initiator, expectedInitiator, "initiator");
        assertEq(token, address(token1), "token");
        assertEq(amount, expectedAmount, "amount");
        assertEq(fee, expectedFee, "fee");
        assertEq(data, expectedData, "data");

        assertEq(ERC20(token).balanceOf(address(this)), amount, "balanceOf");

        ERC20(token).safeApprove(msg.sender, amount + fee);

        return (FLASH_BORROWER_SUCCESS_HASH, bytes(""));
    }
}

contract TestERC3156xFlashLenderFailure is TestERC3156xFlashLenderBase {
    using SafeTransferLib for ERC20;

    function testFlashLoanInvalidSuccessHash(address initiator, uint256 amount, bytes32 successHash) public {
        vm.assume(successHash != FLASH_BORROWER_SUCCESS_HASH);

        vm.prank(initiator);
        vm.expectRevert(abi.encodeWithSelector(IERC3156xFlashLender.InvalidSuccessHash.selector, successHash));
        lender.flashLoan(this, address(token1), amount, abi.encode(successHash));
    }

    function onFlashLoan(address, address token, uint256 amount, uint256 fee, bytes calldata data)
        public
        virtual
        override
        returns (bytes32, bytes memory)
    {
        ERC20(token).safeApprove(msg.sender, amount + fee);

        return (abi.decode(data, (bytes32)), bytes(""));
    }
}
