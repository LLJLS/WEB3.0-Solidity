// 七个不同的符号代表罗马数字，其值如下：

// 符号	值
// I	1
// V	5
// X	10
// L	50
// C	100
// D	500
// M	1000
// 罗马数字是通过添加从最高到最低的小数位值的转换而形成的。将小数位值转换为罗马数字有以下规则：

// 如果该值不是以 4 或 9 开头，请选择可以从输入中减去的最大值的符号，将该符号附加到结果，减去其值，然后将其余部分转换为罗马数字。
// 如果该值以 4 或 9 开头，使用 减法形式，表示从以下符号中减去一个符号，例如 4 是 5 (V) 减 1 (I): IV ，9 是 10 (X) 减 1 (I)：IX。仅使用以下减法形式：4 (IV)，9 (IX)，40 (XL)，90 (XC)，400 (CD) 和 900 (CM)。
// 只有 10 的次方（I, X, C, M）最多可以连续附加 3 次以代表 10 的倍数。你不能多次附加 5 (V)，50 (L) 或 500 (D)。如果需要将符号附加4次，请使用 减法形式。
// 给定一个整数，将其转换为罗马数字。

 

// 示例 1：

// 输入：num = 3749

// 输出： "MMMDCCXLIX"

// 解释：

// 3000 = MMM 由于 1000 (M) + 1000 (M) + 1000 (M)
//  700 = DCC 由于 500 (D) + 100 (C) + 100 (C)
//   40 = XL 由于 50 (L) 减 10 (X)
//    9 = IX 由于 10 (X) 减 1 (I)
// 注意：49 不是 50 (L) 减 1 (I) 因为转换是基于小数位
// 示例 2：

// 输入：num = 58

// 输出："LVIII"

// 解释：

// 50 = L
//  8 = VIII
// 示例 3：

// 输入：num = 1994

// 输出："MCMXCIV"

// 解释：

// 1000 = M
//  900 = CM
//   90 = XC
//    4 = IV
 

// 提示：

// 1 <= num <= 3999

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract IntegerToRoman {
    // 主转换函数
    function intToRoman(uint256 num) public pure returns (string memory) {
        // 验证输入范围 (1-3999)
        require(num > 0 && num < 4000, "Input must be 1-3999");
        
        // 存储结果
        bytes memory roman = new bytes(20); // 最大长度: MMMCMXCIX (15字符)
        uint256 index = 0;
        
        // 定义罗马数字单位和对应的整数值
        string[13] memory numerals = [
            "M", "CM", "D", "CD", "C", "XC", "L", "XL", "X", "IX", "V", "IV", "I"
        ];
        uint256[13] memory values = [
            uint256(1000), 900, 500, 400, 100, 90, 50, 40, 10, 9, 5, 4, 1
        ];
        
        // 使用贪心算法转换
        for (uint256 i = 0; i < values.length; i++) {
            while (num >= values[i]) {
                // 获取当前符号的字节表示
                bytes memory symbol = bytes(numerals[i]);
                
                // 将符号添加到结果中
                for (uint256 j = 0; j < symbol.length; j++) {
                    roman[index++] = symbol[j];
                }
                
                num -= values[i];
            }
        }
        
        // 将字节数组转为字符串
        return string(abi.encodePacked(trimBytes(roman, index)));
    }
    
    // 辅助函数：修剪字节数组到实际长度
    function trimBytes(bytes memory data, uint256 length) private pure returns (bytes memory) {
        bytes memory result = new bytes(length);
        for (uint256 i = 0; i < length; i++) {
            result[i] = data[i];
        }
        return result;
    }
    
    // 测试函数（实际部署时应移除）
    function testConversions() public pure {
        // 基本转换测试
        require(keccak256(bytes(intToRoman(1))) == keccak256("I"), "Test 1 failed");
        require(keccak256(bytes(intToRoman(4))) == keccak256("IV"), "Test 4 failed");
        require(keccak256(bytes(intToRoman(9))) == keccak256("IX"), "Test 9 failed");
        require(keccak256(bytes(intToRoman(58))) == keccak256("LVIII"), "Test 58 failed");
        require(keccak256(bytes(intToRoman(1994))) == keccak256("MCMXCIV"), "Test 1994 failed");
        
        // 边界测试
        require(keccak256(bytes(intToRoman(3999))) == keccak256("MMMCMXCIX"), "Test 3999 failed");
        require(keccak256(bytes(intToRoman(1000))) == keccak256("M"), "Test 1000 failed");
        require(keccak256(bytes(intToRoman(888))) == keccak256("DCCCLXXXVIII"), "Test 888 failed");
        
        // 特殊组合测试
        require(keccak256(bytes(intToRoman(40))) == keccak256("XL"), "Test 40 failed");
        require(keccak256(bytes(intToRoman(90))) == keccak256("XC"), "Test 90 failed");
        require(keccak256(bytes(intToRoman(400))) == keccak256("CD"), "Test 400 failed");
        require(keccak256(bytes(intToRoman(900))) == keccak256("CM"), "Test 900 failed");
    }
}

