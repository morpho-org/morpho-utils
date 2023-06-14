methods {
    function abs(int256) external returns (int256) envfree;
    function safeAbs(int256) external returns (int256) envfree;
    function zeroFloorSub(uint256, uint256) external returns (uint256) envfree;
    function divUp(uint256, uint256) external returns (uint256) envfree;
}

definition MIN_INT256() returns int256 = -2^255;
definition MAX_INT256() returns int256 = 2^255 - 1;

/// abs ///

rule absSafety(int256 a) {
    int256 res = abs(a);

    assert a >= 0 => res == a;
    assert a < 0 && a > MIN_INT256() => to_mathint(res) == -a;
    assert a == MIN_INT256() => res == MAX_INT256();
}

rule absLiveness(int256 a) {
    abs@withrevert(a);

    assert lastReverted <=> false;
}

/// safeAbs ///

rule safeAbsSafety(int256 a) {
    int256 res = safeAbs(a);

    assert a >= 0 => res == a;
    assert a < 0 => to_mathint(res) == -a;
}

rule safeAbsLiveness(int256 a) {
    safeAbs@withrevert(a);

    assert lastReverted <=> a == MIN_INT256();
}


/// zeroFloorSub ///

rule zeroFloorSubSafety(uint256 a, uint256 b) {
    uint res = zeroFloorSub(a, b);

    assert a >= b => to_mathint(res) == a - b;
    assert a < b => res == 0;
}

rule zeroFloorSubLiveness(uint256 a, uint256 b) {
    zeroFloorSub@withrevert(a, b);

    assert lastReverted <=> false;
}

/// divUp ///

rule divUpSafety(uint256 a, uint256 b) {
    uint res = divUp(a, b);

    assert a % b == 0 => to_mathint(res) == a / b;
    assert a % b != 0 => to_mathint(res) == a / b + 1;
}

rule divUpLiveness(uint256 a, uint256 b) {
    divUp@withrevert(a, b);

    assert lastReverted <=> b == 0;
}
