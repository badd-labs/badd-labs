Lab B2: DEX pricing: AMM and Constant Function 
===

Introduction
---

DEX or decentralized exchange supports the swap of token ownership between different accounts. A swap is essentially two transfers, one from Alice to Bob and the other from Bob to Alice. A swap is supposed to be atomic, in the sense that either both transfers occur or no transfer occurs. In this lab, you are going to implement a DEX supporting atomic swap settlement.

| Tasks | CS student | Finance student
| --- | --- | --- |
|  1  | Required | Required |
|  2  | Required | Required |
|  3  | Required | Bonus (50%) |
|  4  | Required | Bonus (50%) |
|  5  | Bonus (50%) | Bonus (100%) |

Task 1. Design order matchmaking 
---

So far, you build a DEX's swap settlement layer. This is an incomplete DEX, as it only supports the fixed exchange rate between mToken and tToken. 

Now you are to build a full fledged DEX by supporting an order matchmaking layer. Order matchmaking supports the exchange rate that are dynamically set.

You have two choices: Either implement an AMM mechanism or an order-book. 

- Hint 1: If you choose to implement an on-chain AMM (just like Uniswap), you should consider revising/extending your solution of Task 3: Bob should be a smart contract account. 
- Hint 2: If you choose to implement an off-chain orderbook (just like IDEX), you should consider revising/extending your solution of Task 3: In Step 3/4, Alice and Bob should send their acceptable exchange rates to another EOA controlled by the off-chain orderbook.


Deliverable
---

- For all tasks, you should 1) submit your smart-contract code, and 2) show the screenshot of the program execution. 
