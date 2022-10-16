Lab B1: AMM DEX ("Build-your-own-Uniswap" Lab)
===

Introduction
---

In today's DEX market, Uniswap V2 is the most popular service all-time. See the DEX market distribution in the following screenshot taken from https://etherscan.io/stat/dextracker.

![DEX market](dex-market-uniswapv2.png)

In this lab, you will being writing smart contracts to implement your own Uniswap revisiting the design choices made in Uniswap V2. Uniswap adopts the protocol of automated market maker (AMM) in which a trader trades directly with a smart-contract intermediary called pool. This is unlike other DEX designs like order book. Besides Uniswap V2, AMM is also adopted in other popular services including Uniswap V3, Sushiswap, Pancakeswap, etc.

We provide companion slides to introduce more background on AMM: https://www.dropbox.com/s/8749eybqaw67afd/3.DeFi-LabB1.pdf?dl=0

| Tasks | Points | CS student | Finance student |
| --- | --- | --- | --- |
|  1  | 10 |  Required | Bonus |
|  2  | 20 | Required | Bonus |
|  3  | 30 | Required | Bonus |
|  4  | 40 | Required | Bonus |
|  5  | 20 | Required | Bonus |
|  6  | 20 | Required | Bonus |
|  7  | 50 | Bonus | Bonus |

Exercise 1. Execute ERC20 token transfer
---

The following smart contract implements a very simple token supporting the essential transfer function: `transfer(address sender, address recipient, uint256 amount)` 

```
pragma solidity >=0.7.0 <0.9.0; 
contract BaddToken {  
  uint _totalSupply = 0; string _symbol;  
  mapping(address => uint) balances;  
  constructor(string memory symbol, uint256 initialSupply) {
    _symbol = symbol;
    _totalSupply = initialSupply;
    balances[msg.sender] = _totalSupply;  
  }
  
  function transfer(address receiver, uint amount) public returns (bool) {    
    require(amount <= balances[msg.sender]);        
    balances[msg.sender] = balances[msg.sender] - amount;    
    balances[receiver] = balances[receiver] + amount;    
    return true;  
  }

  function balanceOf(address account) public view returns(uint256){
    return balances[account];
  }}
```

Your job in this exercise is to deploy the above smart contract in Remix, creating an `TokenX` instance. Demonstrate the process that the `TokenX` issuer transfers 10 `TokenX` to another account, say Alice, and display each account's balance before/after the transfer.


Exercise 2. Extend `BaddToken` with approve/transferFrom
---

```
function approve(address spender, uint256 amount) external returns (bool);
function transferFrom(address from, address to, uint256 amount) external returns (bool);
function allowance(address owner, address spender) external view returns (uint256);
```

Your job is to extend the `BaddToken` with the `approve` and `transferFrom` functions defined as above. Suppose owner Alice wants to transfer 1 `BaddToken` to another account Bob through an intermediary Charlie. Alice first calls `approve(Charlie, 1)` which gives Charlie allowance of 1 `BaddToken`. Then, Charlie calls function `transferFrom(Alice, Bob, 1)`, through which Charlie's balance is credited by 1 `BaddToken` and Alice's balance is debited by 1 `BaddToken`.

Deploy the extended `BaddToken` SC in Remix. We use the following table to test/grade if your deployed token SC is correct. 
For instance, we may send a sequence of transaction against the instances of your `BaddToken`: `A.approve(C, 1)`, `balanceOf(A)`, `allowance(A, C)`, `balanceOf(B)`, `C.transferFrom(A, B, 1)`, `balanceOf(B)`. And we expect a correct result being `1,1,0,1`.

| Calls | `balanceOf(A)` | `balanceOf(B)` | `allowance(A,C)` | 
| --- | --- | --- | --- |
| Init state  | 1 | 0 | 0 |
| `A.approve(C,1)` | 1 | 0 | 1 |
| `C.transferFrom(A,B,1)` | 0 | 0 | 1 |

Exercise 3. AMM Design with Fixed Rate
---

![AMM design diagram](lab-amm-tff.png)

The figure above shows the workflow of the fixed-rate AMM you are going to build. Initially, two token contract accounts i.e., `TokenX` and `TokenY` are created by deploying the extended `BaddToken` you built in Exercise 2.

In Step 1, trader Alice approves $x$ units of `TokenX` from her account (EOA) to the AMM `Pool`'s contract account (CA). In Step 2, Alice calls the `Pool`'s function `swapXY(dx)`. Upon receiving Alice's transaction, the `Pool` internally calls `TokenY`'s `transfer` function to transfer $dy$ units of `TokenY` to Alice (Step 3). The `Pool` also internally calls `TokenX`'s `transferFrom` function to transfer Alice's $dx$ units of `TokenX` to Bob, fully spending the allowance (Step 4).

In this exercise, you can consider that $dy/dx = 2$. Implement the AMM smart contract using the following interface.

