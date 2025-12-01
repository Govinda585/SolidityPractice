// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

/// @title Simple Counter
/// @author Govinda Bist
/// @notice A basic counter that can be increased or decreased by 1
/// @dev Demonstrates state variables, events, and safe state updates
contract SimpleCounter {
    /// @notice Current counter value (starts at 0)
    uint256 public number;

    /// @notice Emitted when the counter is increased
    /// @param by The address that called increase()
    /// @param amount Amount added (always 1 in this version)
    /// @param newValue The counter value after increase
    event Increased(address indexed by, uint256 amount, uint256 newValue);

    /// @notice Emitted when the counter is decreased
    /// @param by The address that called decrease()
    /// @param amount Amount subtracted (always 1 in this version)
    /// @param newValue The counter value after decrease
    event Decreased(address indexed by, uint256 amount, uint256 newValue);

    /// @notice Increases the counter by 1
    /// @dev Emits Increased event with full details
    function increase() public {
        number += 1;
        emit Increased(msg.sender, 1, number);
    }

    /// @notice Decreases the counter by 1
    /// @dev Emits Decreased event with full details
    function decrease() public {
        require(number >= 1, "Cannot go negative");
        number -= 1;
        emit Decreased(msg.sender, 1, number);
    }

    /// @notice Increases counter by any amount
    /// @param amount How many to add
    function increaseBy(uint256 amount) public {
        require(amount > 0, "Amount must be > 0");
        number += amount;
        emit Increased(msg.sender, amount, number);
    }

    /// @notice Decreases counter by any amount
    /// @param amount How many to subtract
    function decreaseBy(uint256 amount) public {
        require(amount > 0, "Amount must be > 0");
        require(number >= amount, "Cannot go negative");
        number -= amount;
        emit Decreased(msg.sender, amount, number);
    }
}
