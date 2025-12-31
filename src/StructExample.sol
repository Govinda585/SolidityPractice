// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

contract StructExample {
    struct Person {
        string name;
        uint256 age;
    }

    Person public person;

    function setPerson(string memory _name, uint256 _age) public {
        person = Person(_name, _age);
    }
    function getPerson() public view returns (string memory, uint256) {
        return (person.name, person.age);
    }
}
