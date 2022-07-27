// SPDX-License-Identifier: GNU AGPLv3
pragma solidity ^0.8.0;

/// @title Delegate Call Library.
/// @author Morpho Labs - MEP.
/// @custom:contact security@morpho.xyz
/// @dev Low-level YUL delegate call library.
library DelegateCall {
    /// ERRORS ///

    /// @notice Thrown when a low delegate call has failed without error message.
    error LowLevelDelegateCallFailed();
    bytes4 constant LowLevelDelegateCallFailedError = 0x06f7035e; // bytes4(keccak256("LowLevelDelegateCallFailed()"))

    /// INTERNAL ///

    /// @dev Performs a low-level delegate call to the `_target` contract.
    /// @dev Note: Unlike the OZ's library this function does not check if the `_target` is a contract. It is the responsibility of the caller to ensure that the `_target` is a contract.
    /// @param _target The address of the target contract.
    /// @param _data The data to pass to the function called on the target contract.
    /// @return returnData The return data from the function called on the target contract.
    function functionDelegateCall(address _target, bytes memory _data) internal returns (bytes memory returnData) {
        assembly {
            returnData := mload(0x40)

            // The bytes size is found at the bytes pointer memory address - the bytes data is found a slot further.
            if iszero(delegatecall(gas(), _target, add(_data, 0x20), mload(_data), 0, 0)) {
                if iszero(returndatasize()) {
                    mstore(returnData, LowLevelDelegateCallFailedError)
                    revert(returnData, 4)
                }

                returndatacopy(add(returnData, 0x20), 0, returndatasize())
                revert(add(returnData, 0x20), returndatasize())
            }

            mstore(returnData, returndatasize())
            returndatacopy(add(returnData, 0x20), 0, returndatasize())

            // Update the free memory pointer.
            mstore(0x40, add(add(returnData, 0x20), returndatasize()))
        }
    }
}