```
pragma solidity >=0.7.0 <0.9.0; 
contract AMM {
  BaddToken tokenX, tokenY;
  // _tokenX and _tokenY are contract-addresses running BaddToken SC
  constructor(address _tokenX, address _tokenY){
    tokenX = BaddToken(_tokenX); tokenY = BaddToken(_tokenY);
  }

  function swapXY(uint amountX) public payable {
    // fill out the following with your code
  } 
}
```

You can follow the workflow to execute your code.

- Write and compile an `Pool` smart contract.
- Deploy `BaddToken` smart contract twice, respectively to two contract addresses, say `TokenX` and `TokenY`.
- Deploy `Pool` smart contract with `TokenX` and `TokenY`.
- Execute the smart contracts in two steps: 
    - 1) call `TokenX`'s `transfer` function
    - 2) call `Pool`'s `swapXY` function

- Hint: You need to make sure your account has enough tokens for both `TokenX` and `TokenY`.

We will test your pool SC using the following test cases. `P` is the Pool CA, `X` is `TokenX` and `Y` is `TokenY`.

| Calls | `X.balanceOf(A)` | `X.balanceOf(P)` | `X.allowance(A,P)` |  `Y.balanceOf(A)` | `Y.balanceOf(P)` |
| --- | --- | --- | --- |
| Init state  | 1 | 0 | 0 | 0 | 2
| `A.approve(C,1)` | 1 | 0 | 1 | 0 | 2
| `A.swapXY(1)` | 0 | 1 | 0 | 2 | 0


Exercise 4. Constant-product AMM
---

Suppose the AMM account owns $x$ units of `TokenX` and $y$ units of `TokenY`. The AMM pool can use a function $f(x,y)$ to calculate the exchange rate between `TokenX` and `TokenY` on the fly. Specifically, it enforces that function value is constant before and after each token swap, that is,

$$f(x,y)=f(x+dx,y-dy)$$

In this exercise, you are asked to implement constant-product AMM (adopted in the real-life Uniswap), where $f(x,y)=x\*y$. Modify your AMM smart contract to support the constant-product invariant $x\*y=(x+dx)(y-dy)$.

- Hint: You may want to keep track of token balance $x$ and $y$ in the AMM smart contact by issuing `balanceOf` in each `swapXY` call.


Exercise 5. Security Hardening against Standalone Withdrawal 
---

The exercises so far (from 1 to 4) consider the normal scenarios. Starting from this exercise, we will consider a series of abnormal or security-oriented cases where Alice deviate from the normal cases, as shown in the following table.

| Case | tx1 | tx2 | Solution |
| --- | --- | --- | --- |
|  Normal case | Alice | Alice | Exercise 1-4 |
|  Standalone deposit  | Alice | NULL | Exercise 5 |
|  Standalone withdrawal (Pool theft) | NULL | Alice | Exercise 6 |
|  Unmatched swap (Trader theft) | Bob  | Alice | Exercise 7 |

In Exercise 5, consider an Alice who called `approve` function (the Deposit step) but did not call `swapXY` (the Withdrawal step). In practice, the reason can be that Alice regrets to do the trade when the deposit is done.

Extend your pool SC from the previous exercises to allow Alice to revert a swap already in progress. You may want to implement a function in the AMM
pool, say `rollback()`. After Step 1 and calling `rollback()`, Alice will have her original balance in `TokenX` and zero allowance to the pool. That is (`P` is the Pool CA):

| Calls | `balanceOf(A)` | `balanceOf(P)` | `allowance(A,P)` | 
| --- | --- | --- | --- |
| Init state  | 1 | 0 | 0 |
| `A.approve(C,1)` | 1 | 0 | 1 |
| `A.rollback()` | 1 | 0 | 0 |


Exercise 6. Security Hardening against Pool Theft
---

Consider an Alice who called `swapXY` (the Withdrawal step) but did not call `approve` (the Deposit step). In practice, this behavior can be due to that Alice is an adversarial user who wants to steal tokens from the pool.

Extend your pool SC from the previous exercises to defend the pool against the theft. Specifically, a standalone call to the `swapXY` without `approve` does not transfer any tokens. That is (`P` is the Pool CA):

| Calls | `balanceOf(A)` | `balanceOf(P)` | `allowance(A,P)` | 
| --- | --- | --- | --- |
| Init state  | 1 | 0 | 0 |
| `A.swapXY(1)` | 1 | 0 | 0 |

To do so, you may want to make the pool SC track all swaps in progress (i.e., the swap that did deposit but did not finish widthdrawal), so that an attempt to withdraw when there are no other ongoing swaps will be declined. 

Hint: Your pool SC can make a copy of the token balance so that an ongoing swap will appears as a difference between the balance in token SC and the copy of balance in the pool SC.


Exercise 7. Security Hardening against Trader Theft
---


Deliverable
---

- For all tasks, you should 1) submit your smart-contract code, and 2) show the screenshot of the program execution. 

