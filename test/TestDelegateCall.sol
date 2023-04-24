// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.0;

import "forge-std/Vm.sol";
import "forge-std/Test.sol";
import "src/DelegateCall.sol";
import "openzeppelin-contracts/utils/Address.sol";

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

    function delegateCallAndReturnMemoryAndPointer(bytes4 _selector) external returns (bytes memory, bytes32) {
        bytes memory allMem;
        bytes32 ptr;
        assembly {
            ptr := mload(0x40)
            // We write a slot in the memory before the call.
            mstore(ptr, 0xbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb)
            mstore(0x40, add(ptr, 0x20))
        }

        called.functionDelegateCall(abi.encodeWithSelector(_selector, ""));

        assembly {
            ptr := mload(0x40)
            // We write a slot in the memory after the call.
            mstore(ptr, 0xaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa)
            mstore(0x40, add(ptr, 0x20))
        }
        // We store the memory in allMem.
        assembly {
            ptr := mload(0x40)
            allMem := 0x00
            mstore(allMem, mload(0x40))
        }

        return (allMem, ptr);
    }
}

contract CallerRef {
    using Address for address;

    error LowLevelDelegateCallFailed();

    address public immutable called;
    uint256 public x = 2;

    constructor(address _called) {
        called = _called;
    }

    function delegateCall(bytes4 _selector) external returns (uint256) {
        bytes memory data = called.functionDelegateCall(abi.encodeWithSelector(_selector, ""));
        return abi.decode(data, (uint256));
    }

    function targetDelegateCallBehaviour(address _target, bytes memory _data) internal returns (bytes memory) {
        (bool success, bytes memory returndata) = _target.delegatecall(_data);
        if (success) {
            return returndata;
        } else {
            // Look for revert reason and bubble it up if present.
            if (returndata.length > 0) {
                // The easiest way to bubble the revert reason is using memory via assembly.
                assembly {
                    revert(add(32, returndata), mload(returndata))
                }
            } else {
                revert LowLevelDelegateCallFailed();
            }
        }
    }

    function targetDelegateCallBehaviourAndReturnMemoryAndPointer(bytes4 _selector)
        external
        returns (bytes memory, bytes32)
    {
        bytes memory allMem;
        bytes32 ptr;
        assembly {
            ptr := mload(0x40)
            mstore(ptr, 0xbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbbb)
            mstore(0x40, add(ptr, 0x20))
        }

        targetDelegateCallBehaviour(address(called), abi.encodeWithSelector(_selector, ""));

        assembly {
            ptr := mload(0x40)
            mstore(ptr, 0xaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa)
            mstore(0x40, add(ptr, 0x20))
        }

        assembly {
            ptr := mload(0x40)
            allMem := 0x00
            mstore(allMem, mload(0x40))
        }

        return (allMem, ptr);
    }
}

contract Called {
    uint256 public x;

    error DelegateCallError();

    function number() external view returns (uint256) {
        return x;
    }

    function returnBytes32() external pure returns (bytes32) {
        return "33333333333333333333333333333333";
    }

    function return40Bytes() external pure returns (bytes memory) {
        return "3333333333333333333333333333333333333333";
    }

    function return32Bytes() external pure returns (bytes memory) {
        return "33333333333333333333333333333333";
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

    function testMemoryUncorruptedWithRef() public {
        // This test makes sure that the delegateCall function of our library acts on the memory in the exact same way
        // as a targetBehaviour function corresponding to the desired behavior.
        bytes memory memoryReturned;
        bytes32 pointerReturned;
        bytes memory memoryReturnedRef;
        bytes32 pointerReturnedRef;

        (memoryReturned, pointerReturned) = caller.delegateCallAndReturnMemoryAndPointer(Called.number.selector);
        (memoryReturnedRef, pointerReturnedRef) =
            callerRef.targetDelegateCallBehaviourAndReturnMemoryAndPointer(Called.number.selector);
        assert(keccak256(memoryReturned) == keccak256(memoryReturnedRef));
        assert(pointerReturned == pointerReturnedRef);

        (memoryReturned, pointerReturned) = caller.delegateCallAndReturnMemoryAndPointer(Called.return40Bytes.selector);
        (memoryReturnedRef, pointerReturnedRef) =
            callerRef.targetDelegateCallBehaviourAndReturnMemoryAndPointer(Called.return40Bytes.selector);
        assert(keccak256(memoryReturned) == keccak256(memoryReturnedRef));
        assert(pointerReturned == pointerReturnedRef);

        (memoryReturned, pointerReturned) = caller.delegateCallAndReturnMemoryAndPointer(Called.return32Bytes.selector);
        (memoryReturnedRef, pointerReturnedRef) =
            callerRef.targetDelegateCallBehaviourAndReturnMemoryAndPointer(Called.return32Bytes.selector);
        assert(keccak256(memoryReturned) == keccak256(memoryReturnedRef));
        assert(pointerReturned == pointerReturnedRef);

        (memoryReturned, pointerReturned) = caller.delegateCallAndReturnMemoryAndPointer(Called.returnBytes32.selector);
        (memoryReturnedRef, pointerReturnedRef) =
            callerRef.targetDelegateCallBehaviourAndReturnMemoryAndPointer(Called.returnBytes32.selector);
        assert(keccak256(memoryReturned) == keccak256(memoryReturnedRef));
        assert(pointerReturned == pointerReturnedRef);
    }

    /// GAS COMPARISONS ///

    function testGasDelegateCall() public {
        caller.delegateCall(Called.number.selector);
        callerRef.delegateCall(Called.number.selector);
    }
}
