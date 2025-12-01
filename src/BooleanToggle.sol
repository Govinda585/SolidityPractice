// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

/// @title Boolean Flag Toggle
/// @author Govinda Bist
/// @notice Simple contract with a toggleable boolean flag + events
/// @dev Perfect for learning state changes, events and NatSpec best practices
contract BooleanToggle {
    /// @notice Current state of the flag (default: false)
    bool public isActive;

    /// @notice Emitted every time the flag state changes
    /// @param by The address that triggered the change
    /// @param newState The new value of the flag after the change
    event FlagToggled(address indexed by, bool indexed newState);

    /// @notice Toggles the flag (true → false or false → true)
    /// @dev Emits FlagToggled with the resulting state
    function toggle() public {
        isActive = !isActive;
        emit FlagToggled(msg.sender, isActive);
    }

    /// @notice Sets the flag to true
    /// @dev Only emits event if state actually changes (optional optimization)
    function turnOn() public {
        if (!isActive) {
            isActive = true;
            emit FlagToggled(msg.sender, true);
        }
    }

    /// @notice Sets the flag to false
    /// @dev Only emits event if state actually changes
    function turnOff() public {
        if (isActive) {
            isActive = false;
            emit FlagToggled(msg.sender, false);
        }
    }

    /// @notice Returns the current flag state
    /// @return True if the flag is active, false otherwise
    function getStatus() public view returns (bool) {
        return isActive;
    }
}
