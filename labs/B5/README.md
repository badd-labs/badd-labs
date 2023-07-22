# Lab B5: Reentrancy Attack

In a reentrancy (RE) attack, a malicious contract A interacts with a victim bank contact B to deplete the money B stores on behalf of A and other users. In this task, you will be given a vulnerable bank contract B and be required to implement a reentrancy attack contract A (Exercise 2). You will also rewrite the bank contract to B’ such that B’ is secured against reentrancy attack A (Exercise 3). Fallback is a unique function in Solidity and is a key primitive to enable reentrancy attack. You will run a given fallback contract to understand this primitive (Exercise 1).

| Tasks | Points | CS student | Finance student |
| --- | --- | --- | --- |
| 1 | 20 | Required | Bonus |
| 2 | 40 | Required | Bonus |
| 3 | 40 | Required | Bonus |

Exercise 1. Execute contract with fallback
---

```
pragma solidity ^0.8.15;

contract FallbackReceiver {
  event Log(string func, uint gas);
  fallback() external payable {
    emit Log("fallback", gasleft());}

  function getBalance() public view returns (uint) {
    return address(this).balance;}}

contract FallbackSender {
  function call(address payable _to) public payable {
    (bool sent, ) = _to.call{value: msg.value}("");
    require(sent, "Failed to send Ether");}}
```

- Deploy and run the above two smart contracts in Remix. Suppose `FallbackReceiver` is deployed at address `R`. Then run `FallbackSender.call(R)` and report the execution screenshot.

Exercise 2. Implement a Reentrancy Attack contract
---

```
pragma solidity ^0.8.15;

contract BankRE {
  mapping(address => uint256) public balances;

  function deposit() public payable {
    balances[msg.sender] += msg.value;}

  function withdraw() public {
    require(balances[msg.sender] != 0);
    (bool result, ) = msg.sender.call{value: balances[msg.sender]}("");
    balances[msg.sender] = 0; }}
```

- Implement an attack smart contract, `AttackerRE` and deploy it with the `BankRE` contract to mount a successful reentrancy attack to deplete the money in the `BankRE` contract. The attack is successful if attacker `AttackerRE` can deplete any `BankRE`'s Ether, as in the following test case:
    - Use an EOA account `C` to deposit Ether to `BankRE`, that is, `[C, BankRE].deposit()`
    - Deploy Contract `AttackerRE` to address `A` and initialize it with `BankRE`'s address.
    - Mount the reentrancy attack by calling the `attack()` function in `AttackerRE`, that is, `[A, AttackerRE].attack()`

Exercise 3. Implement a reentrancy-secured Bank contract
---

- Revise the `BankRE` contract to a new one, say `BankSafe`, so that running the reentrancy attack (as implemented by Exercise 2 in Contract `AttackerRE`) against `BankSafe` would fail.
  
## Deliverable

- Submit your Solidity code and the screenshot that runs the code on your computer for all exercises. The Solidity code needs to be stored in a `.sol` file in the plaintext format.
