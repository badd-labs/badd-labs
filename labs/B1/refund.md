Exercise 7 (Challenge question). Undo `transfer` upon Misissued Deposit
---

Suppose Alice calls `transfer` function in `TokenX` SC and then realizes `transfer` is unsupported in our AMM protocol. Alice may want to undo this misissued deposit (i.e., `transfer`). Extend your pool SC with function `undo_transfer`, so that Alice can call `undo_transfer` to request the refund of the mis-deposited tokens. 

Design the argument list of function `undo_transfer()` and implement the function in the Pool SC. 

We will grade your solution with the following test case:

| Calls | `X.balanceOf(A)` | `X.balanceOf(P)` | 
| --- | --- | --- | 
| Init state  | 1 | 0 | 
| `A.transfer(P,1)` | 0 | 1 |
| `A.undo_transfer(...)` | 1 | 0 |

Meanwhile, your `undo_transfer()` function should be secured against thief Bob. That is, Bob cannot extract value from Alice's mis-issued deposit (by `transfer`). In this regard, we will grade your solution with the following test case:

| Calls | `X.balanceOf(A)` | `X.balanceOf(P)` | `X.balanceOf(B)` | 
| --- | --- | --- | --- |
| Init state  | 1 | 0 | 0 |
| `A.transfer(P,1)` | 0 | 1 | 0 |
| `B.undo_transfer(...)` | 1 | 0 | 0 |


