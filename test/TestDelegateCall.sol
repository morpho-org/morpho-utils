// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "forge-std/Test.sol";
import "src/DelegateCall.sol";

contract Caller {
    using DelegateCall for address;

    address public immutable called;
    uint256 public x = 2;

    constructor(address _called) {
        called = _called;
    }

    function delegateCall() external returns (uint256) {
        bytes memory data = called.functionDelegateCall(abi.encodeWithSelector(Called.number.selector, ""));
        return abi.decode(data, (uint256));
    }
}

contract Called {
    uint256 public x;

    function number() external view returns (uint256) {
        return x;
    }
}

contract TestDelegateCall is Test {
    Called called;
    Caller caller;

    function setUp() public {
        called = new Called();
        caller = new Caller(address(called));
    }

    function testDelegateCall() public {
        assertEq(caller.delegateCall(), caller.x());
    }
}
