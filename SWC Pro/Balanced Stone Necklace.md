---
test id: "3"
ques id: "1"
done?: true
tags:
  - dp
  - hash_map
  - prefix_sum
Test Case Folder:
---

### Problem Description
You are given a necklace represented as a string consisting only of red ('R') and blue ('B') stones. Your task is to make the number of blue stones and red stones remaining in the necklace exactly equal.

Stones can only be removed from either the absolute left end or the absolute right end of the sequence (essentially finding the longest contiguous subarray with an equal number of 'R' and 'B' stones).

Return the minimum number of stones that need to be removed to achieve an equal count.

### Input
A single string representing the sequence of stones on the necklace.

### Output
Print the minimum number of stones to remove.

### Examples
**Input:**
```text
BBRRBRBRBRBBR
```
**Output:**
```text
1
```

### Solution (C++)
```cpp
#include <iostream>
#include <map>
#include <string>
using namespace std;


int main(){
    string s;
    cin >> s;
    int n = s.size(), maxLen = 0, prefix = 0;
    map<int, int> first;
    first[0] = -1;


    for (int i = 0; i < n; i++){
        prefix += (s[i] == 'R' ? 1 : -1);
        if (first.find(prefix) == first.end())
            first[prefix] = i;
        else {
            int len = i - first[prefix];
            if (len > maxLen) maxLen = len;
        }
    }
   
    cout << n - maxLen << "\n";
    return 0;
}
```

---
