// SPDX-License-Identifier: MIT
pragma solidity ^0.8;

/*
 作业 1：ERC20 代币
任务：参考 openzeppelin-contracts/contracts/token/ERC20/IERC20.sol实现一个简单的 ERC20 代币合约。要求：
合约包含以下标准 ERC20 功能：
balanceOf：查询账户余额。
transfer：转账。
approve 和 transferFrom：授权和代扣转账。
使用 event 记录转账和授权操作。
提供 mint 函数，允许合约所有者增发代币。
提示：
使用 mapping 存储账户余额和授权信息。
使用 event 定义 Transfer 和 Approval 事件。
部署到sepolia 测试网，导入到自己的钱包
*/
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract MyERC20 is IERC20 {
    
    // 状态变量
    mapping (address => uint256) private _balances; // 余额
    mapping ( address => mapping(address => uint256)) private _allowances; // 授权
    uint256 private _totalSupply; // 总供应量
    address private _admin; // 管理员地址

    // 只有管理员可以操作
    modifier onlyAdmin {
        require(msg.sender==_admin,"Not admin");
        _;
    }

    constructor() {
        _admin = msg.sender;
    }

    // 增发代币
    function mint(address account,uint256 amount) external onlyAdmin {
        _balances[account] += amount;
        _totalSupply += amount;
        emit Transfer(address(0),account,amount);
    }

    // 查询总供应量
    function totalSupply() external view returns (uint256) {
        return _totalSupply;
    }
    // 查询余额
    function balanceOf(address account) external view returns (uint256) {
        return _balances[account];
    }
    // 当前用户转账
    function transfer(address to, uint256 value) external returns (bool){
        _balances[msg.sender] -= value;
        _balances[to] += value;
        emit Transfer(msg.sender,to,value);
        return true;
    }
    // 查询授权额度
    function allowance(address owner, address spender) external view returns (uint256) {
        return _allowances[owner][spender];
    }

    // 授权
    function approve(address spender, uint256 value) external returns (bool) {
        _allowances[msg.sender][spender] = value;
        emit Approval(msg.sender,spender,value);
        return true;
    }

    function transferFrom(address from, address to, uint256 value) external returns (bool) {
        _allowances[from][msg.sender] -= value;
        _balances[from] -= value;
        _balances[to] += value;
        emit Transfer(from,to,value);
        return true;
    }

}