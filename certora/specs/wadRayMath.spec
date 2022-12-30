methods {
    wadMul(uint256, uint256)                   returns (uint256)       envfree
    wadMulDown(uint256, uint256)               returns (uint256)       envfree
    wadMulUp(uint256, uint256)                 returns (uint256)       envfree
    wadDiv(uint256, uint256)                   returns (uint256)       envfree
    wadDivDown(uint256, uint256)               returns (uint256)       envfree
    wadDivUp(uint256, uint256)                 returns (uint256)       envfree
    rayMul(uint256, uint256)                   returns (uint256)       envfree
    rayMulDown(uint256, uint256)               returns (uint256)       envfree
    rayMulUp(uint256, uint256)                 returns (uint256)       envfree
    rayDiv(uint256, uint256)                   returns (uint256)       envfree
    rayDivDown(uint256, uint256)               returns (uint256)       envfree
    rayDivUp(uint256, uint256)                 returns (uint256)       envfree
    rayToWad(uint256)                          returns (uint256)       envfree
    wadToRay(uint256)                          returns (uint256)       envfree
    wadWeightedAvg(uint256, uint256, uint256)  returns (uint256)       envfree
    rayWeightedAvg(uint256, uint256, uint256)  returns (uint256)       envfree
}

definition WAD()       returns uint = 10^18;
definition RAY()       returns uint = 10^27;
definition WADTORAY()  returns uint = 10^9;

/// wadMul ///

rule wadMulSafety(uint256 a, uint256 b) {
    uint res = wadMul(a, b);

    assert res == (a * b + (WAD() / 2)) / WAD();
}

rule wadMulLiveness(uint256 a, uint256 b) {
    wadMul@withrevert(a, b);

    assert lastReverted <=> a * b + WAD() / 2 >= 2^256;
}

/// wadMulDown ///

rule wadMulDownSafety(uint256 a, uint256 b) {
    uint res = wadMulDown(a, b);

    assert res == (a * b) / WAD();
}

rule wadMulDownLiveness(uint256 a, uint256 b) {
    wadMulDown@withrevert(a, b);

    assert lastReverted <=> a * b >= 2^256;
}

/// wadMulUp ///

rule wadMulUpSafety(uint256 a, uint256 b) {
    uint res = wadMulUp(a, b);

    assert res == (a * b + (WAD() - 1)) / WAD();
}

rule wadMulUpLiveness(uint256 a, uint256 b) {
    wadMulUp@withrevert(a, b);

    assert lastReverted <=> a * b + WAD() - 1 >= 2^256;
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

/// wadDivDown ///

rule wadDivDownSafety(uint256 a, uint256 b) {
    uint res = wadDivDown(a, b);

    assert res == (a * WAD()) / b;
}

rule wadDivDownLiveness(uint256 a, uint256 b) {
    wadDivDown@withrevert(a, b);

    assert lastReverted <=> a * WAD() >= 2^256 || b == 0;
}

/// wadDivUp ///

rule wadDivUpSafety(uint256 a, uint256 b) {
    uint res = wadDivUp(a, b);

    assert res == (a * WAD() + (b - 1)) / b;
}

rule wadDivUpLiveness(uint256 a, uint256 b) {
    wadDivUp@withrevert(a, b);

    assert lastReverted <=> a * WAD() + (b - 1) >= 2^256 || b == 0;
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

/// rayMulDown ///

rule rayMulDownSafety(uint256 a, uint256 b) {
    uint res = rayMulDown(a, b);

    assert res == (a * b) / RAY();
}

rule rayMulDownLiveness(uint256 a, uint256 b) {
    rayMulDown@withrevert(a, b);

    assert lastReverted <=> a * b >= 2^256;
}

/// rayMulUp ///

rule rayMulUpSafety(uint256 a, uint256 b) {
    uint res = rayMulUp(a, b);

    assert res == (a * b + (RAY() - 1)) / RAY();
}

rule rayMulUpLiveness(uint256 a, uint256 b) {
    rayMulUp@withrevert(a, b);

    assert lastReverted <=> a * b + RAY() - 1 >= 2^256;
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

/// rayDivDown ///

rule rayDivDownSafety(uint256 a, uint256 b) {
    uint res = rayDivDown(a, b);

    assert res == (a * RAY()) / b;
}

rule rayDivDownLiveness(uint256 a, uint256 b) {
    rayDivDown@withrevert(a, b);

    assert lastReverted <=> a * RAY() >= 2^256 || b == 0;
}

/// rayDivUp ///

rule rayDivUpSafety(uint256 a, uint256 b) {
    uint res = rayDivUp(a, b);

    assert res == (a * RAY() + (b - 1)) / b;
}

rule rayDivUpLiveness(uint256 a, uint256 b) {
    rayDivUp@withrevert(a, b);

    assert lastReverted <=> a * RAY() + (b - 1) >= 2^256 || b == 0;
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

rule wadWeightedAvgSafety(uint256 x, uint256 y, uint256 w) {
    uint res = wadWeightedAvg(x, y, w);

    assert res == (x * (WAD() - w) + y * w + WAD() / 2) / WAD();
}

rule wadWeightedAvgLiveness(uint256 x, uint256 y, uint256 w) {
    wadWeightedAvg@withrevert(x, y, w);

    assert lastReverted <=> x * (WAD() - w) + y * w + WAD() / 2 >= 2^256 || w > WAD();
}

/// rayWeightedAvg ///

rule rayWeightedAvgSafety(uint256 x, uint256 y, uint256 w) {
    uint res = rayWeightedAvg(x, y, w);

    assert res == (x * (RAY() - w) + y * w + RAY() / 2) / RAY();
}

rule rayWeightedAvgLiveness(uint256 x, uint256 y, uint256 w) {
    rayWeightedAvg@withrevert(x, y, w);

    assert lastReverted <=> x * (RAY() - w) + y * w + RAY() / 2 >= 2^256 || w > RAY();
}
