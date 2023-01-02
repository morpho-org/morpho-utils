// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import {MathMock} from "./mocks/MathMock.sol";
import {MathRef} from "./references/MathRef.sol";
import {DeBruijn} from "./helpers/DeBruijn.sol";
import "forge-std/Test.sol";

contract TestMath is Test {
    MathMock mock;
    MathRef ref;

    function setUp() public {
        mock = new MathMock();
        ref = new MathRef();
    }

    /// TESTS ///

    function testMin(uint256 x, uint256 y) public {
        assertEq(mock.min(x, y), ref.min(x, y));
    }

    function testMax(uint256 x, uint256 y) public {
        assertEq(mock.max(x, y), ref.max(x, y));
    }

    function testSafeSub(uint256 x, uint256 y) public {
        assertEq(mock.zeroFloorSub(x, y), ref.zeroFloorSub(x, y));
    }

    function testDivUp(uint256 x, uint256 y) public {
        vm.assume(y > 0 && x < type(uint256).max - (y - 1));

        assertEq(mock.divUp(x, y), ref.divUp(x, y));
    }

    function testDivUpByZero(uint256 x) public {
        vm.expectRevert();
        mock.divUp(x, 0);
    }

    function testDivUpNumSmaller(uint256 x, uint256 y) public {
        vm.assume(x > 0 && x < y);
        assertEq(mock.divUp(x, y), 1);
    }

    function testDivUpNumDivisible(uint256 x, uint256 y) public {
        vm.assume(y > 0 && x % y == 0);
        assertEq(mock.divUp(x, y), x / y);
    }

    function testDivUpNumNotDivisible(uint256 x, uint256 y) public {
        vm.assume(y > 0 && x % y != 0);
        assertEq(mock.divUp(x, y), x / y + 1);
    }

    function testLog2CompareNaive(uint256 x) public {
        assertEq(mock.log2(x), ref.log2Naive(x));
    }

    function testLog2CompareDicho(uint256 x) public {
        assertEq(mock.log2(x), ref.log2Dichotomy(x));
    }

    function testRoundDownToPowerOf2(uint256 x) public {
        assertEq(mock.roundDownToPowerOf2(x), ref.roundDownToPowerOf2Naive(x));
    }

    function testDeBruijnSequence() public {
        (uint256 deBruijnSeq, ) = mock.lookupDeBruijn(1);
        assertTrue(DeBruijn.isDeBruijnSequence(deBruijnSeq));
    }

    function testHashTable() public {
        for (uint256 i; i < 256; i++) {
            uint256 x = 2**i;
            (, uint256 value) = mock.lookupDeBruijn(x);
            assertEq(value, i, "wrong value in lookup table");
        }
    }
}
