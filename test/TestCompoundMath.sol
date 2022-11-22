// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "src/math/CompoundMath.sol";
import "./references/CompoundMathRef.sol";

contract CompoundMathFunctions {
    function mul(uint256 x, uint256 y) public pure returns (uint256) {
        return CompoundMath.mul(x, y);
    }

    function div(uint256 x, uint256 y) public pure returns (uint256) {
        return CompoundMath.div(x, y);
    }
}

contract CompoundMathFunctionsRef {
    function mul(uint256 x, uint256 y) public pure returns (uint256) {
        return CompoundMathRef.mul(x, y);
    }

    function div(uint256 x, uint256 y) public pure returns (uint256) {
        return CompoundMathRef.div(x, y);
    }
}

contract TestCompoundMath is Test {
    uint256 internal constant SCALE = 1e36;
    uint256 internal constant WAD = 1e18;

    CompoundMathFunctions compoundMath;
    CompoundMathFunctionsRef compoundMathRef;

    function setUp() public {
        compoundMath = new CompoundMathFunctions();
        compoundMathRef = new CompoundMathFunctionsRef();
    }

    /// TESTS ///

    function testMul(uint256 x, uint256 y) public {
        unchecked {
            vm.assume(y == 0 || (x * y) / y == x);
        }

        assertEq(CompoundMath.mul(x, y), CompoundMathRef.mul(x, y));
    }

    function testMulOverflow(uint256 x, uint256 y) public {
        unchecked {
            vm.assume(y > 0 && (x * y) / y != x);
        }

        vm.expectRevert();
        CompoundMath.mul(x, y);
    }

    function testDiv(uint256 x, uint256 y) public {
        unchecked {
            vm.assume(y > 0 && (x == 0 || (x * SCALE) / x == SCALE));
        }

        assertEq(CompoundMath.div(x, y), CompoundMathRef.div(x, y));
    }

    function testDivOverflow(uint256 x, uint256 y) public {
        unchecked {
            vm.assume(x > 0 && (x * WAD) / x != WAD);
        }

        vm.expectRevert();
        CompoundMath.div(x, y);
    }

    function testDivByZero(uint256 x, uint256 y) public {
        vm.assume(y == 0);
        vm.expectRevert();
        CompoundMath.div(x, y);
    }

    /// GAS COMPARISONS ///

    function testGasMul() public view {
        compoundMath.mul(2 * WAD, WAD);
        compoundMathRef.mul(2 * WAD, WAD);
    }

    function testGasDiv() public view {
        compoundMath.div(2 * WAD, WAD);
        compoundMathRef.div(2 * WAD, WAD);
    }
}
