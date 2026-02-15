/// @title DIOCoin ERC20 Token
/// @author Kaique Neves
/// @notice ERC20 token implementation for educational purposes
/// @dev Developed during DIO Binance Blockchain Bootcamp
// SPDX-License-Identifier: GPL-3.0
pragma solidity ^0.8.0;

interface IERC20 {

    function totalSupply() external view returns(uint256);

    function balanceOf(address account) external view returns (uint256);

    function allowance(address owner, address spender) external view returns (uint256);

    function transfer(address recipient, uint256 amount) external returns (bool);

    function approve(address spender, uint256 amount) external returns (bool);

    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
}

contract DIOCoin is IERC20 {

    string public constant name = "DIO Coin";
    string public constant symbol = "DIO";
    uint8 public constant decimals = 18;

    uint256 private totalSupply_;

    mapping(address => uint256) private balances;
    mapping(address => mapping(address => uint256)) private allowed;

    constructor() {
        totalSupply_ = 1000000 * 10 ** uint256(decimals);
        balances[msg.sender] = totalSupply_;
        emit Transfer(address(0), msg.sender, totalSupply_);
    }

    function totalSupply() public view override returns (uint256) {
        return totalSupply_;
    }

    function balanceOf(address account) public view override returns (uint256) {
        return balances[account];
    }

    function transfer(address recipient, uint256 amount) public override returns (bool) {
        require(recipient != address(0), "Endereco invalido");
        require(amount <= balances[msg.sender], "Saldo insuficiente");

        balances[msg.sender] -= amount;
        balances[recipient] += amount;

        emit Transfer(msg.sender, recipient, amount);
        return true;
    }

    function approve(address spender, uint256 amount) public override returns (bool) {
        require(spender != address(0), "Endereco invalido");

        allowed[msg.sender][spender] = amount;
        emit Approval(msg.sender, spender, amount);

        return true;
    }

    function allowance(address owner, address spender) public view override returns (uint256) {
        return allowed[owner][spender];
    }

    function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
        require(sender != address(0), "Endereco invalido");
        require(recipient != address(0), "Endereco invalido");
        require(amount <= balances[sender], "Saldo insuficiente");
        require(amount <= allowed[sender][msg.sender], "Allowance insuficiente");

        balances[sender] -= amount;
        balances[recipient] += amount;
        allowed[sender][msg.sender] -= amount;

        emit Transfer(sender, recipient, amount);
        return true;
    }
}
