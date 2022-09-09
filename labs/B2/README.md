Lab B2: DEX 2: AMM and Pricing
===

Introduction
---

An automated market maker (AMM) is a decentralized-exchange (DEX) protocol. In an AMM, a trader does not directly trade with other traders. Instead, they trade with a smart-contract intermediary. In practice, AMM gets more widely adopted than other DEX forms (e.g., order book). For instance, the most popular DEX services, including Uniswap, Sushiswap, Pancakeswap, etc., all follow AMM protocols. In this lab, you will implement an AMM smart contract.


| Tasks | Points | CS student | Finance student |
| --- | --- | --- | --- |
|  1  | 20 |  Required | Bonus |
|  2  | 40 | Required | Bonus |
|  3  | 40 | Required | Bonus |


Exercise 1. Execute token transfer (same with B1)
---

The following smart contract implements a very simple token supporting the essential transfer function: `transfer(address sender, address recipient, uint256 amount)` 

```
pragma solidity >=0.7.0 <0.9.0; 
contract MyToken {  
  uint _totalSupply = 0; string _symbol;  
  mapping(address => uint) balances;  
  constructor(string memory symbol, uint256 initialSupply) {
    _symbol = symbol;
    _totalSupply = initialSupply;
    balances[msg.sender] = _totalSupply;  
  }
  
  function transfer(address receiver, uint nuTokenXs) public returns (bool) {    
    require(nuTokenXs <= balances[msg.sender]);        
    balances[msg.sender] = balances[msg.sender] - nuTokenXs;    
    balances[receiver] = balances[receiver] + nuTokenXs;    
    return true;  
  }

  function balanceOf(address account) public view returns(uint256){
    return balances[account];
  }}
```

Your job in this exercise is to deploy the above smart contract in Remix, creating an TokenX instance. Demonstrate the process that the TokenX issuer transfers 10 TokenX to another account, say Alice, and display each account's balance before/after the transfer.


Exercise 2. Impl. an fixed-rate AMM (1:2)
---

![AMM design diagram](lab-amm.jpg)

In the figure above, trader Alice first transfers `dx` units of TokenX from her account to an AMM pool's account. Then, she calls the AMM smart contract's function `trySwap(dx)`. Upon receiving Alice's transaction, the AMM smart contract internally calls TokenY's `transfer` function to transfer `dy` units of TokenY to Alice's account.

In this exercise, you can consider that dy/dx = 2. Implement the AMM smart contract.

```
contract AMM {
  MyToken tokenX, tokenY;
  // _tokenX is a CA running TokenX’s smart contract
  constructor(){
    tokenX = new MyToken("Token X", 100); tokenY = new MyToken("Token Y", 100);
  }

  function swapXY(uint amountX) public payable {
    // fill out the following with your code
  } 
}
```

- Workflow to execuse your code:
    - Write and compile a AMM smart contract
    - Deploy AMM smart contract.

Exercise 3. Impl. constant-product AMM
---

Suppose the AMM account owns `x` units of TokenX and `y` units of TokenY. The AMM pool can use a function `f(x,y)` to calculate the exchange rate between TokenX and TokenY on the fly. Specifically, it enforces that function value is constant before and after each token swap, that is,

`f(x,y)=f(x+dx,y-dy)`

In this exercise, you are asked to implement constant-product AMM (adopted in the real-life Uniswap), where `f(x,y)=x*y`. Modify your AMM smart contract to support  `x*y=(x+dx)(y-dy)`.


Deliverable
---

- For all tasks, you should 1) submit your smart-contract code, and 2) show the screenshot of the program execution. 

