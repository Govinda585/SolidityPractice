// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

/// @title Simple Storage for a Name
/// @author Govinda Bist
/// @notice A contract to set and retrieve a name
/// @dev Demonstrates storing a string in contract storage
contract SimpleStorageName {
    /// @notice The name stored on the blockchain
    /// @dev This is a public state variable automatically given a getter function
    string public name;

    /// @notice Emitted when the stored name is changed
    /// @param by The address that changed the name
    /// @param oldName The previous name stored
    /// @param newName The updated name provided by the user
    event NameChanged(address indexed by, string oldName, string newName);

    /// @notice Stores a new name in the contract
    /// @dev Uses memory for the string parameter because it's a temporary value
    /// @param _name The new name to store
    function set(string memory _name) public {
        emit NameChanged(msg.sender, name, _name);
        name = _name;
    }

    /// @notice Retrieves the stored name
    /// @dev A getter already exists automatically for public variables — this is for demonstration
    /// @return The current name stored in the contract
    function get() public view returns (string memory) {
        return name;
    }
}
