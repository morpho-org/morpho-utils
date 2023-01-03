methods {
    mul(uint256, uint256)   returns (uint256)   envfree
    div(uint256, uint256)   returns (uint256)   envfree
}

definition WAD()  returns uint = 10^18;

/// mul ///

rule mulSafety(uint256 x, uint256 y) {
    uint res = mul(x, y);

    assert res == x * y / WAD(); 
}

rule mulLiveness(uint256 x, uint256 y) {
    mul@withrevert(x, y);

    assert lastReverted <=> x * y >= 2^256;
}

/// div ///

rule divSafety(uint256 x, uint256 y) {
    uint res = div(x, y);

    assert res == x * WAD() / y; 
}

rule divLiveness(uint256 x, uint256 y) {
    div@withrevert(x, y);

    assert lastReverted <=> x * WAD() >= 2^256 || y == 0;
}
