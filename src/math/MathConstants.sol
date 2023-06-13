// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.0;

// Only direct number constants and references to such constants are supported by inline assembly.

int256 constant MIN_INT256 = -2 ** 255;
uint256 constant MAX_UINT256 = 2 ** 256 - 1;

uint256 constant PERCENTAGE_FACTOR = 100_00;
uint256 constant HALF_PERCENTAGE_FACTOR = 50_00;
uint256 constant PERCENTAGE_FACTOR_MINUS_ONE = 100_00 - 1;
uint256 constant MAX_UINT256_MINUS_HALF_PERCENTAGE_FACTOR = 2 ** 256 - 1 - 50_00;
uint256 constant MAX_UINT256_MINUS_PERCENTAGE_FACTOR_MINUS_ONE = 2 ** 256 - 1 - (100_00 - 1);

uint256 constant WAD = 1e18;
uint256 constant HALF_WAD = 0.5e18;
uint256 constant WAD_MINUS_ONE = 1e18 - 1;
uint256 constant RAY = 1e27;
uint256 constant HALF_RAY = 0.5e27;
uint256 constant RAY_MINUS_ONE = 1e27 - 1;
uint256 constant RAY_WAD_RATIO = 1e9;
uint256 constant HALF_RAY_WAD_RATIO = 0.5e9;
uint256 constant MAX_UINT256_MINUS_HALF_WAD = 2 ** 256 - 1 - 0.5e18;
uint256 constant MAX_UINT256_MINUS_HALF_RAY = 2 ** 256 - 1 - 0.5e27;
uint256 constant MAX_UINT256_MINUS_WAD_MINUS_ONE = 2 ** 256 - 1 - (1e18 - 1);
uint256 constant MAX_UINT256_MINUS_RAY_MINUS_ONE = 2 ** 256 - 1 - (1e27 - 1);
