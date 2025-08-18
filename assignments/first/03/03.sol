// 13. 罗马数字转整数
// 简单
// 相关标签
// premium lock icon
// 相关企业
// 提示
// 罗马数字包含以下七种字符: I， V， X， L，C，D 和 M。

// 字符          数值
// I             1
// V             5
// X             10
// L             50
// C             100
// D             500
// M             1000
// 例如， 罗马数字 2 写做 II ，即为两个并列的 1 。12 写做 XII ，即为 X + II 。 27 写做  XXVII, 即为 XX + V + II 。

// 通常情况下，罗马数字中小的数字在大的数字的右边。但也存在特例，例如 4 不写做 IIII，而是 IV。数字 1 在数字 5 的左边，所表示的数等于大数 5 减小数 1 得到的数值 4 。同样地，数字 9 表示为 IX。这个特殊的规则只适用于以下六种情况：

// I 可以放在 V (5) 和 X (10) 的左边，来表示 4 和 9。
// X 可以放在 L (50) 和 C (100) 的左边，来表示 40 和 90。 
// C 可以放在 D (500) 和 M (1000) 的左边，来表示 400 和 900。
// 给定一个罗马数字，将其转换成整数。

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract RomanToInteger {
    // 转换主方法
    function romanToInt(string memory input) pure public returns(uint256){
        // 1.将字符串转为字节数组
        bytes memory inputBytes = bytes(input);
        uint256 len = inputBytes.length;
        uint256 res = 0;
        // 2.遍历字节数组
        for (uint256 i=0;i<len;i++) {
            // 3.获取当前和下一个字节
            uint256 cur = _byteToInt(inputBytes[i]);
            if (i+1<len) {
                uint256 next = _byteToInt(inputBytes[i+1]);
                // 4.处理特殊逻辑
                if (cur < next) {
                    res += next-cur;
                    i++;
                    continue;
                }
            }
            res += cur;
        }
        return res;
    }

    function _byteToInt(bytes1 char) private pure returns(uint256) {
       if (char == 'I') return 1;
        if (char == 'V') return 5;
        if (char == 'X') return 10;
        if (char == 'L') return 50;
        if (char == 'C') return 100;
        if (char == 'D') return 500;
        if (char == 'M') return 1000;
        revert("Invalid Roman character");
    }


    // 测试
    function Test() external pure {
        require(romanToInt("III") == 3,"test1 fail");
        require(romanToInt("IV") == 4,"test2 fail");
        require(romanToInt("XXVII") == 27,"test3 fail");
        require(romanToInt("XIV") == 14,"test4 fail");
    }
}