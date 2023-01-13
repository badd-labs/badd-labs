# Lab B5: Reentrancy Attack

## Introduction

A reentrancy attack involves a victim smart contract A and an attacker smart contract B.\
In the attack, A calls B to execute, which further calls A (or re-enters A); hence reentrancy attack.\
Reentrancy attack is the primary attack vector exploited in the 2016 DAO attack, causing $150 million loss and leading to the ETC/Ethereum classic hard fork.\
\
In this lab, we provided a bank SC with a vulneralbility of reentrancy, you need to implement a reentrancy attacker SC to exhaust the bank's fund using this vulnerability.

## Exercise 1: Write an reentrancy attack SC

### Flawed bank SC source code
```
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

contract FlawedBank {

    mapping(address => uint256) public balances;

    function deposit() public payable {
        balances[msg.sender] += msg.value;
    }

    function withdrawBalance() public {
        (bool result, ) = msg.sender.call{value: balances[msg.sender]}("");
        require(result);
        balances[msg.sender] = 0;
    }
}
```
### Reentrancy attack SC framework
```
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

contract Reentrancy {
    address private _bankAddr;

    constructor (address bankAddr) {
    
    }

    function depositToBank() external payable {
    
    }

    function withdrawFromBank() public {
    
    }

    receive() external payable {

    }
}
```
### Requirement

Implement the reentrancy attack with the provided framework.

### Expected Result

Assume `FlawedBank` SC is depolyed to the blockchain and `Reentrancy` SC is depolyed to blockchain with constructor parameters `(FlawedBankAddress)`.\
Suppose `Alice` deposits 2 ether to the bank, and `Bob` is the attacker tries to exploit the vulnerability of the bank to conduct an reentrancy attack and exhausts the bank's deposit.\
The following tx sequence is one of the scenarios of the attack.

| Sequence | From | To | Function | Args | Expected result
| --- | --- | --- | --- | --- | ---
|  1  | Alice | FlawedBank | deposit() | msg.value=2 ether | void
|  2  | Bob | Reentrancy | depositToBank() | msg.value=1 ether | void
|  3  | Any | FlawedBank | balances() | Reentrancy | 1 ether
|  4  | Any | FlawedBank | balances() | Alice | 2 ether
|  5  | Bob | Reentrancy | withdrawFromBank() | void | void
|  6  | Any | FlawedBank | balances() | Alice | 0
|  7  | Any | FlawedBank | balances() | Reentrancy | 0

After making all txs above, the ether balance of Reentrancy SC should be 3.

## Deliverable

1. For exercise 1, submit your modified Solidity file and the screenshot that runs the code on your computer. The Solidity program need to be stored in a .sol file in plaintext format.
