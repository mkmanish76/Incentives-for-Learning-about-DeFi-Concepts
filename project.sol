// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract IncentivesForLearningDeFi {
    string public name = "DeFi Learning Incentives Token";
    string public symbol = "DLIT";
    uint8 public decimals = 18;
    uint256 public totalSupply;
    mapping(address => uint256) public balanceOf;
    mapping(address => bool) public hasCompletedTask;

    event Transfer(address indexed from, address indexed to, uint256 value);
    event TaskCompleted(address indexed user, uint256 reward);

    constructor(uint256 _initialSupply) {
        totalSupply = _initialSupply * 10 ** uint256(decimals);
        balanceOf[msg.sender] = totalSupply; // Assign all tokens to the contract creator
    }

    function completeTask() public {
        require(!hasCompletedTask[msg.sender], "Task already completed.");
        
        uint256 reward = 100 * 10 ** uint256(decimals); // Reward for completing the task
        require(balanceOf[address(this)] >= reward, "Insufficient reward balance in contract.");

        hasCompletedTask[msg.sender] = true;
        balanceOf[address(this)] -= reward;
        balanceOf[msg.sender] += reward;

        emit TaskCompleted(msg.sender, reward);
        emit Transfer(address(this), msg.sender, reward);
    }

    function withdrawTokens(uint256 amount) public {
        require(balanceOf[msg.sender] >= amount, "Insufficient balance.");
        balanceOf[msg.sender] -= amount;
        balanceOf[address(this)] += amount;

        emit Transfer(msg.sender, address(this), amount);
    }

    function getBalance() public view returns (uint256) {
        return balanceOf[msg.sender];
    }
}