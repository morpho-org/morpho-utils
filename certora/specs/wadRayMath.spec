methods {
    function wadMul(uint256, uint256)                   external returns (uint256)       envfree;
    function wadMulDown(uint256, uint256)               external returns (uint256)       envfree;
    function wadMulUp(uint256, uint256)                 external returns (uint256)       envfree;
    function wadDiv(uint256, uint256)                   external returns (uint256)       envfree;
    function wadDivDown(uint256, uint256)               external returns (uint256)       envfree;
    function wadDivUp(uint256, uint256)                 external returns (uint256)       envfree;
    function rayMul(uint256, uint256)                   external returns (uint256)       envfree;
    function rayMulDown(uint256, uint256)               external returns (uint256)       envfree;
    function rayMulUp(uint256, uint256)                 external returns (uint256)       envfree;
    function rayDiv(uint256, uint256)                   external returns (uint256)       envfree;
    function rayDivDown(uint256, uint256)               external returns (uint256)       envfree;
    function rayDivUp(uint256, uint256)                 external returns (uint256)       envfree;
    function rayToWad(uint256)                          external returns (uint256)       envfree;
    function wadToRay(uint256)                          external returns (uint256)       envfree;
    function wadWeightedAvg(uint256, uint256, uint256)  external returns (uint256)       envfree;
    function rayWeightedAvg(uint256, uint256, uint256)  external returns (uint256)       envfree;
}

definition WAD()       returns uint = 10^18;
definition RAY()       returns uint = 10^27;
definition WADTORAY()  returns uint = 10^9;
definition UINT_LIMIT() returns mathint = 2 ^ 255 * 2;

/// wadMul ///

rule wadMulSafety(uint256 a, uint256 b) {
    uint res = wadMul(a, b);

    assert to_mathint(res) == (a * b + (WAD() / 2)) / WAD();
}

rule wadMulLiveness(uint256 a, uint256 b) {
    wadMul@withrevert(a, b);

    assert lastReverted <=> a * b + WAD() / 2 >= UINT_LIMIT();
}

/// wadMulDown ///

rule wadMulDownSafety(uint256 a, uint256 b) {
    uint res = wadMulDown(a, b);

    assert to_mathint(res) == (a * b) / WAD();
}

rule wadMulDownLiveness(uint256 a, uint256 b) {
    wadMulDown@withrevert(a, b);

    assert lastReverted <=> a * b >= UINT_LIMIT();
}

/// wadMulUp ///

rule wadMulUpSafety(uint256 a, uint256 b) {
    uint res = wadMulUp(a, b);

    assert to_mathint(res) == (a * b + (WAD() - 1)) / WAD();
}

rule wadMulUpLiveness(uint256 a, uint256 b) {
    wadMulUp@withrevert(a, b);

    assert lastReverted <=> a * b + WAD() - 1 >= UINT_LIMIT();
}

/// wadDiv ///

rule wadDivSafety(uint256 a, uint256 b) {
    uint res = wadDiv(a, b);

    assert to_mathint(res) == (a * WAD() + (b / 2)) / b;
}

rule wadDivLiveness(uint256 a, uint256 b) {
    wadDiv@withrevert(a, b);

    assert lastReverted <=> a * WAD() + b / 2 >= UINT_LIMIT() || b == 0;
}

/// wadDivDown ///

rule wadDivDownSafety(uint256 a, uint256 b) {
    uint res = wadDivDown(a, b);

    assert to_mathint(res) == (a * WAD()) / b;
}

rule wadDivDownLiveness(uint256 a, uint256 b) {
    wadDivDown@withrevert(a, b);

    assert lastReverted <=> a * WAD() >= UINT_LIMIT() || b == 0;
}

/// wadDivUp ///

rule wadDivUpSafety(uint256 a, uint256 b) {
    uint res = wadDivUp(a, b);

    assert to_mathint(res) == (a * WAD() + (b - 1)) / b;
}

rule wadDivUpLiveness(uint256 a, uint256 b) {
    wadDivUp@withrevert(a, b);

    assert lastReverted <=> a * WAD() + (b - 1) >= UINT_LIMIT() || b == 0;
}

/// rayMul ///

