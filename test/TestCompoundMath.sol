// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "src/CompoundMath.sol";

contract TestCompoundMath is Test {
    using CompoundMath for uint256;

    function testMul(uint128 _x, uint128 _y) public {
        uint256 x = _x;
        uint256 y = _y;
        assertEq(x.mul(y), mul(x, y));
    }

    function testDiv(uint128 _x, uint128 _y) public {
        vm.assume(_y > 0);

        uint256 x = _x;
        uint256 y = _y;
        assertEq(x.div(y), div(x, y));
    }

    /// REFERENCES ///

    function mul(uint256 x, uint256 y) internal pure returns (uint256) {
        return (x * y) / 1e18;
    }

    function div(uint256 x, uint256 y) internal pure returns (uint256) {
        return ((1e18 * x * 1e18) / y) / 1e18;
    }
}
