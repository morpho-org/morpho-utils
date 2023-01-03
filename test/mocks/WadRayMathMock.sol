// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.0;

import {WadRayMath} from "src/math/WadRayMath.sol";

contract WadRayMathMock {
    function wadMul(uint256 x, uint256 y) public pure returns (uint256) {
        return WadRayMath.wadMul(x, y);
    }

    function wadMulDown(uint256 x, uint256 y) public pure returns (uint256) {
        return WadRayMath.wadMulDown(x, y);
    }

    function wadMulUp(uint256 x, uint256 y) public pure returns (uint256) {
        return WadRayMath.wadMulUp(x, y);
    }

    function wadDiv(uint256 x, uint256 y) public pure returns (uint256) {
        return WadRayMath.wadDiv(x, y);
    }

    function wadDivDown(uint256 x, uint256 y) public pure returns (uint256) {
        return WadRayMath.wadDivDown(x, y);
    }

    function wadDivUp(uint256 x, uint256 y) public pure returns (uint256) {
        return WadRayMath.wadDivUp(x, y);
    }

    function rayMul(uint256 x, uint256 y) public pure returns (uint256) {
        return WadRayMath.rayMul(x, y);
    }

    function rayMulDown(uint256 x, uint256 y) public pure returns (uint256) {
        return WadRayMath.rayMulDown(x, y);
    }

    function rayMulUp(uint256 x, uint256 y) public pure returns (uint256) {
        return WadRayMath.rayMulUp(x, y);
    }

    function rayDiv(uint256 x, uint256 y) public pure returns (uint256) {
        return WadRayMath.rayDiv(x, y);
    }

    function rayDivDown(uint256 x, uint256 y) public pure returns (uint256) {
        return WadRayMath.rayDivDown(x, y);
    }

    function rayDivUp(uint256 x, uint256 y) public pure returns (uint256) {
        return WadRayMath.rayDivUp(x, y);
    }

    function rayToWad(uint256 x) public pure returns (uint256) {
        return WadRayMath.rayToWad(x);
    }

    function wadToRay(uint256 x) public pure returns (uint256) {
        return WadRayMath.wadToRay(x);
    }

    function wadWeightedAvg(uint256 x, uint256 y, uint256 weight) public pure returns (uint256) {
        return WadRayMath.wadWeightedAvg(x, y, weight);
    }

    function rayWeightedAvg(uint256 x, uint256 y, uint256 weight) public pure returns (uint256) {
        return WadRayMath.rayWeightedAvg(x, y, weight);
    }
}
