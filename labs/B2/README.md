Lab B2: DEX security: Arbitrage 
===

Introduction
---

In traditional finance, arbitrage is a behavior to buy and sell the same asset in different markets in order to profit from different exchange rates. The same behavior applies to decentralized exchanges (DEXes), where a trader trades with two DEX pools and exercises buy-low-sell-high strategy. 

In this lab you will pretend to be both the trader hunting for the illicit profit and the DEX designer taking steps to defend DEX pools against arbitrage opportunities.

| Tasks | Points | CS student | Finance student |
| --- | --- | --- | --- |
|  1  | 40 | Required | Required |
|  2  | 20 | Required | Bonus |

Exercise 1. Attacking AMM by arbitrage
---

Suppose there are two DEX pools, OttoSwap and CuseSwap, each of which maintains the same tokens, `TokenX` and TokenY. For instance, OttoSwap stores $3$ units of `TokenX` and $1$ units of `TokenY`. CuseSwap stores $1$ units of `TokenX` and $4$ units of `TokenY`.

An adversary, Malloy, can conduct an arbitrage across the two pools to extract positive profit. For instance, Malloy can swap $1$ `TokenX` for $dy$ units of `TokenY` on CuseSwap. Through the constant product function, we can have $dy=2$. Malloy can then swap $2$ `TokenY` for $dx$ units of `TokenX` on OttoSwap. Again, through the constant product function, we can obtain $dx=2$. Thus, after these two swaps, Malloy can extract a profit of $dx-1=1$ unit of `TokenX`.

In practice, while Malloy can carry out the two swap calls in two separate transactions, there is a risk of one transaction succeeding and the other failing. In that case, Malloy may miss the timing/opportunity of extracting positive profit. Thus, Malloy wants to run the two swaps in a delegated smart contract. The system architecture is depicted in the figure below.

![AMM design diagram](lab-amm-abitrage.jpg)

In this exercise, you are required to implement the delegated smart contract `ArbiAtomic` to support atomic arbitrage and  extract positive profit. Contract `ArbiAtomic` supports a series of functions as follows. Malloy calling function `arbitrageUVXY(uint amount)` will invoke Pool `PU`'s `swapXY(amount)` to do the first swap before invoking swap on the other Pool `PV`. 

```
pragma solidity >=0.7.0 <0.9.0; 
contract ArbiAtomic {
  AMMPool poolU; AMMPool poolV;
  constructor(address _ poolU, address _ poolV){
   poolU = AMMPool(_ poolU); tokenY = AMMPool(_ poolV);
  }

  function arbitrageUVXY(uint dx) public payable {
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
- Deploy your implemented `ArbiAtomic` SC against Pools `PU` and `PV`. The deployed SC is denoted by `AA`.
- Let an EOA `M` call `TokenX`'s function `approve(PV,1)`.
- Let the EOA `M` call `AA`'s function `arbitrage(1)`.
- The expected outcome regarding different accounts' balances is in the following test-case table.

| Calls | `X.bal(M)` | `Y.bal(M)` | `X.bal(PU)` | `Y.bal(PU)` | `X.bal(PV)` | `Y.bal(PV)` |
| --- | --- | --- | --- | --- | --- | --- |
| Init state  | 1 | 0 | 3 | 1 | 1 | 4 |
| `[M,X].approve(PV,1)` | 1 | 0 | 3 | 1 | 1 | 4 |
| `[M,AA].arbitrage(1)` | 2 | 0 | 1 | 3 | 2 | 2 |

In the above table, `[M,X].approve(PV,1)` means EOA `M` externally calls `TokenX`'s function `approve()` with arguments `PV` and `1`.

Exercise 2. Defending AMM against arbitrage
---

The cause of arbitrage is the price differences across multiple AMM pools. To mitigate arbitrage, one can “reroute” swap requests to reduce or remove the price differences.

Consider the example mentioned in the previous exercise. Recall that OttoSwap's pool `PU` has $xU$ / $yU$ units of `TokenX` / `TokenY`; here $xU=3$ and $yU=1$. CuseSwap's pool `PV` has $xV$ / $yV$ units of `TokenX` / `TokenY`; here $xV=1$ and $yV=4$. Initially, the exchange rates at the two pools are different.

Suppose there is a normal swap request from benign user Alice. Alice wants to swap $dx$ units of `TokenX` for `TokenY`. Instead of routing Alice's request to just one pool, the re-routing mechanism splits $dx$ into two values $dxU$ and $dxV$. It then “re-route” $dxU$ to Pool `PU` and $dxV$ to the other Pool `PV`, such that the exchange rates between the two pools are brought to the same value. In other words, with swap rerouting, the exchange-rate imbalance can be eliminated and never be created.

In general, how to split a swap can be modeled as a constraint-solving problem:

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

![AMM design diagram](lab-amm-abitrage-defense.jpg)

In this exercise, you will implement a `ReRouter` SC with the following function signature. The system architecture is depicted in the figure above.

```
pragma solidity >=0.7.0 <0.9.0; 
contract ReRouter {
  AMMPool poolU; AMMPool poolV;
  constructor(address _ poolU, address _ poolV){
   poolU = AMMPool(_ poolU); tokenY = AMMPool(_ poolV);
  }

  function rerouteUVXY(uint dxU, uint dxV) public payable {
   // fill out the following with your code
  } 
}
```

Your code will be tested using the test case and running the instructions below:

- Deploy `BaddToken` SC twice to create instances of `TokenY` and `TokenX`.
- Deploy the given `CPAMM` SC twice to create instances of `PU` and `PV`; each instance is linked to both `TokenY` and `TokenX`.
   - Make sure Pool `PU` initially has 1 `TokenX` and 4 `TokenY`, and Pool `PV` initially has 3 `TokenX` and 1 `TokenY`.
- Deploy your implemented `ReRouter` SC against Pools `PU` and `PV`. The deployed SC is denoted by `R`.
- Let an EOA `A` call `TokenX`'s function `approve(PV,1)`.
- Let the EOA `A` call `R`'s function `arbitrage(1)`.
- The expected outcome regarding different accounts' balances is in the following test-case table.

| Calls | `X.bal(A)` | `Y.bal(A)` | `X.bal(PU)` | `Y.bal(PU)` | `X.bal(PV)` | `Y.bal(PV)` |
| --- | --- | --- | --- | --- | --- | --- |
| Init state  | 1 | 0 | 3 | 1 | 1 | 4 |
| `[A,X].approve(PU,?dxU)` | 1 | 0 | 3 | 1 | 1 | 4 |
| `[A,X].approve(PV,?dxV)` | 1 | 0 | 3 | 1 | 1 | 4 |
| `[A,R].rerouteUVXY(?dxU,?dxV)` | 0 | ? | ? | ? | ? | ? |

You will need to figure out what values the variables marked with `?` (question mark) in the above table should take, so that the end state after call `[A,R].rerouteUVXY(?dxU,?dxV)` meets the following two conditions: 
- The exchange rates of pools `PU` and `PV` are the same.
- EOA `A` has swapped out all `TokenX` she has, leaving balance to be `X.bal(A)=0`.
 

Deliverable
---

1. For all exercises, you should submit screenshots showing your contract executing the described workflow successfully.
    - If you fail to submit smart-contract code (in `.sol` file), your submission will be subject to up to 70% grade deduction. 
2. Submit your solidity smart contracts for each task. 
   - If you fail to submit the screenshots of the program execution, your submission will be subject to up to 50% grade deduction.
3. For Exercise 2, submit the test-case values (the ones marked with `?` in the table).
