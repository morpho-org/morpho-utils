methods {
    function min(uint256, uint256) external returns (uint256) envfree;
    function max(uint256, uint256) external returns (uint256) envfree;
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
