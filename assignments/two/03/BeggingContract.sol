// SPDX-License-Identifier: MIT
pragma solidity ^0.8;

/*
✅ 作业3：编写一个讨饭合约
任务目标
使用 Solidity 编写一个合约，允许用户向合约地址发送以太币。
记录每个捐赠者的地址和捐赠金额。
允许合约所有者提取所有捐赠的资金。

任务步骤
编写合约
创建一个名为 BeggingContract 的合约。
合约应包含以下功能：
一个 mapping 来记录每个捐赠者的捐赠金额。
一个 donate 函数，允许用户向合约发送以太币，并记录捐赠信息。
一个 withdraw 函数，允许合约所有者提取所有资金。
一个 getDonation 函数，允许查询某个地址的捐赠金额。
使用 payable 修饰符和 address.transfer 实现支付和提款。
部署合约
在 Remix IDE 中编译合约。
部署合约到 Goerli 或 Sepolia 测试网。
测试合约
使用 MetaMask 向合约发送以太币，测试 donate 功能。
调用 withdraw 函数，测试合约所有者是否可以提取资金。
调用 getDonation 函数，查询某个地址的捐赠金额。

任务要求
合约代码：
使用 mapping 记录捐赠者的地址和金额。
使用 payable 修饰符实现 donate 和 withdraw 函数。
使用 onlyOwner 修饰符限制 withdraw 函数只能由合约所有者调用。
测试网部署：
合约必须部署到 Goerli 或 Sepolia 测试网。
功能测试：
确保 donate、withdraw 和 getDonation 函数正常工作。

提交内容
合约代码：提交 Solidity 合约文件（如 BeggingContract.sol）。
合约地址：提交部署到测试网的合约地址。
测试截图：提交在 Remix 或 Etherscan 上测试合约的截图。

额外挑战（可选）
捐赠事件：添加 Donation 事件，记录每次捐赠的地址和金额。
捐赠排行榜：实现一个功能，显示捐赠金额最多的前 3 个地址。
时间限制：添加一个时间限制，只有在特定时间段内才能捐赠。
*/
contract BeggingContract  {
    // 捐赠事件
    event Donation(address indexed sender,uint256 amount);
    // 提款事件.1:声明事件
    event WithDraw(address indexed owner,uint256 amount);

    // 每个地址捐赠总额
    mapping( address donater => uint256 amount) private _donations; 
    address private _owner;
    // 时间限制.1:声明状态变量：1.1.开始时间；1.2.结束时间；1.3.是否开启时间限制
    uint256 private donationStartTime;
    uint256 private donationEndTime;
    bool private timeRestrictionEnabled;
    // 捐赠排行榜.1:声明状态变量：1.1.创建结构体；1.2 声明排行榜
    struct Donor {
        address donator;// 捐赠者地址
        uint256 amount;// 捐赠金额
    }
    Donor[] public topDonors;

    constructor() {
        _owner = msg.sender;
    }
    // 限定合约所有者
    modifier onlyOwner {
        require(msg.sender==_owner,"you can't withdraw");
        _;
    }

    // 时间限制.3：时间限制判断修饰符
    modifier withinDonationTime() {
        if (timeRestrictionEnabled) {
            require(block.timestamp >= donationStartTime && block.timestamp <= donationEndTime, 
                "Donations are only accepted during the specified time period");
        }
        _;
    }
    // 时间限制.4：使用时间限制判断修饰符
    function donate() external payable withinDonationTime{
        // 更新捐赠记录
        _donations[msg.sender] += msg.value;
        // 捐赠排行榜.2:更新排行榜
        updateTopDonors(msg.sender,msg.value);
        // 捐赠事件.2:登记事件
        emit Donation(msg.sender,msg.value);
    }

    // 时间限制.2：设置时间限制
    function setDonationTime(uint256 startTime,uint256 endTime) external  {
        require(startTime<endTime,"startTime >= endTime");
        donationStartTime = startTime;
        donationEndTime = endTime;
        timeRestrictionEnabled = true;
    }

    function updateTopDonors(address donator,uint256 amount) internal {
        // 捐赠排行榜.2.1:判断捐赠者是否存在排行榜中
        bool isExist = false;
        uint256 index = topDonors.length;
        for (uint256 i=0;i<topDonors.length;i++) {
            if (topDonors[i].donator == donator) {
                isExist = true;
                index = i;
            }
        }

        // 捐赠排行榜.2.2:存在更新捐款额度，不存在直接添加
        if (isExist) {
            topDonors[index].amount += amount;
        } else {
            topDonors.push(Donor(donator,amount));
        }

        // 捐赠排行榜.2.3:对排行榜倒序排序
        for (uint256 i=0;i<topDonors.length;i++) {
            for (uint256 j=0;j<topDonors.length-i-1;j++) {
                if (topDonors[j].amount<topDonors[j+1].amount) {
                    Donor memory tmp = topDonors[j];
                    topDonors[j] = topDonors[j+1];
                    topDonors[j+1] = tmp;
                }
            }
        }
        // 捐赠排行榜.2.4:末位淘汰
        if (topDonors.length>3) {
            topDonors.pop();
        }
    }

    function withdraw() external onlyOwner {
        payable(msg.sender).transfer(address(this).balance);
    }

    function getDonation(address donater) public view returns(uint256){
        return _donations[donater];
    }
}