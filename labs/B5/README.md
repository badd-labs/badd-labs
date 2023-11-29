 # Lab B5: Reentrancy Attacks and Defenses

In a reentrancy (RE) attack, a malicious contract A interacts with a victim bank contact B to deplete the money B stores on behalf of A and other users. In this task, you will be given a vulnerable bank contract B and be required to implement a reentrancy attack contract A (Exercise 2). You will also rewrite the bank contract to B’ such that B’ is secured against reentrancy attack A (Exercise 3). Fallback is a unique function in Solidity and is a key primitive to enable reentrancy attack. You will run a given fallback contract to understand this primitive (Exercise 1).

| Tasks | Points | CS student | Finance student |
| --- | --- | --- | --- |
| 1 | 10 | Required | Required |
| 2 | 40 | Required | Bonus |
| 3 | 30 | Required | Bonus |
| 4 | 20 | Bonus | Bonus |
| 5 | 10 | Bonus | Bonus |

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

Exercise 3.  Design Reentrancy Defense with Implementation In Secure Bank
---


- Design one or multiple defenses against reentrancy attacks in `BankRE` contract in Exercise 2.
- Implement your new defenses in a new bank contract, say `BankSafe`, so that running the reentrancy attack (as implemented by Exercise 2 in Contract `AttackerRE`) against `BankSafe` would fail.

Exercise 4. Evasive Reentrancy Attack to Bypass Locks
---

Locking the access to Ether-transfer instructions that may cause reentrance is a widely adopted defense strategy against reentrance attacks. The following smart contract implementing an Ether bank on a Pegged Token does use a lock to prevent the reentrance of the `burn()` function. However, the seemingly fixed contract is still vulnerable to the reentrancy attack in a general sense. Design attack contracts to attack the `EtherBankPeggedToken` smart contract so that 1) an attacker EOA can withdraw more than his account balance, and 2) an attacker EOA can deplete the Ether balance of the `EtherBankPeggedToken` contract, that is, the balance of all accounts in the contract.

- The re-entered function does not have to be the same as the function it first entered.

```
contract EtherBankPeggedToken {
  mapping(address => uint256) balance;
  mapping(address => bool) lock;
  mapping(address => mapping(address => uint256)) allowance;

modifier checkLock { // reentrancy locking
  require(lock[msg.sender] == false); _; }

function deposit() external payable {
  balance[msg.sender] += msg.value;
}

function approve(address other, uint256 amnt) external { 
  allowance[msg.sender][other] += amnt; }

function transferFrom(address from, uint256 amnt) external checkLock {
  require(balance[from] >= amnt);
  require(allowance[from][msg.sender] >= amnt);
  balance[from] -= amnt;
  allowance[from][msg.sender] -= amnt;
  balance[msg.sender] += amnt; }

function burn() external checkLock {
  // set lock
  lock[msg.sender] = true;
  msg.sender.call{value: balance[msg.sender]}("");
  // release lock
  lock[msg.sender] = false;
  balance[msg.sender] = 0; }
}
```

Exercise 5. Fixing Reentrancy Attack with Lock Evasion
---

- Design one or multiple defenses against reentrancy attacks to fix the bugs in the `EtherBankPeggedToken` contract in Exercise 4.

  
## Deliverable

- Submit your Solidity code and the screenshot that runs the code on your computer for all exercises. The Solidity code needs to be stored in a `.sol` file in the plaintext format.
