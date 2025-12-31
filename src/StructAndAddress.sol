// SPDX-License-Identifier: MIT

pragma solidity ^0.8.30;
// Create a mapping of address to Person struct.

contract StructAndAddress {
    struct Person {
        string name;
        uint256 age;
    }

    Person public person;

    mapping(address => Person) detailOf;

    function set(string memory _name, uint256 _age) public {
        person = Person(_name, _age);

        detailOf[msg.sender] = person;
    }

    function get() public view returns (Person memory) {
        return detailOf[msg.sender];
    }
}
