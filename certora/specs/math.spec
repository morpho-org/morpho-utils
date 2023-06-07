
methods {
    abs(int256)                     returns (int256)        envfree
    safeAbs(int256)                 returns (int256)        envfree
    min(uint256, uint256)           returns (uint256)       envfree
    max(uint256, uint256)           returns (uint256)       envfree
    zeroFloorSub(uint256, uint256)  returns (uint256)       envfree
    divUp(uint256, uint256)         returns (uint256)       envfree
}

/// abs ///
definition MAX_INT256() returns int256 = 0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff;
definition MIN_INT256() returns int256 = 0x8000000000000000000000000000000000000000000000000000000000000000;

rule absSafety(int256 a) {
    mathint res = to_mathint(abs(a));

    assert a >= 0 => res == to_mathint(a);
    assert a < 0 && a > MIN_INT256() => res == -to_mathint(a);
    assert a == MIN_INT256() => res == MAX_INT256();
}

rule absLiveness(int256 a) {
    abs@withrevert(a);

    assert lastReverted <=> false;
}

/// safeAbs ///

rule safeAbsSafety(int256 a) {
    mathint res = to_mathint(safeAbs(a));

    assert a >= 0 => res == to_mathint(a);
    assert a < 0 => res == -to_mathint(a);
}

rule safeAbsLiveness(int256 a) {
    safeAbs@withrevert(a);

    assert lastReverted <=> a == MIN_INT256();
}

/// min ///

rule minSafety(uint256 a, uint256 b) {
    uint res = min(a, b);

    assert a <= b => res == a;
    assert a > b => res == b;
}

rule minLiveness(uint256 a, uint256 b) {
    min@withrevert(a, b);

    assert lastReverted <=> false;
}

/// max ///

rule maxSafety(uint256 a, uint256 b) {
    uint res = max(a, b);

    assert a >= b => res == a;
    assert a < b => res == b;
}

rule maxLiveness(uint256 a, uint256 b) {
    max@withrevert(a, b);

    assert lastReverted <=> false;
}

/// zeroFloorSub ///

rule zeroFloorSubSafety(uint256 a, uint256 b) {
    uint res = zeroFloorSub(a, b);

    assert a >= b => res == a - b;
    assert a < b => res == 0;
}

rule zeroFloorSubLiveness(uint256 a, uint256 b) {
    zeroFloorSub@withrevert(a, b);

    assert lastReverted <=> false;
}

/// divUp ///

rule divUpSafety(uint256 a, uint256 b) {
    uint res = divUp(a, b);

    assert a % b == 0 => res == a / b;
    assert a % b != 0 => res == a / b + 1;
}

rule divUpLiveness(uint256 a, uint256 b) {
    divUp@withrevert(a, b);

    assert lastReverted <=> b == 0;
}
