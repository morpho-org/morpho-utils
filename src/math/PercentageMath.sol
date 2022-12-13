// SPDX-License-Identifier: GNU AGPLv3
pragma solidity ^0.8.0;

/// @title PercentageMath.
/// @author Morpho Labs.
/// @custom:contact security@morpho.xyz
/// @notice Optimized version of Aave V3 math library PercentageMath to conduct percentage manipulations: https://github.com/aave/aave-v3-core/blob/master/contracts/protocol/libraries/math/PercentageMath.sol
library PercentageMath {
    ///	CONSTANTS ///

    // Only direct number constants and references to such constants are supported by inline assembly.
    uint256 internal constant PERCENTAGE_FACTOR = 100_00;
    uint256 internal constant HALF_PERCENTAGE_FACTOR = 50_00;
    uint256 internal constant PERCENTAGE_FACTOR_MINUS_ONE = 100_00 - 1;
    uint256 internal constant MAX_UINT256 = 2**256 - 1;
    uint256 internal constant MAX_UINT256_MINUS_HALF_PERCENTAGE = 2**256 - 1 - 50_00;
    uint256 internal constant MAX_UINT256_MINUS_PERCENTAGE_FACTOR_MINUS_ONE = 2**256 - 1 - (100_00 - 1);
    uint256 internal constant MAX_UINT256_PERCENTAGE_FACTOR_RATIO = 0x68db8bac710cb295e9e1b089a027525460aa64c2f837b4a2339c0ebedfa43;

    /// INTERNAL ///

    /// @notice Executes a percentage addition (x * (1 + p)), rounded up.
    /// @param x The value to which to add the percentage.
    /// @param percentage The percentage of the value to add.
    /// @return y The result of the addition.
    function percentAdd(uint256 x, uint256 percentage) internal pure returns (uint256 y) {
        // Must revert if
        // PERCENTAGE_FACTOR + percentage > type(uint256).max
        //     or x * (PERCENTAGE_FACTOR + percentage) + HALF_PERCENTAGE_FACTOR > type(uint256).max
        // <=> percentage > type(uint256).max - PERCENTAGE_FACTOR
        //     or x > (type(uint256).max - HALF_PERCENTAGE_FACTOR) / (PERCENTAGE_FACTOR + percentage)
        // Note: PERCENTAGE_FACTOR + percentage >= PERCENTAGE_FACTOR > 0
        assembly {
            y := add(PERCENTAGE_FACTOR, percentage) // Temporary assignment to save gas.

            if or(
                gt(percentage, sub(MAX_UINT256, PERCENTAGE_FACTOR)),
                gt(x, div(MAX_UINT256_MINUS_HALF_PERCENTAGE, y))
            ) {
                revert(0, 0)
            }

            y := div(add(mul(x, y), HALF_PERCENTAGE_FACTOR), PERCENTAGE_FACTOR)
        }
    }

    /// @notice Executes a percentage subtraction (x * (1 - p)), rounded up.
    /// @param x The value to which to subtract the percentage.
    /// @param percentage The percentage of the value to subtract.
    /// @return y The result of the subtraction.
    function percentSub(uint256 x, uint256 percentage) internal pure returns (uint256 y) {
        // Must revert if
        // percentage > PERCENTAGE_FACTOR
        //     or x * (PERCENTAGE_FACTOR - percentage) + HALF_PERCENTAGE_FACTOR > type(uint256).max
        // <=> percentage > PERCENTAGE_FACTOR
        //     or ((PERCENTAGE_FACTOR - percentage) > 0 and x > (type(uint256).max - HALF_PERCENTAGE_FACTOR) / (PERCENTAGE_FACTOR - percentage))
        assembly {
            y := sub(PERCENTAGE_FACTOR, percentage) // Temporary assignment to save gas.

            if or(gt(percentage, PERCENTAGE_FACTOR), mul(y, gt(x, div(MAX_UINT256_MINUS_HALF_PERCENTAGE, y)))) {
                revert(0, 0)
            }

            y := div(add(mul(x, y), HALF_PERCENTAGE_FACTOR), PERCENTAGE_FACTOR)
        }
    }

    /// @notice Executes a percentage multiplication (x * p), rounded up.
    /// @param x The value to multiply by the percentage.
    /// @param percentage The percentage of the value to multiply.
    /// @return y The result of the multiplication.
    function percentMul(uint256 x, uint256 percentage) internal pure returns (uint256 y) {
        // Must revert if
        // x * percentage + HALF_PERCENTAGE_FACTOR > type(uint256).max
        // <=> percentage > 0 and x > (type(uint256).max - HALF_PERCENTAGE_FACTOR) / percentage
        assembly {
            if mul(percentage, gt(x, div(MAX_UINT256_MINUS_HALF_PERCENTAGE, percentage))) {
                revert(0, 0)
            }

            y := div(add(mul(x, percentage), HALF_PERCENTAGE_FACTOR), PERCENTAGE_FACTOR)
        }
    }

    /// @notice Executes a percentage multiplication (x * p), flooring the result.
    /// @param x The value to multiply by the percentage.
    /// @param percentage The percentage of the value to multiply.
    /// @return y The result of the multiplication.
    function percentMulDown(uint256 x, uint256 percentage) internal pure returns (uint256 y) {
        // Let percentage > 0
        // Overflow if (x * percentage) > type(uint256).max
        // <=> x > type(uint256).max / percentage
        assembly {
            if mul(percentage, gt(x, div(MAX_UINT256, percentage))) {
                revert(0, 0)
            }

            y := div(mul(x, percentage), PERCENTAGE_FACTOR)
        }
    }

    /// @notice Executes a percentage multiplication (x * p), ceiling the result.
    /// @param x The value to multiply by the percentage.
    /// @param percentage The percentage of the value to multiply.
    /// @return y The result of the multiplication.
    function percentMulUp(uint256 x, uint256 percentage) internal pure returns (uint256 y) {
        // Let percentage > 0
        // Overflow if (x * percentage + PERCENTAGE_FACTOR_MINUS_ONE) > type(uint256).max
        // <=> x * percentage > type(uint256).max - PERCENTAGE_FACTOR_MINUS_ONE
        // <=> x > (type(uint256).max - PERCENTAGE_FACTOR_MINUS_ONE) / percentage
        assembly {
            if mul(percentage, gt(x, div(MAX_UINT256_MINUS_PERCENTAGE_FACTOR_MINUS_ONE, percentage))) {
                revert(0, 0)
            }

            y := div(add(mul(x, percentage), PERCENTAGE_FACTOR_MINUS_ONE), PERCENTAGE_FACTOR)
        }
    }

    /// @notice Executes a percentage division (x / p), rounded up.
    /// @param x The value to divide by the percentage.
    /// @param percentage The percentage of the value to divide.
    /// @return y The result of the division.
    function percentDiv(uint256 x, uint256 percentage) internal pure returns (uint256 y) {
        // Must revert if
        // percentage == 0
        //     or x * PERCENTAGE_FACTOR + percentage / 2 > type(uint256).max
        // <=> percentage == 0
        //     or x > (type(uint256).max - percentage / 2) / PERCENTAGE_FACTOR
        assembly {
            y := div(percentage, 2) // Temporary assignment to save gas.

            if iszero(mul(percentage, iszero(gt(x, div(sub(MAX_UINT256, y), PERCENTAGE_FACTOR))))) {
                revert(0, 0)
            }

            y := div(add(mul(PERCENTAGE_FACTOR, x), y), percentage)
        }
    }

    /// @notice Executes a percentage division (x / p), flooring the result.
    /// @param x The value to divide by the percentage.
    /// @param percentage The percentage of the value to divide.
    /// @return y The result of the division.
    function percentDivDown(uint256 x, uint256 percentage) internal pure returns (uint256 y) {
        // Overflow if percentage == 0
        // Overflow if (x * PERCENTAGE_FACTOR) > type(uint256).max
        // <=> x > type(uint256).max / PERCENTAGE_FACTOR
        assembly {
            if iszero(mul(percentage, iszero(gt(x, MAX_UINT256_PERCENTAGE_FACTOR_RATIO)))) {
                revert(0, 0)
            }

            y := div(mul(PERCENTAGE_FACTOR, x), percentage)
        }
    }

    /// @notice Executes a percentage division (x / p), ceiling the result.
    /// @param x The value to divide by the percentage.
    /// @param percentage The percentage of the value to divide.
    /// @return y The result of the division.
    function percentDivUp(uint256 x, uint256 percentage) internal pure returns (uint256 y) {
        // Overflow if percentage == 0
        // Overflow if (x * PERCENTAGE_FACTOR + percentage - 1) > type(uint256).max
        // <=> x * PERCENTAGE_FACTOR > type(uint256).max - (percentage - 1)
        // <=> x > (type(uint256).max - (percentage - 1)) / PERCENTAGE_FACTOR
        assembly {
            y := sub(percentage, 1)
            if iszero(mul(percentage, iszero(gt(x, div(sub(MAX_UINT256, y), PERCENTAGE_FACTOR))))) {
                revert(0, 0)
            }

            y := div(add(mul(PERCENTAGE_FACTOR, x), y), percentage)
        }
    }

    /// @notice Executes a weighted average (x * (1 - p) + y * p), rounded up.
    /// @param x The first value, with a weight of 1 - percentage.
    /// @param y The second value, with a weight of percentage.
    /// @param percentage The weight of y, and complement of the weight of x.
    /// @return z The result of the weighted average.
    function weightedAvg(
        uint256 x,
        uint256 y,
        uint256 percentage
    ) internal pure returns (uint256 z) {
        // Must revert if
        //     percentage > PERCENTAGE_FACTOR
        // or if
        //     y * percentage + HALF_PERCENTAGE_FACTOR > type(uint256).max
        //     <=> percentage > 0 and y > (type(uint256).max - HALF_PERCENTAGE_FACTOR) / percentage
        // or if
        //     x * (PERCENTAGE_FACTOR - percentage) + y * percentage + HALF_PERCENTAGE_FACTOR > type(uint256).max
        //     <=> (PERCENTAGE_FACTOR - percentage) > 0 and x > (type(uint256).max - HALF_PERCENTAGE_FACTOR - y * percentage) / (PERCENTAGE_FACTOR - percentage)
        assembly {
            z := sub(PERCENTAGE_FACTOR, percentage) // Temporary assignment to save gas.
            if or(
                gt(percentage, PERCENTAGE_FACTOR),
                or(
                    mul(percentage, gt(y, div(MAX_UINT256_MINUS_HALF_PERCENTAGE, percentage))),
                    mul(z, gt(x, div(sub(MAX_UINT256_MINUS_HALF_PERCENTAGE, mul(y, percentage)), z)))
                )
            ) {
                revert(0, 0)
            }
            z := div(add(add(mul(x, z), mul(y, percentage)), HALF_PERCENTAGE_FACTOR), PERCENTAGE_FACTOR)
        }
    }
}
