Lab 3: Tokens and DEX
===

Introduction
---

DEX or decentralized exchange supports the swap of token ownership between different accounts. A swap is essentially two transfers, one from Alice to Bob and the other from Bob to Alice. A swap is supposed to be atomic, in the sense that either both transfers occur or no transfer occurs. In this lab, you are going to implement a DEX supporting atomic swap settlement.
 

| Tasks | CS student | Finance student
| --- | --- | --- |
|  1  | Required | Required |
|  2  | Required | Required |
|  3  | Required | Bonus |
|  4  | Required | Bonus |
|  5  | Required | Bonus |
|  6  | Bonus | Bonus |

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

Task 2. Execute atomic swap settlement in one transaction (by escrow EOA)
---

An atomic swap occurs between two accounts in two tokens. Suppose Alice of token mToken wants to trade her mTokens for Bob’s tTokens. For simplicity, we assume the exchange rate between mToken and tToken is always 1:1 (i.e., one mToken for one tToken). A swap incurs a transfer from Alice to Bob in mToken and another transfer from Bob to Alice in tToken.

A simple swap protocol is to do the two transfers in one transaction. This requires Alice and Bob (two EOAs) first transfer tokens to a trusted third-party account, that is, the escrow. After the escrow receives both Alice's mToken and Bob's tToken, the escrow then sends mToken to Bob and tToken to Alice, to settle the swap. 

There are different instanstiation of the escrow protocol. One is to materialize an escrow as an EOA. In this case, the escrow EOA is trusted to send the two transfer calls, atomically. The following figure illustrates the escrow-EOA protocol.

![Contract design diagram](lab-escrow3-EOA.jpg)

Your job in this task is to deploy your token smart contracts, from Task 1, twice (first as mToken and then as tToken). Run the above escrow-EOA protocol to complete the swap of Alice's mToken and Bob's tToken. 

Task 3. Design and implement atomic swap settlement in one transaction (by escrow smart contract)
---

Another approach is to impelment the escrow in a smart contract. In this case, after Alice and Bob transfer their tokens to the escrow smart contract (in Step 1 & 2), they then notify the escrow smart contract. After receiving both Alice and Bob's notification, the escrow smart contract sends two transfers, atomically, that is, first to tranfer mToken to Bob and then to transfer tToken to Alice. The following figure illustrates the escrow-smart-contract protocol.

![Contract design diagram](lab-escrow3.jpg)

Your job is to:

1. Implement the escrow smart contract described as above. Then run an atomic swap by deploying the token smart contracts (twice respectively as mToken and tToken instances) and the escrow smart contract.
2. Design the failure handling protocol by extending the above escrow smart contract. One failure case is that Alice (or Bob) did not transfer her mTokens (his tTokens) to the escrow. In this case, Alice (Bob) should be able to withdraw her mTokens (his tTokens) after a predifined timeout, say *t* blocks. Use `block.number` to access the current block height in solidity.

Task 4: Design and implement the swap between token and Ether
---

Revise your escrow smart contract to support the swap between Ether and mToken. For instance, Alice trades her mToken for Bob's Ether. Design the protocol as above and implement it in the escrow smart contract. 

Consider both success swap and failed swap cases.

Task 5. Implement the atomic swap settlement in two transactions (using HTLC)
---

`HTLC` or hash time lock contract is parameterized by hash `h`, timeout `t`, sender account `A` and receiver account `B`. `HTLC(h,t,A,B,2mToken)` stores a deposit of 2 mTokens and there are two outcomes: 1) before the timeout `t`, if the `HTLC` smart contract receives receiver `B`'s transaction revealing secret `s` such that `h=H(s)`, the 2 mTokens will be transferred to `B`'s account. 2) after the timeout `t`, if case 1) did not happen, the `HTLC` smart contract returns the deposit to sender `A`.

Use two `HTLC` smart contracts to enable atomic swap involving multiple transactions. 

Implement `HTLC`smart contract. 

Run the atomic swap based on two `HTLC` instance.

Task 6. Design and implement order matchmaking 
---

So far, we consider a fixed exchange rate between mToken and tToken. Now you are to implement order matchmaking component in which the exchange rate can be dynamically set (either by traders or by smart contacts). 

Choose a matchmaking protocol of your choice, either orderbook or AMM, as described in the class. Choose one of the above swap-settlement protocols and extend it to support the matchmaking.

Deliverable
---

- For all tasks, you should 1) submit your smart-contract code, and 2) show the screenshot of the program execution. 
