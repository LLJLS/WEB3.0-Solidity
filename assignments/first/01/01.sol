// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;
// ✅ 创建一个名为Voting的合约，包含以下功能：
// 一个mapping来存储候选人的得票数
// 一个vote函数，允许用户投票给某个候选人
// 一个getVotes函数，返回某个候选人的得票数
// 一个resetVotes函数，重置所有候选人的得票数
contract Voting{
     mapping(address => uint) private voter_ticket; 
     mapping(address => bool) private voter_flag;
     address[] private keys_ticket;
     address[] private keys_flag;

    constructor() {

    }

    modifier onlyOne(address candidate) {
        require(voter_flag[msg.sender]==false,"you have voted,you can't vote again");
        _;
    }
    function vote(address candidate) external onlyOne(candidate) {
        voter_flag[msg.sender] = true;
        voter_ticket[candidate] += 1;
        keys_flag.push(msg.sender);
        keys_ticket.push(candidate);
    }

    function getVotes(address candidate) external view returns (uint){
         return voter_ticket[candidate];
    }

    function resetVotes() external {
        for (uint i=0; i<keys_ticket.length; i++) 
        {
                delete voter_flag[keys_flag[i]];
        }
        delete keys_flag;

         for (uint i=0; i<keys_ticket.length; i++) 
        {
                delete voter_ticket[keys_ticket[i]];
        }
        delete keys_ticket;
    }





}
