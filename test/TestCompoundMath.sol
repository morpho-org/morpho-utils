// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "src/math/CompoundMath.sol";
import "./references/CompoundMathRef.sol";

contract TestCompoundMath is Test {
    uint256 internal constant WAD = 1e18;

    CompoundMathFunctions compoundMath;
    CompoundMathFunctionsRef compoundMathRef;

    function setUp() public {
        compoundMath = new CompoundMathFunctions();
        compoundMathRef = new CompoundMathFunctionsRef();
    }

    /// TESTS ///

    function testMul(uint128 _x, uint128 _y) public {
        uint256 x = _x;
        uint256 y = _y;
        assertEq(compoundMath.mul(x, y), compoundMathRef.mul(x, y));
    }

    function testDiv(uint128 _x, uint128 _y) public {
        vm.assume(_y > 0);

        uint256 x = _x;
        uint256 y = _y;
        assertEq(compoundMath.div(x, y), compoundMathRef.div(x, y));
    }

    /// GAS COMPARISONS ///

    function testGasMul() public view {
        compoundMath.mul(2 * WAD, WAD);
        compoundMathRef.mul(2 * WAD, WAD);
    }

    function testGasDiv() public view {
        compoundMath.div(10 * WAD, WAD);
        compoundMathRef.div(10 * WAD, WAD);
    }
}

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
