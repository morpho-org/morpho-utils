
methods {
    min(uint256, uint256)           returns (uint256)       envfree
    max(uint256, uint256)           returns (uint256)       envfree
    zeroFloorSub(uint256, uint256)  returns (uint256)       envfree
    divUp(uint256, uint256)         returns (uint256)       envfree
}

/// min ///

rule minSafety(uint256 a, uint256 b) {
    uint res = min(a, b);

    if a <= b {
        assert res == a;
    } else {
        assert res == b;
    }
}

rule minLiveness(uint256 a, uint256 b) {
    min@withrevert(a, b);

    assert lastReverted <=> false;
}

/// max ///

rule maxSafety(uint256 a, uint256 b) {
    uint res = max(a, b);

    if a >= b {
        assert res == a;
    } else {
        assert res == b;
    }
}

rule maxLiveness(uint256 a, uint256 b) {
    max@withrevert(a, b);

    assert lastReverted <=> false;
}

/// zeroFloorSub ///

rule zeroFloorSubSafety(uint256 a, uint256 b) {
    uint res = zeroFloorSub(a, b);

    if a >= b {
        assert res == a - b;
    } else {
        assert res == 0;
    }
}

rule zeroFloorSubLiveness(uint256 a, uint256 b) {
    zeroFloorSub@withrevert(a, b);

    assert lastReverted <=> false;
}

/// divUp ///

rule divUpSafety(uint256 a, uint256 b) {
    uint res = divUp(a, b);

    if a % b == 0 {
        assert res == a / b;
    } else {
        assert res == a / b + 1;
    }
}

rule divUpLiveness(uint256 a, uint256 b) {
    divUp@withrevert(a, b);
    
    assert lastReverted <=> b == 0;
}
