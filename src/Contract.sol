// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Contract {
    address public depositor;
    address public receiver;

    enum Stage { Created, Funded, Closed, Refunded }
    Stage public currentStage;

    event FundsDeposited(address indexed depositor, uint amount);
    event FundsReleased(address indexed receiver, uint amount);
    event FundsRefunded(address indexed depositor, uint amount);

    constructor(address _depositor, address _receiver) {
        require(_depositor != address(0), "Depositor cannot be zero");
        require(_receiver != address(0), "Receiver cannot be zero");

        depositor = _depositor;
        receiver  = _receiver;
        currentStage = Stage.Created;
    }

    function deposit() external payable {
        require(msg.sender == depositor, "Only depositor can deposit");
        require(currentStage == Stage.Created, "escrow not created yet");

        require(msg.value > 0, "No ETH sent");

        currentStage = Stage.Funded;
        emit FundsDeposited(msg.sender, msg.value);
    }

    function withdraw() external {
        require(msg.sender == receiver, "Only receiver");
        require(currentStage == Stage.Funded, "Not funded");

        uint amount = address(this).balance;

        currentStage = Stage.Closed; 

        (bool success, ) = payable(receiver).call{value: amount}("");
        require(success, "ETH transfer failed");

        emit FundsReleased(receiver, amount);
    }
    function refund() external {
        require(msg.sender == depositor, "Only depositor");
        require(currentStage == Stage.Funded, "Not funded");

        uint amount = address(this).balance;

        currentStage = Stage.Refunded;

        (bool success, ) = depositor.call{value: amount}("");
        require(success, "Refund failed");

        emit FundsRefunded(depositor, amount);
    }

    function balanceInEscrow() external view returns (uint) {
        return address(this).balance;
    }
}
