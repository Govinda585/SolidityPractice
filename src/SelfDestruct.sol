// SPDX: License-Identifier: MIT

pragma solidity ^0.8.30;

contract SelfDestruct {
    address public owner;
    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only Owner");
        _;
    }

    function destroyAndSendTo(address payable recipient) public onlyOwner {
        selfdestruct(recipient); // send all eth to recipient and deletes contract
    }

    // Modern way to send eth to owner
    // selfdestruct is deprecated

    function emergengyWithdraw() public onlyOwner {
        (bool success, ) = payable(owner).call{value: address(this).balance}(
            ""
        );
        require(success, "Transfer failed");
    }

    receive() external payable {}
}
