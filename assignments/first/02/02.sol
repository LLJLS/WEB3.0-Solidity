// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;
// ✅ 反转字符串 (Reverse String)
// 题目描述：反转一个字符串。输入 "abcde"，输出 "edcba"

contract task02 {
    function reverseString(string memory input) public pure returns(string memory) {
        bytes memory binput = bytes(input);
        bytes memory resb = new bytes(binput.length);
        string memory resStr;
        for (uint i=0;i<binput.length;i++) {
            resb[i] = binput[binput.length-i-1];
        }
        resStr = string(resb);
        return resStr;

    }
}