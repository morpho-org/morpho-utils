methods {
    function mul(uint256, uint256) external returns (uint256) envfree;
    function div(uint256, uint256) external returns (uint256) envfree;
}

definition WAD() returns uint = 10^18;

/// mul ///

rule mulSafety(uint256 x, uint256 y) {
    uint res = mul(x, y);

    assert to_mathint(res) == x * y / WAD();
}

rule mulLiveness(uint256 x, uint256 y) {
    mul@withrevert(x, y);

    assert lastReverted <=> x * y >= 2^256;
}

/// div ///

rule divSafety(uint256 x, uint256 y) {
    uint res = div(x, y);

    assert to_mathint(res) == x * WAD() / y;
}

rule divLiveness(uint256 x, uint256 y) {
    div@withrevert(x, y);

    assert lastReverted <=> x * WAD() >= 2^256 || y == 0;
}
