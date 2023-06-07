
methods {
    function minInt() external returns (int256) envfree;
    function maxInt() external returns (int256) envfree;
    function abs(int256) external returns (int256) envfree;
    function safeAbs(int256) external returns (int256) envfree;
    function min(uint256, uint256) external returns (uint256) envfree;
    function max(uint256, uint256) external returns (uint256) envfree;
    function zeroFloorSub(uint256, uint256) external returns (uint256) envfree;
    function divUp(uint256, uint256) external returns (uint256) envfree;
}

/// abs ///

rule absSafety(int256 a) {
    int256 res = abs(a);

    assert a >= 0 => res == a;
    assert a < 0 && a > minInt() => to_mathint(res) == -a;
    assert a == minInt() => res == maxInt();
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

    assert lastReverted <=> a == minInt();
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
