// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.13;

contract Contract {
    address public depositor;
    address public receiver;
    uint public balance;
    enum stages {
        Created,
        Funded,
        Closed,
        Refunded
    }
    stages public currentStage;

    event FundsDeposited(address indexed depositor, uint amount);
    event FundsReleased(address indexed receiver, uint amount);
    event FundsRefunded(address indexed depositor, uint amount);

    constructor(address _depositor, address _receiver) {
        require(_depositor != address(0), "Depositor cannot be zero");
        require(_receiver != address(0), "Receiver cannot be zero");
        depositor = _depositor;
        receiver = _receiver;
        currentStage = stages.Created;
    }

    function deposit(uint _balance) public payable {
        require(msg.sender == depositor, "Only depositor can deposit");
    }

    function withdraw() public {}

    function balanceInEscrow() public view returns (uint) {
        return address(this).balance;
    }
}
