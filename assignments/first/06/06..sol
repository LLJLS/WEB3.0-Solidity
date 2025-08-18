// ✅  二分查找 (Binary Search)
// 题目描述：在一个有序数组中查找目标值。

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract BinarySearch {
    /**
     * 标准二分查找（升序数组）
     * 
     * @param arr 已排序的升序数组
     * @param target 要查找的目标值
     * @return 目标值的索引（找到时）或 type(uint).max（未找到时）
     */
    function binarySearch(uint[] memory arr, uint target) public pure returns (uint) {
        uint left = 0;
        uint right = arr.length;
        
        while (left < right) {
            uint mid = left + (right - left) / 2;
            
            if (arr[mid] == target) {
                return mid;
            }
            
            if (arr[mid] < target) {
                left = mid + 1;
            } else {
                right = mid;
            }
        }
        
        return type(uint).max; // 未找到
    }

    /**
     * 查找第一个大于等于目标的元素（左边界）
     * 
     * @param arr 已排序的升序数组
     * @param target 目标值
     * @return 第一个大于等于目标的元素索引
     */
    function lowerBound(uint[] memory arr, uint target) public pure returns (uint) {
        uint left = 0;
        uint right = arr.length;
        
        while (left < right) {
            uint mid = left + (right - left) / 2;
            
            if (arr[mid] < target) {
                left = mid + 1;
            } else {
                right = mid;
            }
        }
        
        return left; // 如果超出范围，返回 arr.length
    }

    /**
     * 查找第一个大于目标的元素（右边界）
     * 
     * @param arr 已排序的升序数组
     * @param target 目标值
     * @return 第一个大于目标的元素索引
     */
    function upperBound(uint[] memory arr, uint target) public pure returns (uint) {
        uint left = 0;
        uint right = arr.length;
        
        while (left < right) {
            uint mid = left + (right - left) / 2;
            
            if (arr[mid] <= target) {
                left = mid + 1;
            } else {
                right = mid;
            }
        }
        
        return left; // 如果超出范围，返回 arr.length
    }

    /**
     * 查找目标值范围 [lowerBound, upperBound)
     * 
     * @param arr 已排序的升序数组
     * @param target 目标值
     * @return start 第一个等于目标的索引
     * @return end 第一个大于目标的索引
     */
    function searchRange(uint[] memory arr, uint target) public pure returns (uint start, uint end) {
        start = lowerBound(arr, target);
        end = upperBound(arr, target);
        
        // 检查是否找到目标
        if (start == arr.length || arr[start] != target) {
            start = type(uint).max;
            end = type(uint).max;
        }
    }

    // 测试函数
    function testBinarySearch() public pure {
        uint[] memory arr = new uint[](10);
        arr[0] = 10;
        arr[1] = 20;
        arr[2] = 30;
        arr[3] = 40;
        arr[4] = 50;
        arr[5] = 60;
        arr[6] = 70;
        arr[7] = 80;
        arr[8] = 90;
        arr[9] = 100;
        
        // 标准查找测试
        require(binarySearch(arr, 50) == 4, "Test 1 failed");
        require(binarySearch(arr, 10) == 0, "Test 2 failed");
        require(binarySearch(arr, 100) == 9, "Test 3 failed");
        require(binarySearch(arr, 55) == type(uint).max, "Test 4 failed");
        
        // 边界查找测试
        require(lowerBound(arr, 35) == 3, "Test 5 failed");
        require(lowerBound(arr, 50) == 4, "Test 6 failed");
        require(lowerBound(arr, 105) == 10, "Test 7 failed");
        
        require(upperBound(arr, 50) == 5, "Test 8 failed");
        require(upperBound(arr, 100) == 10, "Test 9 failed");
        require(upperBound(arr, 5) == 0, "Test 10 failed");
        
        // 范围查找测试
        (uint start, uint end) = searchRange(arr, 50);
        require(start == 4 && end == 5, "Test 11 failed");
        
        (start, end) = searchRange(arr, 35);
        require(start == type(uint).max && end == type(uint).max, "Test 12 failed");
        
        // 测试重复元素
        uint[] memory dupArr = new uint[](5);
        dupArr[0] = 10;
        dupArr[1] = 20;
        dupArr[2] = 20;
        dupArr[3] = 20;
        dupArr[4] = 30;
        
        require(lowerBound(dupArr, 20) == 1, "Test 13 failed");
        require(upperBound(dupArr, 20) == 4, "Test 14 failed");
        
        (start, end) = searchRange(dupArr, 20);
        require(start == 1 && end == 4, "Test 15 failed");
        
        // 空数组测试
        uint[] memory empty = new uint[](0);
        require(binarySearch(empty, 5) == type(uint).max, "Test 16 failed");
        require(lowerBound(empty, 5) == 0, "Test 17 failed");
        require(upperBound(empty, 5) == 0, "Test 18 failed");
        (start, end) = searchRange(empty, 5);
        require(start == type(uint).max && end == type(uint).max, "Test 19 failed");
    }
}