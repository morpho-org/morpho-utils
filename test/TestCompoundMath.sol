// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.0;

import {CompoundMathMock} from "./mocks/CompoundMathMock.sol";
import {CompoundMathRef} from "./references/CompoundMathRef.sol";
import "forge-std/Test.sol";

contract TestCompoundMath is Test {
    CompoundMathMock mock;
    CompoundMathRef ref;

    function setUp() public {
        mock = new CompoundMathMock();
        ref = new CompoundMathRef();
    }

    /// TESTS ///

    function testMul(uint256 x, uint256 y) public {
        vm.assume(y == 0 || x <= type(uint256).max / y);

        assertEq(mock.mul(x, y), ref.mul(x, y));
    }

    function testMulOverflow(uint256 x, uint256 y) public {
        vm.assume(y > 0 && x > type(uint256).max / y);

        vm.expectRevert();
        mock.mul(x, y);
    }

    function testDiv(uint256 x, uint256 y) public {
        vm.assume(y > 0 && x <= type(uint256).max / 1e36);

        assertEq(mock.div(x, y), ref.div(x, y));
    }

    function testDivOverflow(uint256 x, uint256 y) public {
        vm.assume(y > 0 && x > type(uint256).max / 1e18);

        vm.expectRevert();
        mock.div(x, y);
    }

    function testDivByZero(uint256 x) public {
        vm.expectRevert();
        mock.div(x, 0);
    }
}
