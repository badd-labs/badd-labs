# Lab B5: Reentrancy Attack

In a reentrancy attack, a malicious contract A interacts with a victim bank contact B to deplete the money B stores on behalf of A and other users. In this task, you will be given a vulnerable bank contract B and be required to implement a reentrancy attack contract A (Exercise 2). You will also rewrite the bank contract to B’ such that B’ is secured against reentrancy attack A (Exercise 3). Fallback is a unique function in Solidity and is a key primitive to enable reentrancy attack. You will run a given fallback contract to understand this primitive (Exercise 1).

| Tasks | Points | CS student | Finance student |
| --- | --- | --- | --- |
| 1 | 20 | Required | Bonus |
| 2 | 40 | Required | Bonus |
| 3 | 40 | Required | Bonus |

Exercise 1. Execute contract with fallback
---

```
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

pragma solidity ^0.8.17;

contract Fallback {
  event Log(string func, uint gas);
  fallback() external payable {
    emit Log("fallback", gasleft());
  }

  receive() external payable {
    emit Log("receive", gasleft());
  }

  function getBalance() public view returns (uint) {
    return address(this).balance;
  }
}

contract SendToFallback {
  function transferToFallback(address payable _to) public payable {
    _to.transfer(msg.value);
  }

  function callFallback(address payable _to) public payable {
    (bool sent, ) = _to.call{value: msg.value}("");
    require(sent, "Failed to send Ether");
  }
}
```

- Run the above two smart contracts in Remix and report the execution screenshot.

Exercise 2. Implement a Reentrancy Attack contract
---

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

- Implement a smart contract A and deploy it with "FlawedBank" contract to mount a reentrancy attack to deplete the money in the FlowedBank contract.

Exercise 3. Implement a reentrancy-secured Bank contract
---

- Rewrite or revise the "FlawedBank" contract to secure it against the reentrancy attack you implemented through Exercise 2.

## Deliverable

1. For exercise 1, submit your modified Solidity file and the screenshot that runs the code on your computer. The Solidity program need to be stored in a .sol file in plaintext format.
