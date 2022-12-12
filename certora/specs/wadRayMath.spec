methods {
    wadMul(uint256, uint256)                   returns (uint256)       envfree
    wadDiv(uint256, uint256)                   returns (uint256)       envfree
    rayMul(uint256, uint256)                   returns (uint256)       envfree
    rayDiv(uint256, uint256)                   returns (uint256)       envfree
    rayToWad(uint256)                          returns (uint256)       envfree
    wadToRay(uint256)                          returns (uint256)       envfree
    wadWeightedAvg(uint256, uint256, uint256)  returns (uint256)       envfree
    rayWeightedAvg(uint256, uint256, uint256)  returns (uint256)       envfree
}

definition WAD()        returns uint = 10^18;
definition RAY()        returns uint = 10^27;
definition WADTORAY()   returns uint = 10^9;

/// wadMul ///

rule wadMulSafety(uint256 a, uint256 b) {
    uint res = wadMul(a, b);

    assert res == (a * b + (WAD() / 2)) / WAD();
}

rule wadMulLiveness(uint256 a, uint256 b) {
    wadMul@withrevert(a, b);

    assert lastReverted <=> a * b + WAD() / 2 >= 2^256;
}

/// wadDiv ///

rule wadDivSafety(uint256 a, uint256 b) {
    uint res = wadDiv(a, b);

    assert res == (a * WAD() + (b / 2)) / b;
}

rule wadDivLiveness(uint256 a, uint256 b) {
    wadDiv@withrevert(a, b);

    assert lastReverted <=> a * WAD() + b / 2 >= 2^256 || b == 0;
}

/// rayMul ///

rule rayMulSafety(uint256 a, uint256 b) {
    uint res = rayMul(a, b);

    assert res == (a * b + (RAY() / 2)) / RAY();
}

rule rayMulLiveness(uint256 a, uint256 b) {
    rayMul@withrevert(a, b);

    assert lastReverted <=> a * b + RAY() / 2 >= 2^256;
}

/// rayDiv ///

rule rayDivSafety(uint256 a, uint256 b) {
    uint res = rayDiv(a, b);

    assert res == (a * RAY() + (b / 2)) / b;
}

rule rayDivLiveness(uint256 a, uint256 b) {
    rayDiv@withrevert(a, b);

    assert lastReverted <=> a * RAY() + b / 2 >= 2^256 || b == 0;
}

/// rayToWad ///

rule rayToWadSafety(uint256 a) {
    uint res = rayToWad(a);

    assert res == (a + (WADTORAY() / 2)) / WADTORAY();
}

rule rayToWadLiveness(uint256 a) {
    rayToWad@withrevert(a);

    assert lastReverted <=> false;
}

/// wadToRay ///

rule wadToRaySafety(uint256 a) {
    uint res = wadToRay(a);

    assert res == a * WADTORAY();
}

rule wadToRayLiveness(uint256 a) {
    wadToRay@withrevert(a);

    assert lastReverted <=> a * WADTORAY() > 2^256;
}

/// wadWeightedAvg ///

rule wadWeightedAvgSafety(uint256 x, uint256 y, uint256 p) {
    uint res = wadWeightedAvg(x, y, p);

    assert res == (x * (10^18 - p) + y * p + 10^18 / 2) / 10^18;
}

rule wadWeightedAvgLiveness(uint256 x, uint256 y, uint256 p) {
    wadWeightedAvg@withrevert(x, y, p);

    assert lastReverted <=> x * (10^18 - p) + y * p + 10^18 / 2 >= 2^256 || p > 10^18;
}

/// rayWeightedAvg ///

rule rayWeightedAvgSafety(uint256 x, uint256 y, uint256 w) {
    uint res = rayWeightedAvg(x, y, w);

    assert res == (x * (10^27 - w) + y * w + 10^27 / 2) / 10^27;
}

rule rayWeightedAvgLiveness(uint256 x, uint256 y, uint256 w) {
    rayWeightedAvg@withrevert(x, y, w);

    assert lastReverted <=> x * (10^27 - w) + y * w + 10^27 / 2 >= 2^256 || w > 10^27;
}
