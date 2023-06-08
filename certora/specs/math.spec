
methods {
    function min(uint256, uint256)           external returns (uint256)       envfree;
    function max(uint256, uint256)           external returns (uint256)       envfree;
    function zeroFloorSub(uint256, uint256)  external returns (uint256)       envfree;
    function divUp(uint256, uint256)         external returns (uint256)       envfree;
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
