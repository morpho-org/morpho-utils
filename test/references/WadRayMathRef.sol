// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.0;

import {WadRayMath} from "@aave/core-v3/contracts/protocol/libraries/math/WadRayMath.sol";

contract WadRayMathRef {
    function wadMul(uint256 x, uint256 y) public pure returns (uint256) {
        return WadRayMath.wadMul(x, y);
    }

    function wadMulDown(uint256 x, uint256 y) public pure returns (uint256) {
        return (x * y) / WadRayMath.WAD;
    }

    function wadMulUp(uint256 x, uint256 y) public pure returns (uint256) {
        return (x * y + WadRayMath.WAD - 1) / WadRayMath.WAD;
    }

    function wadDiv(uint256 x, uint256 y) public pure returns (uint256) {
        return WadRayMath.wadDiv(x, y);
    }

    function wadDivDown(uint256 x, uint256 y) public pure returns (uint256) {
        return (x * WadRayMath.WAD) / y;
    }

    function wadDivUp(uint256 x, uint256 y) public pure returns (uint256) {
        return (x * WadRayMath.WAD + y - 1) / y;
    }

    function rayMul(uint256 x, uint256 y) public pure returns (uint256) {
        return WadRayMath.rayMul(x, y);
    }

    function rayMulDown(uint256 x, uint256 y) public pure returns (uint256) {
        return (x * y) / WadRayMath.RAY;
    }

    function rayMulUp(uint256 x, uint256 y) public pure returns (uint256) {
        return (x * y + WadRayMath.RAY - 1) / WadRayMath.RAY;
    }

    function rayDiv(uint256 x, uint256 y) public pure returns (uint256) {
        return WadRayMath.rayDiv(x, y);
    }

    function rayDivDown(uint256 x, uint256 y) public pure returns (uint256) {
        return (x * WadRayMath.RAY) / y;
    }

    function rayDivUp(uint256 x, uint256 y) public pure returns (uint256) {
        return (x * WadRayMath.RAY + y - 1) / y;
    }

    function rayToWad(uint256 x) public pure returns (uint256) {
        return WadRayMath.rayToWad(x);
    }

    function wadToRay(uint256 x) public pure returns (uint256) {
        return WadRayMath.wadToRay(x);
    }

    function wadWeightedAvg(uint256 x, uint256 y, uint256 weight) public pure returns (uint256) {
        return (x * (WadRayMath.WAD - weight) + y * weight + WadRayMath.HALF_WAD) / WadRayMath.WAD;
    }

    function rayWeightedAvg(uint256 x, uint256 y, uint256 weight) public pure returns (uint256) {
        return (x * (WadRayMath.RAY - weight) + y * weight + WadRayMath.HALF_RAY) / WadRayMath.RAY;
    }
}
