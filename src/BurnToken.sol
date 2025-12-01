// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

contract BurnToken {
    string public tokenName;
    string public tokenSymbol;
    address public owner;
    uint256 public totalSupply;

    mapping(address => uint) public balanceOf;

    constructor(
        string memory _tokenName,
        string memory _tokenSymbol,
        uint _totalSupply
    ) {
        owner = msg.sender;
        tokenName = _tokenName;
        tokenSymbol = _tokenSymbol;
        totalSupply = _totalSupply;
        balanceOf[owner] = _totalSupply;
    }

    function burnToken(uint _numberOfTokenBurn) public {
        require(
            balanceOf[msg.sender] >= _numberOfTokenBurn,
            "Insufficient balance"
        );
        balanceOf[msg.sender] = balanceOf[msg.sender] - _numberOfTokenBurn;
        totalSupply -= _numberOfTokenBurn;
    }
}
