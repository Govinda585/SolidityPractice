// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

contract AddressStore {
    address public storedAddress;
    event AddressUpdated(
        address indexed by,
        address indexed oldAddress,
        address indexed newAddress
    );

    function setAddress(address _newAddress) public {
        require(_newAddress != address(0), "Zero address not allowed");
        address oldAddress = storedAddress;
        storedAddress = _newAddress;
        emit AddressUpdated(msg.sender, oldAddress, _newAddress);
    }

    function getAddress() public view returns (address) {
        return storedAddress;
    }

    function isContract() public view returns (bool) {
        return storedAddress.code.length > 0;
    }
}
