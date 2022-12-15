methods {
    percentAdd(uint256, uint256)            returns (uint256)   envfree
    percentSub(uint256, uint256)            returns (uint256)   envfree
    percentMul(uint256, uint256)            returns (uint256)   envfree
    percentMulDown(uint256, uint256)        returns (uint256)   envfree
    percentMulUp(uint256, uint256)          returns (uint256)   envfree
    percentDiv(uint256, uint256)            returns (uint256)   envfree
    percentDivDown(uint256, uint256)        returns (uint256)   envfree
    percentDivUp(uint256, uint256)          returns (uint256)   envfree
    weightedAvg(uint256, uint256, uint256)  returns (uint256)   envfree
}

definition PERCENTAGE_FACTOR()   returns uint = 10^4;

/// percentAdd ///

rule percentAddSafety(uint256 x, uint256 p) {
    uint res = percentAdd(x, p);

    assert res == (x * (PERCENTAGE_FACTOR() + p) + PERCENTAGE_FACTOR() / 2) / PERCENTAGE_FACTOR();
}

rule percentAddLiveness(uint256 x, uint256 p) {
    percentAdd@withrevert(x, p);

    // The first condition does not imply the second one because x can be zero.
    assert lastReverted <=> PERCENTAGE_FACTOR() + p >= 2^256 || x * (PERCENTAGE_FACTOR() + p) + PERCENTAGE_FACTOR() / 2 >= 2^256;
}

/// percentSub ///

rule percentSubSafety(uint256 x, uint256 p) {
    uint res = percentSub(x, p);

    assert res == (x * (PERCENTAGE_FACTOR() - p) + PERCENTAGE_FACTOR() / 2) / PERCENTAGE_FACTOR();
}

rule percentSubLiveness(uint256 x, uint256 p) {
    percentSub@withrevert(x, p);

    assert lastReverted <=> x * (PERCENTAGE_FACTOR() - p) + PERCENTAGE_FACTOR() / 2 >= 2^256 || p > PERCENTAGE_FACTOR();
}

/// percentMul ///

rule percentMulSafety(uint256 x, uint256 p) {
    uint res = percentMul(x, p);

    assert res == (x * p + PERCENTAGE_FACTOR() / 2) / PERCENTAGE_FACTOR();
}

rule percentMulLiveness(uint256 x, uint256 p) {
    percentMul@withrevert(x, p);

    assert lastReverted <=> x * p + PERCENTAGE_FACTOR() / 2 >= 2^256;
}

/// percentMulDown ///

rule percentMulDownSafety(uint256 a, uint256 b) {
    uint res = percentMulDown(a, b);

    assert res == (a * b) / PERCENTAGE_FACTOR();
}

rule percentMulDownLiveness(uint256 a, uint256 b) {
    percentMulDown@withrevert(a, b);

    assert lastReverted <=> a * b >= 2^256;
}

/// percentMulUp ///

rule percentMulUpSafety(uint256 a, uint256 b) {
    uint res = percentMulUp(a, b);

    assert res == (a * b + (PERCENTAGE_FACTOR() - 1)) / PERCENTAGE_FACTOR();
}

rule percentMulUpLiveness(uint256 a, uint256 b) {
    percentMulUp@withrevert(a, b);

    assert lastReverted <=> a * b + PERCENTAGE_FACTOR() - 1 >= 2^256;
}

/// percentDiv ///

rule percentDivSafety(uint256 x, uint256 p) {
    uint res = percentDiv(x, p);

    assert res == (x * PERCENTAGE_FACTOR() + p / 2) / p;
}

rule percentDivLiveness(uint256 x, uint256 p) {
    percentDiv@withrevert(x, p);

    assert lastReverted <=> x * PERCENTAGE_FACTOR() + p / 2 >= 2^256 || p == 0;
}

/// percentDivDown ///

rule percentDivDownSafety(uint256 a, uint256 b) {
    uint res = percentDivDown(a, b);

    assert res == (a * PERCENTAGE_FACTOR()) / b;
}

rule percentDivDownLiveness(uint256 a, uint256 b) {
    percentDivDown@withrevert(a, b);

    assert lastReverted <=> a * PERCENTAGE_FACTOR() >= 2^256 || b == 0;
}

/// percentDivUp ///

rule percentDivUpSafety(uint256 a, uint256 b) {
    uint res = percentDivUp(a, b);

    assert res == (a * PERCENTAGE_FACTOR() + (b - 1)) / b;
}

rule percentDivUpLiveness(uint256 a, uint256 b) {
    percentDivUp@withrevert(a, b);

    assert lastReverted <=> a * PERCENTAGE_FACTOR() + (b - 1) >= 2^256 || b == 0;
}

/// weightedAvg ///

rule weightedAvgSafety(uint256 x, uint256 y, uint256 p) {
    uint res = weightedAvg(x, y, p);

    assert res == (x * (PERCENTAGE_FACTOR() - p) + y * p + PERCENTAGE_FACTOR() / 2) / PERCENTAGE_FACTOR();
}

rule weightedAvgLiveness(uint256 x, uint256 y, uint256 p) {
    weightedAvg@withrevert(x, y, p);

    assert lastReverted <=> x * (PERCENTAGE_FACTOR() - p) + y * p + PERCENTAGE_FACTOR() / 2 >= 2^256 || p > PERCENTAGE_FACTOR();
}
