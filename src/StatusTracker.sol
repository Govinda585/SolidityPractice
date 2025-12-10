// SPDX-License-Identifier: MIT

pragma solidity ^0.8.30;
// Create a contract with an enum for status: Pending, Completed, Inactive.

contract StatusTracker {
    enum Status {
        Pending,
        Active,
        Inactive
    }
    Status public status;
    address public immutable owner;
    uint256 public lastUpdated;
    event StatusChanged(
        address indexed by,
        Status indexed oldStatus,
        Status newStatus,
        uint256 timestamp
    );

    constructor() {
        owner = msg.sender;
        status = Status.Pending;
        lastUpdated = block.timestamp;
        emit StatusChanged(
            address(0),
            Status.Pending,
            Status.Pending,
            block.timestamp
        );
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Not owner");
        _;
    }

    function activate() public onlyOwner {
        require(status == Status.Pending, "Must be Pending");
        _setStatus(Status.Active);
    }
    function deactivate() public onlyOwner {
        _setStatus(Status.Inactive);
    }
    function _setStatus(Status _newStatus) private {
        Status old = status;
        if (old == _newStatus) return;

        status = _newStatus;
        lastUpdated = block.timestamp;
        emit StatusChanged(msg.sender, old, _newStatus, block.timestamp);
    }

    function isPending() public view returns (bool) {
        return status == Status.Pending;
    }
    function isActive() public view returns (bool) {
        return status == Status.Active;
    }
    function isInactive() public view returns (bool) {
        return status == Status.Inactive;
    }

    /// @notice Return status as string (for UI/debugging)
    function getStatusString() public view returns (string memory) {
        if (status == Status.Pending) return "Pending";
        if (status == Status.Active) return "Active";
        return "Inactive";
    }
}
