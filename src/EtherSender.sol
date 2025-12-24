// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

/// @title EtherSender
/// @notice A secure contract for sending and withdrawing Ether
/// @author
/// @dev Implements safe ETH transfers with atomic guarantees
contract EtherSender {
    address public owner;

    /// @notice Emitted when Ether is successfully sent
    event EtherSent(address indexed to, uint256 amount);

    /// @notice Emitted when Ether send fails (never happens in current implementation)
    // event EtherSendFailed(address indexed to, uint256 amount, bytes reason);

    /// @notice Restricts function to contract owner
    modifier onlyOwner() {
        require(msg.sender == owner, "No permission");
        _;
    }

    /// @notice Sets deployer as owner
    constructor() {
        owner = msg.sender;
    }

    /// @notice Send ETH to a specific address
    /// @param _to Recipient address
    /// @param _amount Amount of ETH in wei
    function sendEther(
        address payable _to,
        uint256 _amount
    ) external onlyOwner {
        require(_to != address(0), "Zero address not allowed");
        require(_amount > 0, "Amount must be > 0");
        require(
            address(this).balance >= _amount,
            "Insufficient contract balance"
        );

        _safeSend(_to, _amount);
    }

    /// @notice Withdraw all ETH from contract to a given address
    /// @param _to Recipient address
    function withdrawAll(address payable _to) external onlyOwner {
        uint256 fullBalance = address(this).balance;
        require(fullBalance > 0, "No Ether to withdraw");

        _safeSend(_to, fullBalance);
    }

    /// @notice Returns contract balance
    function getBalance() external view returns (uint256) {
        return address(this).balance;
    }

    /// @dev Performs a safe ETH transfer. Reverts if transfer fails
    function _safeSend(address payable _to, uint256 _amount) private {
        (bool success, ) = _to.call{value: _amount}("");
        require(success, "ETH transfer failed");
        emit EtherSent(_to, _amount);
    }

    /// @notice Allows contract to receive ETH
    receive() external payable {}
}
