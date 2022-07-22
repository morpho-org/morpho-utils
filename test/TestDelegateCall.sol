// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "forge-std/Vm.sol";
import "forge-std/Test.sol";
import "src/DelegateCall.sol";
import "openzeppelin-contracts/contracts/utils/Address.sol";

contract Caller {
    using DelegateCall for address;

    address public immutable called;
    uint256 public x = 2;

    constructor(address _called) {
        called = _called;
    }

    function delegateCall(bytes4 _selector) external returns (uint256) {
        bytes memory data = called.functionDelegateCall(abi.encodeWithSelector(_selector, ""));
        return abi.decode(data, (uint256));
    }
}

contract CallerRef {
    using Address for address;

    address public immutable called;
    uint256 public x = 2;

    constructor(address _called) {
        called = _called;
    }

    function delegateCall(bytes4 _selector) external returns (uint256) {
        bytes memory data = called.functionDelegateCall(abi.encodeWithSelector(_selector, ""));
        return abi.decode(data, (uint256));
    }
}

contract Called {
    uint256 public x;

    error DelegateCallError();

    function number() external view returns (uint256) {
        return x;
    }

    function revertWithoutError() external pure {
        revert();
    }

    function revertWithError() external pure {
        require(false, "delegatecall-error");
    }

    function revertWithCustomError() external pure {
        revert DelegateCallError();
    }
}

contract TestDelegateCall is Test {
    Called called;
    Caller caller;
    CallerRef callerRef;

    function setUp() public {
        called = new Called();
        caller = new Caller(address(called));
        callerRef = new CallerRef(address(called));
    }

    /// TESTS ///

    function testDelegateCall() public {
        assertEq(caller.delegateCall(Called.number.selector), caller.x());
    }

    function testRevertWithoutError() public {
        vm.expectRevert(abi.encodeWithSelector(DelegateCall.LowLevelDelegateCallFailed.selector));
        caller.delegateCall(Called.revertWithoutError.selector);
    }

    function testRevertWithError() public {
        vm.expectRevert("delegatecall-error");
        caller.delegateCall(Called.revertWithError.selector);
    }

    function testRevertWithCustomError() public {
        vm.expectRevert(abi.encodeWithSelector(Called.DelegateCallError.selector));
        caller.delegateCall(Called.revertWithCustomError.selector);
    }

    /// GAS COMPARISONS ///

    function testGasDelegateCall() public {
        caller.delegateCall(Called.number.selector);
        callerRef.delegateCall(Called.number.selector);
    }
}
