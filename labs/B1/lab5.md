Lab 5: Price Oracle and Liquidation
===


A lending pool service allows borrowers to borrow one asset and collateralize another asset. To ensure that the value of the collateral matches that of the asset borrowed, the lending pool relies on a liquidation mechanism. In this lab, you will implement a simple lending pool and a liquidation mechanism between ETH and an ERC20 token. The liquidation requires reading from an off-chain oracle the price ticks of the current exchange rates between the token and ETH.

![Contract design diagram](lab-pricefeeds.jpg)

More specifically, the figure depicts common workflows in a lending pool service. This workflow has two smart contracts and three EOAs: a borrower EOA, an oracle EOA, and a liquidator EOA. The two smart contracts are the tToken smart contracts and the lending-pool smart contract (LP). There are three workflows in this system; 1) the borrower borrowing tToken by collateral of ETH, 2) the price oracle updates the current price on the LP smart contract, and triggers liquidation, 3) the liquidator deposit tToken to claim the ETH collateral at a lower exchange rate. 

In this lab, you will implement the three workflows in an overall functional system.

Task 1: Borrow
---

Write smart contracts LP and tToken to support the following workflow: 

Initially, the LP smart contract has more than 10X tTokens. On Day One, the borrower calls the "borrow" function in the LP smart contract. Suppose through this function call (also a transaction), the borrower sends X ETH to the LP, and the X ETH is worth 4X tToken (that is, the ETH-tToken exchange rate on Day One is 4:1). The LP allows to lend at most 2X tToken to the borrower. This workflow is shown by Step 1) in the figure.

Task 2: Price feed
---

Add a "feedPriceTick" function to your LP from Task 1, so that it supports the following workflow: 

The Oracle EOA can call the "feedPriceTick" with value T to set the current exchange rate between tToken and ETH. After the exchange rate is updated, the feedPriceTick function may calculate the current value of the ETH collateral in tToken. If it finds the ETH's worth is less than 3X tTokens, it sets the liquidation flag. This workflow is shown by Step 2) in the figure.

Task 3: Liquidation
---

Add a "liquidate" function to your LP from Task 2, so that it supports the following workflow: 

A liquidator EOA transfers 2X tTokens to LP's account. This can be done by having the EOA call the tToken's "transfer" function (this is Step 3a in the figure). Then, the EOA calls the LP's "liquidate" function, which first checks the liquidation flag, and if true, proceeds to transfer X ETH to the liquidator's EOA account (Step 3b in the figure).


Deliverable
----

1. For all tasks, you should show the screenshot that you have executed the described workflow successfully.
2. Submit your solidity program.


