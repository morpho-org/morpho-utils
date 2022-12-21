// SPDX-License-Identifier: GNU AGPLv3
pragma solidity ^0.8.0;

import {WadRayMath} from "@aave/core-v3/contracts/protocol/libraries/math/WadRayMath.sol";

contract WadRayMathRef {
    function wadMul(uint256 x, uint256 y) public pure returns (uint256) {
        return WadRayMath.wadMul(x, y);
    }

    function wadDiv(uint256 x, uint256 y) public pure returns (uint256) {
        return WadRayMath.wadDiv(x, y);
    }

    function rayMul(uint256 x, uint256 y) public pure returns (uint256) {
        return WadRayMath.rayMul(x, y);
    }

    function rayDiv(uint256 x, uint256 y) public pure returns (uint256) {
        return WadRayMath.rayDiv(x, y);
    }

    function rayToWad(uint256 x) public pure returns (uint256) {
        return WadRayMath.rayToWad(x);
    }

    function wadToRay(uint256 x) public pure returns (uint256) {
        return WadRayMath.wadToRay(x);
    }

    function wadWeightedAvg(
        uint256 x,
        uint256 y,
        uint256 weight
    ) public pure returns (uint256) {
        return (x * (WadRayMath.WAD - weight) + y * weight + WadRayMath.HALF_WAD) / WadRayMath.WAD;
    }

    function rayWeightedAvg(
        uint256 x,
        uint256 y,
        uint256 weight
    ) public pure returns (uint256) {
        return (x * (WadRayMath.RAY - weight) + y * weight + WadRayMath.HALF_RAY) / WadRayMath.RAY;
    }
}