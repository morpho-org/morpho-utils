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

    function testDeBruijnSequence() public {
        uint256 deBruijnSeq = 0x00818283848586878898a8b8c8d8e8f929395969799a9b9d9e9faaeb6bedeeff;
        assertTrue(DeBruijn.isDeBruijnSequence(deBruijnSeq));
    }

    function testHashTable() public {
        uint256 m;
        uint256 key;
        uint256 value;
        uint256 deBruijnSeq = 0x00818283848586878898a8b8c8d8e8f929395969799a9b9d9e9faaeb6bedeeff;
        assembly {
            m := mload(0x40)
            mstore(m, 0x0001020903110a19042112290b311a3905412245134d2a550c5d32651b6d3a75)
            mstore(add(m, 0x20), 0x06264262237d468514804e8d2b95569d0d495ea533a966b11c886eb93bc176c9)
            mstore(add(m, 0x40), 0x071727374353637324837e9b47af86c7155181ad4fd18ed32c9096db57d59ee3)
            mstore(add(m, 0x60), 0x0e2e4a6a5f92a6be3498aae067ddb2eb1d5989b56fd7baf33ca0c2ee77e5caf7)
            mstore(add(m, 0x80), 0xff0810182028303840444c545c646c7425617c847f8c949c48a4a8b087b8c0c8)
            mstore(add(m, 0xa0), 0x16365272829aaec650acd0d28fdad4e22d6991bd97dfdcea58b4d6f29fede4f6)
            mstore(add(m, 0xc0), 0xfe0f1f2f3f4b5b6b607b8b93a3a7b7bf357199c5abcfd9e168bcdee9b3f1ecf5)
            mstore(add(m, 0xe0), 0xfd1e3e5a7a8aa2b670c4ced8bbe8f0f4fc3d79a1c3cde7effb78cce6facbf9f8)
            mstore(0x40, add(m, 0x100))
        }

        for (uint256 i; i < 256; i++) {
            uint256 x = 2**i;
            assembly {
                key := shr(248, mul(x, deBruijnSeq))
                value := shr(248, mload(add(m, key)))
            }
            assertEq(value, i, "wrong value in lookup table");
        }

        uint256[] memory rows = DeBruijn.precomputeRows(deBruijnSeq);
        uint256 rowFromLookupTable;
        for (uint256 i; i < 8; i++) {
            assembly {
                rowFromLookupTable := mload(add(m, mul(32, i)))
            }
            assertEq(rowFromLookupTable, rows[i]);
        }
    }
}
