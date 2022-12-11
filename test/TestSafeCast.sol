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

    function testOverflowToUint128(uint256 x) public {
        vm.assume(x > type(uint128).max);

        vm.expectRevert();
        SafeCast.toUint128(x);
    }

    function testCastToUint128(uint256 x) public {
        vm.assume(x <= type(uint96).max);

        assertEq(SafeCast.toUint128(x), uint128(x));
    }

    function testOverflowToUint96(uint256 x) public {
        vm.assume(x > type(uint96).max);

        vm.expectRevert();
        SafeCast.toUint96(x);
    }

    function testCastToUint96(uint256 x) public {
        vm.assume(x <= type(uint96).max);

        assertEq(SafeCast.toUint96(x), uint96(x));
    }

    function testOverflowToUint64(uint256 x) public {
        vm.assume(x > type(uint64).max);

        vm.expectRevert();
        SafeCast.toUint64(x);
    }

    function testCastToUint64(uint256 x) public {
        vm.assume(x <= type(uint64).max);

        assertEq(SafeCast.toUint64(x), uint64(x));
    }

    function testCastToUint32(uint256 x) public {
        vm.assume(x <= type(uint32).max);

        assertEq(SafeCast.toUint32(x), uint32(x));
    }

    function testOverflowToUint32(uint256 x) public {
        vm.assume(x > type(uint32).max);

        vm.expectRevert();
        SafeCast.toUint32(x);
    }

    function testCastToUint16(uint256 x) public {
        vm.assume(x <= type(uint16).max);

        assertEq(SafeCast.toUint16(x), uint16(x));
    }

    function testOverflowToUint16(uint256 x) public {
        vm.assume(x > type(uint16).max);

        vm.expectRevert();
        SafeCast.toUint16(x);
    }

    function testCastToUint8(uint256 x) public {
        vm.assume(x <= type(uint8).max);

        assertEq(SafeCast.toUint8(x), uint8(x));
    }

    function testOverflowToUint8(uint256 x) public {
        vm.assume(x > type(uint8).max);

        vm.expectRevert();
        SafeCast.toUint8(x);
    }


    // GAS COMPARISONS ///

    function testSafeCastUint96() public view {
        safeCast.toUint96(1);
        safeCastRef.toUint96(1);
    }
}
