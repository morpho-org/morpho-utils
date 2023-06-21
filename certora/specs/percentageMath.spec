methods {
    function percentAdd(uint256, uint256) external returns (uint256) envfree;
    function percentSub(uint256, uint256) external returns (uint256) envfree;
    function percentMul(uint256, uint256) external returns (uint256) envfree;
    function percentMulDown(uint256, uint256) external returns (uint256) envfree;
    function percentMulUp(uint256, uint256) external returns (uint256) envfree;
    function percentDiv(uint256, uint256) external returns (uint256) envfree;
    function percentDivDown(uint256, uint256) external returns (uint256) envfree;
    function percentDivUp(uint256, uint256) external returns (uint256) envfree;
    function weightedAvg(uint256, uint256, uint256) external returns (uint256) envfree;
}

definition PERCENTAGE_FACTOR() returns uint = 10^4;
definition UINT_LIMIT() returns mathint = 2 ^ 255 * 2;

/// percentAdd ///

rule percentAddSafety(uint256 x, uint256 p) {
    uint res = percentAdd(x, p);

    assert to_mathint(res) == (x * (PERCENTAGE_FACTOR() + p) + PERCENTAGE_FACTOR() / 2) / PERCENTAGE_FACTOR();
}

rule percentAddLiveness(uint256 x, uint256 p) {
    percentAdd@withrevert(x, p);

    // The first condition does not imply the second one because x can be zero.
    assert lastReverted <=> PERCENTAGE_FACTOR() + p >= UINT_LIMIT() || x * (PERCENTAGE_FACTOR() + p) + PERCENTAGE_FACTOR() / 2 >= UINT_LIMIT();
}

/// percentSub ///

rule percentSubSafety(uint256 x, uint256 p) {
    uint res = percentSub(x, p);

    assert to_mathint(res) == (x * (PERCENTAGE_FACTOR() - p) + PERCENTAGE_FACTOR() / 2) / PERCENTAGE_FACTOR();
}

rule percentSubLiveness(uint256 x, uint256 p) {
    percentSub@withrevert(x, p);

    assert lastReverted <=> x * (PERCENTAGE_FACTOR() - p) + PERCENTAGE_FACTOR() / 2 >= UINT_LIMIT() || p > PERCENTAGE_FACTOR();
}

/// percentMul ///

rule percentMulSafety(uint256 x, uint256 p) {
    uint res = percentMul(x, p);

    assert to_mathint(res) == (x * p + PERCENTAGE_FACTOR() / 2) / PERCENTAGE_FACTOR();
}

rule percentMulLiveness(uint256 x, uint256 p) {
    percentMul@withrevert(x, p);

    assert lastReverted <=> x * p + PERCENTAGE_FACTOR() / 2 >= UINT_LIMIT();
}

/// percentMulDown ///

rule percentMulDownSafety(uint256 a, uint256 p) {
    uint res = percentMulDown(a, p);

    assert to_mathint(res) == (a * p) / PERCENTAGE_FACTOR();
}

rule percentMulDownLiveness(uint256 a, uint256 p) {
    percentMulDown@withrevert(a, p);

    assert lastReverted <=> a * p >= UINT_LIMIT();
}

/// percentMulUp ///

rule percentMulUpSafety(uint256 a, uint256 p) {
    uint res = percentMulUp(a, p);

    assert to_mathint(res) == (a * p + (PERCENTAGE_FACTOR() - 1)) / PERCENTAGE_FACTOR();
}

rule percentMulUpLiveness(uint256 a, uint256 p) {
    percentMulUp@withrevert(a, p);

    assert lastReverted <=> a * p + PERCENTAGE_FACTOR() - 1 >= UINT_LIMIT();
}

/// percentDiv ///

rule percentDivSafety(uint256 x, uint256 p) {
    uint res = percentDiv(x, p);

    assert to_mathint(res) == (x * PERCENTAGE_FACTOR() + p / 2) / p;
}

rule percentDivLiveness(uint256 x, uint256 p) {
    percentDiv@withrevert(x, p);

    assert lastReverted <=> x * PERCENTAGE_FACTOR() + p / 2 >= UINT_LIMIT() || p == 0;
}

/// percentDivDown ///

rule percentDivDownSafety(uint256 a, uint256 p) {
    uint res = percentDivDown(a, p);

    assert to_mathint(res) == (a * PERCENTAGE_FACTOR()) / p;
}

rule percentDivDownLiveness(uint256 a, uint256 p) {
    percentDivDown@withrevert(a, p);

    assert lastReverted <=> a * PERCENTAGE_FACTOR() >= UINT_LIMIT() || p == 0;
}

/// percentDivUp ///

rule percentDivUpSafety(uint256 a, uint256 p) {
    uint res = percentDivUp(a, p);

    assert to_mathint(res) == (a * PERCENTAGE_FACTOR() + (p - 1)) / p;
}

rule percentDivUpLiveness(uint256 a, uint256 p) {
    percentDivUp@withrevert(a, p);

    assert lastReverted <=> a * PERCENTAGE_FACTOR() + (p - 1) >= UINT_LIMIT() || p == 0;
}

/// weightedAvg ///

rule weightedAvgSafety(uint256 x, uint256 y, uint256 p) {
    uint res = weightedAvg(x, y, p);

    assert to_mathint(res) == (x * (PERCENTAGE_FACTOR() - p) + y * p + PERCENTAGE_FACTOR() / 2) / PERCENTAGE_FACTOR();
}

rule weightedAvgLiveness(uint256 x, uint256 y, uint256 p) {
    weightedAvg@withrevert(x, y, p);

    assert lastReverted <=> x * (PERCENTAGE_FACTOR() - p) + y * p + PERCENTAGE_FACTOR() / 2 >= UINT_LIMIT() || p > PERCENTAGE_FACTOR();
}
