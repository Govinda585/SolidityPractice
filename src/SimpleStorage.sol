// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

/// @title Simple Storage
/// @author Govinda Bist
/// @notice A minimal contract to store and retrieve a single uint256 value
/// @dev Perfect starting project for learning Solidity storage basics
contract SimpleStorage {
    /// @notice Stores a single unsigned integer
    /// @dev Public variable automatically gets a getter function
    uint256 public myNumber;

    /// @notice Stores any uint256 number in the contract
    /// @param _myNumber The number to store
    function store(uint256 _myNumber) public {
        myNumber = _myNumber;
    }

    /// @notice Retrieves the currently stored number
    /// @return The stored number
    /// @dev This function is redundant because myNumber is public,
    ///      but kept for educational purposes and explicitness
    function retrieve() public view returns (uint256) {
        return myNumber;
    }
}
