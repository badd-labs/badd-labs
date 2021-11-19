Lab 3: DEX supporting Atomic Swap Settlement
===

Introduction
---

DEX or decentralized exchange supports the swap of token ownership between different accounts. A swap is essentially two transfers, one from Alice to Bob and the other from Bob to Alice. A swap is supposed to be atomic, in the sense that either both transfers occur or no transfer occurs. In this lab, you are going to implement a basic DEX settling swaps atomically.


Task 1. Implement an ERC20 token
---

Implement a simple token smart contract supporting ERC20-compatible functions:   `transfer(address sender, address recipient, uint256 amount)` 

<!--

contract SimpleToken {
    mapping (address => uint256) private _balances;
    function transfer(address sender, address recipient, uint256 amount) internal {
        if ( _balances[sender] - amount < 0) throw;
        _balances[sender] -= amount;
        _balances[recipient] += amount;
    }
}

-->

Task 2. Settling swaps atomically in one transaction (by escrow smart contract)
---

An atomic swap occurs between two accounts in two tokens. Suppose Alice of token mToken wants to trade her mTokens for Bob’s tTokens. For simplicity, we assume the exchange rate between mToken and tToken is always 1:1 (i.e., one mToken for one tToken). A swap incurs a transfer from Alice to Bob in mToken and another transfer from Bob to Alice in tToken.

A simple swap protocol is to do the two transfers in one transaction. This requires Alice and Bob (two EOAs) first transfer tokens to a trusted third-party account, that is, the escrow. After the escrow smart contract receives both Alice’s mToken and Bob’s tToken, the escrow then sends mToken to Bob and tToken to Alice, to settle the swap. The following figure illustrates the protocol.

![Contract design diagram](lab-escrow3.jpg)

Your job is to:

1. Implement the above escrow in a smart contract, and run an atomic swap by deploying the token smart contracts (twice respectively as mToken and tToken instances) and the escrow smart contract.
2. Extend the above escrow to handle the failure case; for instance, Alice did transfer her mTokens to the escrow but Bob did not. In this case, Alice can withdraw her mToken after a predifined timeout, say *t* blocks. Use `block.number` to access the current block height in solidity.

Task 3: Supporting the swap between token and Ether
---

Revise your escrow smart contract to support the swap between Ether and mToken. That is, now Alice trades her mToken for Bob's Ether. Design the protocol as above and implement it in the escrow smart contract. 

Consider both success swap and failed swap cases.

Task 4. Settling swaps atomically in two transactions (using HTLC)
---

TBA

Deliverable
---

- For all tasks, you should 1) submit your smart-contract code, and 2) show the screenshot of the program execution. 