rule rayMulSafety(uint256 a, uint256 b) {
    uint res = rayMul(a, b);

    assert to_mathint(res) == (a * b + (RAY() / 2)) / RAY();
}

rule rayMulLiveness(uint256 a, uint256 b) {
    rayMul@withrevert(a, b);

    assert lastReverted <=> a * b + RAY() / 2 >= UINT_LIMIT();
}

/// rayMulDown ///

rule rayMulDownSafety(uint256 a, uint256 b) {
    uint res = rayMulDown(a, b);

    assert to_mathint(res) == (a * b) / RAY();
}

rule rayMulDownLiveness(uint256 a, uint256 b) {
    rayMulDown@withrevert(a, b);

    assert lastReverted <=> a * b >= UINT_LIMIT();
}

/// rayMulUp ///

rule rayMulUpSafety(uint256 a, uint256 b) {
    uint res = rayMulUp(a, b);

    assert to_mathint(res) == (a * b + (RAY() - 1)) / RAY();
}

rule rayMulUpLiveness(uint256 a, uint256 b) {
    rayMulUp@withrevert(a, b);

    assert lastReverted <=> a * b + RAY() - 1 >= UINT_LIMIT();
}

/// rayDiv ///

rule rayDivSafety(uint256 a, uint256 b) {
    uint res = rayDiv(a, b);

    assert to_mathint(res) == (a * RAY() + (b / 2)) / b;
}

rule rayDivLiveness(uint256 a, uint256 b) {
    rayDiv@withrevert(a, b);

    assert lastReverted <=> a * RAY() + b / 2 >= UINT_LIMIT() || b == 0;
}

/// rayDivDown ///

rule rayDivDownSafety(uint256 a, uint256 b) {
    uint res = rayDivDown(a, b);

    assert to_mathint(res) == (a * RAY()) / b;
}

rule rayDivDownLiveness(uint256 a, uint256 b) {
    rayDivDown@withrevert(a, b);

    assert lastReverted <=> a * RAY() >= UINT_LIMIT() || b == 0;
}

/// rayDivUp ///

rule rayDivUpSafety(uint256 a, uint256 b) {
    uint res = rayDivUp(a, b);

    assert to_mathint(res) == (a * RAY() + (b - 1)) / b;
}

rule rayDivUpLiveness(uint256 a, uint256 b) {
    rayDivUp@withrevert(a, b);

    assert lastReverted <=> a * RAY() + (b - 1) >= UINT_LIMIT() || b == 0;
}

/// rayToWad ///

rule rayToWadSafety(uint256 a) {
    uint res = rayToWad(a);

    assert to_mathint(res) == (a + (WADTORAY() / 2)) / WADTORAY();
}

rule rayToWadLiveness(uint256 a) {
    rayToWad@withrevert(a);

    assert lastReverted <=> false;
}

/// wadToRay ///

rule wadToRaySafety(uint256 a) {
    uint res = wadToRay(a);

    assert to_mathint(res) == a * WADTORAY();
}

rule wadToRayLiveness(uint256 a) {
    wadToRay@withrevert(a);

    assert lastReverted <=> a * WADTORAY() >= UINT_LIMIT();
}

/// wadWeightedAvg ///

rule wadWeightedAvgSafety(uint256 x, uint256 y, uint256 w) {
    uint res = wadWeightedAvg(x, y, w);

    assert to_mathint(res) == (x * (WAD() - w) + y * w + WAD() / 2) / WAD();
}

rule wadWeightedAvgLiveness(uint256 x, uint256 y, uint256 w) {
    wadWeightedAvg@withrevert(x, y, w);

    assert lastReverted <=> x * (WAD() - w) + y * w + WAD() / 2 >= UINT_LIMIT() || w > WAD();
}

/// rayWeightedAvg ///

rule rayWeightedAvgSafety(uint256 x, uint256 y, uint256 w) {
    uint res = rayWeightedAvg(x, y, w);

    assert to_mathint(res) == (x * (RAY() - w) + y * w + RAY() / 2) / RAY();
}

rule rayWeightedAvgLiveness(uint256 x, uint256 y, uint256 w) {
    rayWeightedAvg@withrevert(x, y, w);

    assert lastReverted <=> x * (RAY() - w) + y * w + RAY() / 2 >= UINT_LIMIT() || w > RAY();
}
