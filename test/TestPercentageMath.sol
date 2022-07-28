// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "forge-std/Vm.sol";
import "src/math/PercentageMath.sol";
import {PercentageMath as PercentageMathRef} from "@aave/core-v3/contracts/protocol/libraries/math/PercentageMath.sol";

contract PercentageMathFunctions {
    function percentMul(uint256 x, uint256 y) public pure returns (uint256) {
        return PercentageMath.percentMul(x, y);
    }

    function percentDiv(uint256 x, uint256 y) public pure returns (uint256) {
        return PercentageMath.percentDiv(x, y);
    }
}

contract PercentageMathFunctionsRef {
    function percentMul(uint256 x, uint256 y) public pure returns (uint256) {
        return PercentageMathRef.percentMul(x, y);
    }

    function percentDiv(uint256 x, uint256 y) public pure returns (uint256) {
        return PercentageMathRef.percentDiv(x, y);
    }
}

contract TestPercentageMath is Test {
    uint256 internal constant PERCENTAGE_FACTOR = 1e4;
    uint256 internal constant HALF_PERCENTAGE_FACTOR = 0.5e4;
    uint256 internal constant MAX_UINT256 = 2**256 - 1;
    uint256 internal constant MAX_UINT256_MINUS_HALF_PERCENTAGE = 2**256 - 1 - 0.5e4;

    PercentageMathFunctions math;
    PercentageMathFunctionsRef mathRef;

    function setUp() public {
        math = new PercentageMathFunctions();
        mathRef = new PercentageMathFunctionsRef();
    }

    /// TESTS ///

    function testPercentMul(uint256 x, uint256 y) public {
        unchecked {
            if (y > 0 && x > MAX_UINT256_MINUS_HALF_PERCENTAGE / y) {
                vm.expectRevert();
                PercentageMath.percentMul(x, y);
            }
        }

        assertEq(PercentageMath.percentMul(x, y), PercentageMathRef.percentMul(x, y));
    }

    function testPercentDiv(uint256 x, uint256 y) public {
        unchecked {
            if (y == 0 || x > (MAX_UINT256 - y / 2) / PERCENTAGE_FACTOR) {
                vm.expectRevert();
                PercentageMath.percentDiv(x, y);
            }
        }
        assertEq(PercentageMath.percentDiv(x, y), PercentageMathRef.percentDiv(x, y));
    }

    /// GAS COMPARISONS ///

    function testGasPercentageMul() public view {
        math.percentMul(1 ether, 1_000);
        mathRef.percentMul(1 ether, 1_000);
    }

    function testGasPercentageDiv() public view {
        math.percentDiv(1 ether, 1_000);
        mathRef.percentDiv(1 ether, 1_000);
    }
}
