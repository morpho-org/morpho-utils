// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "forge-std/Vm.sol";
import "src/math/safeCast.sol";
import {SafeCast as SafeCastRef} from "openzeppelin-contracts/contracts/utils/math/SafeCast.sol";

contract SafeCastFunctions {
    function toUint96(uint256 x) public pure returns (uint96) {
        return SafeCast.toUint96(x);
    }
}

contract SafeCastFunctionsRef {
    function toUint96(uint256 x) public pure returns (uint96) {
        return SafeCastRef.toUint96(x);
    }
}

contract TestSafeCast is Test {
    SafeCastFunctions safeCast;
    SafeCastFunctionsRef safeCastRef;

    function setUp() public {
        safeCast = new SafeCastFunctions();
        safeCastRef = new SafeCastFunctionsRef();
    }

    /// TESTS ///

    function testToUint96Overflow(uint256 x) public {
        vm.assume(x > type(uint96).max);

        vm.expectRevert();
        safeCast.toUint96(x);
    }

    function testCastToUint96(uint256 x) public {
        vm.assume(x <= type(uint96).max);

        assertEq(safeCast.toUint96(x), uint96(x));
    }

    // GAS COMPARISONS ///

    function testSafeCastUint96() public view {
        safeCast.toUint96(1);
        safeCastRef.toUint96(1);
    }
}
