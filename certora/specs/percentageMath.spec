methods {
    percentAdd(uint256, uint256)            returns (uint256)   envfree
    percentSub(uint256, uint256)            returns (uint256)   envfree
    percentMul(uint256, uint256)            returns (uint256)   envfree
    percentDiv(uint256, uint256)            returns (uint256)   envfree
    weightedAvg(uint256, uint256, uint256)  returns (uint256)   envfree
}

/// percentAdd ///

rule percentAddSafety(uint256 x, uint256 p) {
    uint res = percentAdd(x, p);

    assert res == (x * (10^4 + p) + 10^4 / 2) / 10^4;
}

rule percentAddLiveness(uint256 x, uint256 p) {
    percentAdd@withrevert(x, p);

    // The first condition does not imply the second one because x can be zero.
    assert lastReverted <=> 10^4 + p >= 2^256 || x * (10^4 + p) + 10^4 / 2 >= 2^256;
}

/// percentSub ///

rule percentSubSafety(uint256 x, uint256 p) {
    uint res = percentSub(x, p);

    assert res == (x * (10^4 - p) + 10^4 / 2) / 10^4;
}

rule percentSubLiveness(uint256 x, uint256 p) {
    percentSub@withrevert(x, p);

    assert lastReverted <=> x * (10^4 - p) + 10^4 / 2 >= 2^256 || p > 10^4;
}

/// percentMul ///

rule percentMulSafety(uint256 x, uint256 p) {
    uint res = percentMul(x, p);

    assert res == (x * p + 10^4 / 2) / 10^4;
}

rule percentMulLiveness(uint256 x, uint256 p) {
    percentMul@withrevert(x, p);

    assert lastReverted <=> x * p + 10^4 / 2 >= 2^256;
}

/// percentDiv ///

rule percentDivSafety(uint256 x, uint256 p) {
    uint res = percentDiv(x, p);

    assert res == (x * 10^4 + p / 2) / p;
}

rule percentDivLiveness(uint256 x, uint256 p) {
    percentDiv@withrevert(x, p);

    assert lastReverted <=> x * 10^4 + p / 2 >= 2^256 || p == 0;
}

/// weightedAvg ///

rule weightedAvgSafety(uint256 x, uint256 y, uint256 p) {
    uint res = weightedAvg(x, y, p);

    assert res == (x * (10^4 - p) + y * p + 10^4 / 2) / 10^4;
}

rule weightedAvgLiveness(uint256 x, uint256 y, uint256 p) {
    weightedAvg@withrevert(x, y, p);

    assert lastReverted <=> x * (10^4 - p) + y * p + 10^4 / 2 >= 2^256 || p > 10^4;
}
