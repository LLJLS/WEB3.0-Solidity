// ✅  合并两个有序数组 (Merge Sorted Array)
// 题目描述：将两个有序数组合并为一个有序数组。


// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Merge {
    function merge(uint[] memory nums1, uint m, uint[] memory nums2, uint n) public pure returns (uint[] memory)  {
        uint[] memory result = new uint[](m + n);
        uint index1 = 0; uint index2 = 0; uint k = 0;
        while (index1 < m && index2 < n){
            if (nums1[index1] <= nums2[index2]) {
                result[k] = nums1[index1];
                index1++;
            } else {
                result[k] = nums2[index2];
                index2++;
            }
            k++;
        }
        while (index1 < m) {
            result[k] = nums1[index1];
            index1++;
            k++;
        }
        while (index2 < n) {
            result[k] = nums2[index2];
            index2++;
            k++;
        }
        return result;
    }
}