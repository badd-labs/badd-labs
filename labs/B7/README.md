Lab B1: Order-book DEX and Swap Settlement 
===

Introduction
---
![Diagram](./liquidation.png)
In a lending pool, an account (e.g., Alice) can deposit a token WETH as collateral to borrow another token USDT. The USD value of the borrowed USDT must remain below the value of the WETH multiplied by the collateral ratio (or Loan-to-Value, LTV). If the value of WETH drops significantly, a liquidation mechanism is triggered. The process is as follows: 1) Alice borrows USDT from the lending pool. 2) A price oracle reports a dropped value of WETH. 3. Another account, Bob, 3a) repays Alice’s USDT debt and 3b) receives her WETH collateral along with a liquidation bonus. As a result, Alice loses her WETH and is no longer able to withdraw it by repaying the loan. 
In this lab, you will build a simple lending pool that implements these two core functions: borrowing with collateral and liquidation.

Exercise 1. Borrow and repay 
---
One example of the borrow and repay process is shown below:

Suppose the collateral ratio is 75%, and the price is 1 WETH = 1000 USDT. Alice deposits 1 WETH to borrow USDT.

Borrow:
- At the beginning, Alice has 1 WETH, 0 USDT
- Alice calls `WETH.approve(pool, 1)`
- Alice calls `LendingPool.deposit_borrow(1)`, the lending pool checks the current price, and transfers USDT to Alice
- Alice has 0 WETH and 1 * 1000 * 75% = 750 USDT

Repay:
- Alice has 0 WETH, 750 USDT
- Alice calls `USDT.approve(pool, 750)`
- Alice calls `LendingPool.repay()`, LendingPool receives 750 USDT and returns 1 WETH to Alice
- Alice has 1 WETH and 0 USDT

Please design code to implement this process.

`Hint`: You can use the following structure to store Alice's bill:
```
struct Position {
    uint collateral; // in collateralToken, e.g., WETH
    uint debt;       // in borrowToken, e.g., USDT
}
```


Exercise 2. Set the price of the token
---

To simulate real-world conditions, we add a price-setting mechanism to the contract in this step. For simplicity, we assume USDT is pegged to 1 USD, and the price of WETH (in USD) is represented by a variable called price in the contract.

Please implement a `setPrice(unit _price)` function to allow setting the price of WETH.

`Hint`: Only the contract owner should be allowed to call this function.

Exercise 3. Implement the liquidation
---

Now, let’s simulate the liquidation process.
Suppose Alice has borrowed 750 USDT using 1 WETH as collateral. The liquidation threshold is 80%, meaning liquidation can be triggered if the value of the collateral drops below 80% of the loan value. Suppose the liquidation reward is 10%.
Here’s how the process works:
- The owner calls `pool.setPrice(500)`, updating the price of WETH to $500. Now, the collateral value is 1 WETH × $500 = $500, while the debt remains 750 USDT. The collateral ratio now is calculated as: 750 / 500 = 150%, Since 150% > 80%, the loan is eligible for liquidation.
- Bob calls `pool.liquidate(Alice)` and deposits 800 USDT to repay Alice's debt. The pool checks that the liquidation is allowed. Bob receives 1.1 WETH (1 WETH + 10% bonus)
Please implement a `liquidation(address user)` function to the pool to finish the lending pool. 


Deliverable
---

- For all exercises, you should 1) submit your smart-contract code, and 2) show the screenshot of the program execution. 
