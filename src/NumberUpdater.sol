// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

// Create a contract that emits an event when a number is updated.
contract NumberUpdater {
    uint256 public amount;

    event AmountUpdated(
        address indexed by,
        uint256 oldAmount,
        uint256 newAmount
    );

    function updateAmount(uint256 _amount) public {
        require(_amount > 0, "Amount must be greater than zero");
        require(_amount != amount, "Amount is the same");

        uint256 oldAmount = amount;
        amount = _amount;

        emit AmountUpdated(msg.sender, oldAmount, _amount);
    }

    function reset() public {
        uint oldAmount = amount;
        amount = 0;
        emit AmountUpdated(msg.sender, oldAmount, 0);
    }
}
