pragma solidity >=0.7.0 <0.9.0; 
contract BaddToken {  
  uint _totalSupply = 0; string _symbol;  
  mapping(address => uint) balances;  
  mapping(address => mapping(address => uint)) public allowance_storage;
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
  }
  
  function approve(address spender, uint amount) external returns (bool) {
        allowance_storage[msg.sender][spender] = amount;
        return true;
    }
  function allowance(address owner, address spender) external view returns (uint256)
  {
    return allowance_storage[owner][spender];
  }
    function transferFrom(
        address sender,
        address recipient,
        uint amount
    ) external returns (bool) {
        allowance_storage[sender][msg.sender] -= amount;
        balances[sender] -= amount;
        balances[recipient] += amount;
        return true;
    }
  
  }

contract AMM {
  BaddToken tokenX;
  BaddToken tokenY;
  // _tokenX and _tokenY are contract-addresses running BaddToken SC
  constructor(address _tokenX, address _tokenY){
    tokenX = BaddToken(_tokenX); tokenY = BaddToken(_tokenY);
  }

  function swapXY(uint amountX) public payable {
    // fill out the following with your code
    uint256 dx;
    uint256 dy;
    uint256 balance_x;
    uint256 balance_y;
    uint256 const;
    balance_x = tokenX.balanceOf(address(this));
    balance_y = tokenY.balanceOf(address(this));
    const = balance_x*balance_y;
    
    dx = amountX;
    dy = balance_y-const/(balance_x+dx);
    tokenX.transferFrom(msg.sender,address(this),dx);
    tokenY.transfer(msg.sender,dy);   
  } 
    function swapYX(uint amountY) public payable {
    // fill out the following with your code
    uint256 dx;
    uint256 dy;
    uint256 balance_x;
    uint256 balance_y;
    uint256 const;
    balance_x = tokenX.balanceOf(address(this));
    balance_y = tokenY.balanceOf(address(this));
    const = balance_x*balance_y;
    
    dy = amountY;
    dx = balance_x-const/(balance_y+dy);
    tokenY.transferFrom(msg.sender,address(this),dy);
    tokenX.transfer(msg.sender,dx);
    
  } 
}