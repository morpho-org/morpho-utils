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

    function testStore() public {
        uint256 m;
        uint256 key;
        uint256 value;
        uint256 deBruijnSeq = 0x818283848586878898a8b8c8d8e8f929395969799a9b9d9e9faaeb6bedeeff;
        uint256 shift = 2**248;
        assembly {
            m := mload(0x40)
            mstore(m, 0xf8f9cbfae6cc78fbefe7cdc3a1793dfcf4f0e8bbd8cec470b6a28a7a5a3e1efd)
            mstore(add(m, 0x20), 0xf5ecf1b3e9debc68e1d9cfabc5997135bfb7a7a3938b7b606b5b4b3f2f1f0ffe)
            mstore(add(m, 0x40), 0xf6e4ed9ff2d6b458eadcdf97bd91692de2d4da8fd2d0ac50c6ae9a8272523616)
            mstore(add(m, 0x60), 0xc8c0b887b0a8a4489c948c7f847c6125746c645c544c444038302820181008ff)
            mstore(add(m, 0x80), 0xf7cae577eec2a03cf3bad76fb589591debb2dd67e0aa9834bea6925f6a4a2e0e)
            mstore(add(m, 0xa0), 0xe39ed557db96902cd38ed14fad815115c786af479b7e83247363534337271707)
            mstore(add(m, 0xc0), 0xc976c13bb96e881cb166a933a55e490d9d56952b8d4e801485467d2362422606)
            mstore(add(m, 0xe0), 0x753a6d1b65325d0c552a4d1345224105391a310b29122104190a110309020100)
            mstore(0x40, add(m, 0x100))
        }

        for (uint256 i; i < 256; i++) {
            uint256 x = 2**i;
            assembly {
                key := div(mul(x, deBruijnSeq), shift)
                value := div(mload(add(m, sub(255, key))), shift)
            }
            assertEq(value, i, "wrong value in lookup table");
        }
    }

    function testDeBruijnSequence() public {
        uint256 deBruijnSeq = 0x818283848586878898a8b8c8d8e8f929395969799a9b9d9e9faaeb6bedeeff;
        assertTrue(DeBruijn.isDeBruijnSequence(deBruijnSeq));
    }
}
