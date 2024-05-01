Lab B3: Order-book DEX and Swap Settlement 
===

Introduction
---

DEX or decentralized exchange supports the swap of token ownership between different accounts. A swap is essentially two transfers, one from Alice to Bob and the other from Bob to Alice. A swap is supposed to be atomic, in the sense that either both transfers occur or no transfer occurs. In this lab, you are going to implement a DEX supporting atomic swap settlement.
 

| Exercises | CS student | Finance student
| --- | --- | --- |
|  1  | Required | Required |
|  2  | Required | Required |
|  3  | Required | Required |



Exercise 1. Execute atomic swap settlement in one transaction (by escrow EOA)
---

An atomic swap occurs between two accounts in two tokens. Suppose Alice of token `TokenX` wants to trade her `TokenX`s for Bob's `TokenY`s. For simplicity, we assume the exchange rate between `TokenX` and `TokenY` is always 1:1 (i.e., one `TokenX` for one `TokenY`). A swap incurs a transfer from Alice to Bob in `TokenX` and another transfer from Bob to Alice in `TokenY`.

A simple swap protocol is to do the two transfers in one transaction. This requires Alice and Bob (two EOAs) first transfer tokens to a trusted third-party account, that is, the escrow. After the escrow receives both Alice's `TokenX` and Bob's `TokenY`, the escrow then sends `TokenX` to Bob and `TokenY` to Alice, to settle the swap. 

The above escrow protocol can be instanciated differently. One design is to materialize the escrow as an EOA. In this case, the escrow EOA is trusted to send the two transfer calls, atomically. The following figure illustrates the escrow-EOA protocol.

![Contract design diagram](lab-escrow3-EOA.jpg)

Your job in this exercise is to deploy your token smart contracts, from Exercise 1, twice (first as `TokenX` and then as `TokenY`). Run the above escrow-EOA protocol to complete the swap of Alice's `TokenX` and Bob's `TokenY`. 

Exercise 2. Design atomic swap settlement in one transaction (by escrow smart contract)
---

Another approach is to implement the escrow in a smart contract. In this case, after Alice and Bob transfer their tokens to the escrow smart contract (in Step 1 & 2), they then notify the escrow smart contract. After receiving both Alice and Bob's notification, the escrow smart contract sends two transfers, atomically, that is, first to transfer `TokenX` to Bob and then to transfer `TokenY` to Alice. The following figure illustrates the escrow-smart-contract protocol.

![Contract design diagram](lab-escrow3.jpg)

Your job is to:

1. Implement the escrow smart contract described as above. Then run an atomic swap by deploying the token smart contracts (twice respectively as `TokenX` and `TokenY` instances) and the escrow smart contract.
2. Design the failure handling protocol by extending the above escrow smart contract. One failure case is that Alice (or Bob) did not transfer her `TokenX`s (his `TokenY`s) to the escrow. In this case, Alice (Bob) should be able to withdraw her `TokenX`s (his `TokenY`s) after a predefined timeout, say *t* blocks. Use `block.number` to access the current block height in solidity.

- Hint: To make smart contract `X` call smart contract `Y`'s function `foo`, you can pass to `X` `Y`'s contract address say `CA_Y` so that in `X` the following statement calls `CA_Y`'s function `foo`: `(Y)CA_Y.foo();` 

Exercise 3: Design the swap between token and Ether
---

Revise your escrow smart contract to support the swap between Ether and `TokenX`. For instance, Alice trades her `TokenX` for Bob's Ether. Design the protocol as above and implement it in the escrow smart contract. Here, you can assume one `TokenX` is exchangeable with one Ether.

Consider both cases of success and failed swaps.

Deliverable
---

- For all exercises, you should 1) submit your smart-contract code, and 2) show the screenshot of the program execution. 
