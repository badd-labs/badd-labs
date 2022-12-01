Lab B2: DEX security: Arbitrage 
===

Introduction
---

In traditional finance, arbitrage is a behavior to buy and sell the same asset in different markets in order to profit from different exchange rates. The same behavior applies to decentralized exchanges (DEXes), where a trader trades with two DEX pools and exercises buy-low-sell-high strategy. 

In this lab you will pretend to be both the trader hunting for the illicit profit and the DEX designer taking steps to defend DEX pools against arbitrage opportunities.

| Tasks | Points | CS student | Finance student |
| --- | --- | --- | --- |
|  1  | 30 | Required | Required |
|  2  | 30 | Required | Bonus |

Exercise 1. Arbitrage attacks on AMM pools
---

Suppose there are two DEX pools, OttoSwap and CuseSwap, each of which maintains the same tokens, `TokenX` and TokenY. For instance, OttoSwap stores $3$ units of `TokenX` and $1$ units of `TokenY`. CuseSwap stores $1$ units of `TokenX` and $4$ units of `TokenY`.

An adversary, Malloy, can conduct an arbitrage across the two pools to extract positive profit. For instance, Malloy can swap $1$ `TokenX` for $dy$ units of `TokenY` on CuseSwap. Through the constant product function, we can have $dy=2$. Malloy can then swap $2$ `TokenY` for $dx$ units of `TokenX` on OttoSwap. Again, through the constant product function, we can obtain $dx=2$. Thus, after these two swaps, Malloy can extract a profit of $dx-1=1$ unit of `TokenX`.

In practice, while Malloy can carry out the two swap calls in two separate transactions, there is a risk of one transaction succeeding and the other failing. In that case, Malloy may miss the timing/opportunity of extracting positive profit. Thus, Malloy wants to run the two swaps in a delegated smart contract. The system architecture is depicted in the figure below.

![AMM design diagram](lab-amm-abitrage.jpg)

In this exercise, you are required to implement the delegated smart contract `ArbiAtomic` to support atomic arbitrage and  extract positive profit. Contract `ArbiAtomic` supports a series of functions as follows. Malloy calling function `arbitrageUVXY(uint amount)` will invoke Pool `PU`’s `swapXY(amount)` to do the first swap before invoking swap on the other Pool `PV`. 

```
pragma solidity >=0.7.0 <0.9.0; 
contract ArbiAtomic {
  AMMPool poolU; AMMPool poolV;
  constructor(address _ poolU, address _ poolV){
   poolU = AMMPool(_ poolU); tokenY = AMMPool(_ poolV);
  }

  function arbitrageUVXY(uint amount) public payable {
   // fill out the following with your code
  } 
}
```

You will be given the smart-contract code implementing a constant product AMM (`CPAMM`) and a `BaddToken` supporting `approve/transferFrom`. 
Note that in the above code snippet, we reuse the same interface of AMMPool as defined in Lab B1 [[link](labs/B1/README.md)].

Your code will be tested using the test case and running the instructions below:

- Deploy `BaddToken` SC twice to create instances of `TokenY` and `TokenX`.
- Deploy the given `CPAMM` SC twice to create instances of `PU` and `PV`; each instance is linked to both `TokenY` and `TokenX`.
   - Make sure Pool `PU` initially has 1 `TokenX` and 4 `TokenY`, and Pool `PV` initially has 3 `TokenX` and 1 `TokenY`.
- Deploy your implemented `ArbiAtomic` SC against Pools `PU` and `PV`. The deployed SC is denoted by `R`.
- Let an EOA `M` call `TokenX`’s function `approve(PV,1)`.
- Let the EOA `M` call `R`’s function `arbitrage(1)`.
- The expected outcome regarding different accounts’ balances is in the following test-case table.

| Calls | `X.bal(M)` | `Y.bal(M)` | `X.bal(PU)` | `Y.bal(PU)` | `X.bal(PV)` | `Y.bal(PV)` |
| --- | --- | --- | --- | --- | --- | --- |
| Init state  | 1 | 0 | 3 | 1 | 1 | 4 |
| `[M,X].approve(PV,1)` | 1 | 0 | 3 | 1 | 1 | 4 |
| `[M,R].arbitrage(1)` | 2 | 0 | 1 | 3 | 2 | 2 |

Exercise 2. Arbitrage mitigation by routing swaps
---

![AMM design diagram](lab-amm-abitrage-defense.jpg)

A defense against arbitrage is the “routing” approach that re-router a user's swap request to multiple AMM pools and balances out the spending so that exchange rates across AMM pools remain the same.

Suppose an original user request is to swap $dx$ units of `TokenX` for `TokenY`, and there are two AMM pools: the first pool of $x1$/$y1$ units of `TokenX`/`TokenY` and the second pool of $x2$/$y2$ units of `TokenX`/`TokenY`. To make sure the exchange rates remain the same, we can have:


$$
\begin{eqnarray}
dx1+dx2&=&dx \\
x1/y1&=&x2/y2\\
x1\*y1&=&(x1+dx1)(y1-dy1)\\
x2\*y2&=&(x2+dx2)(y2-dy2)\\
(x1+dx1)/(y1-dy1)&=&(x2+dx2)/(y2-dy2)\\
\end{eqnarray}
$$


It derives: 

$$
\begin{eqnarray}
dx1&=&\frac{Z(x2+dx)-x1}{Z+1} \\
dx2&=&\frac{x1+dx-Z*x2}{Z+1} \\
Z&=&\sqrt{\frac{x1*y1}{x2*y2}} \\
\end{eqnarray}
$$

In this exercise, you will implement such a smart contract that split the original swap of $dx$ units between Ottoswap and Cuseswap as shown by $dx1$ and $dx2$ above. This ensures that an exchange-rate imbalance is never created. The figure shows the system architecture. 


- Deploy `BaddToken` SC twice to create instances of `TokenY` and `TokenX`.
- Deploy the given `CP-AMM` SC twice to create instances of `Ottoswap` and `Cuseswap`; each instance is against both `TokenY` and `TokenX`.
   - Make sure `Ottoswap` initially has 10 `TokenY` and 5 `TokenX`. 
   - Make sure `Cuseswap` initially has 30 `TokenY` and 15 `TokenX`.
- Deploy your router SC.
- Call the router SC to swap 4 `TokenX` for `TokenY`. 
- In your lab report, include the execution screenshot that shows how much `TokenX`is involved in `Ottoswap` and how much in `Cuseswap`.


Deliverable
---

1. For all exercises, you should submit screenshots showing your contract executing the described workflow successfully.
    - If you fail to submit smart-contract code (in `.sol` file), your submission will be subject to up to 70% grade deduction. 
2. Submit your solidity smart contracts for each task. 
   - If you fail to submit the screenshots of the program execution, your submission will be subject to up to 50% grade deduction.
