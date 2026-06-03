## Test 5 - Q1: Cyclic String Merging

### Problem Description
You are given an array of strings. You can merge two strings $\text{arr}[i]$ and $\text{arr}[j]$ into a single combined string if and only if:
1. $i < j$
2. The last character of $\text{arr}[i]$ is equal to the first character of $\text{arr}[j]$.

For example, merging `"123"` and `"389"` results in `"123389"`.

You can continue chain-merging multiple strings sequentially. The objective is to form a valid **final** string such that its first character matches its ultimate last character. Find the maximum possible length of such a valid final string.

### Constraints
* $1 \le N \le 10^5$
* Individual string lengths $\le 10$

### Examples

#### Example 1
**Input:**
```text
arr = ["14", "123", "323", "321", "421", "535"]
```
**Output:**
```text
9
```
**Explanation:** Possible valid combinations include `"323"`, `"535"`, `"14421"`, and `"123323321"`. The longest is `"123323321"` with length $9$.

#### Example 2
**Input:**
```text
arr = ["14", "15", "89", "22"]
```
**Output:**
```text
2
```
**Explanation:** Only `"22"` satisfies the condition natively.

### Solution (C++)

#### Iterative DP Approach
```cpp
#include <bits/stdc++.h>

using namespace std;
using ll = long long;
const int mx = 1e5 + 1;
vector < string > v;
int n;
long long dp[mx][10][10];
long long solve(int i, int st, int end) {
  if (i == n) {
    return (st == end) ? 0 : INT_MIN;
  }
  if (dp[i][st][end] != -1) return dp[i][st][end];
  ll ans = solve(i + 1, st, end);
  if (st == end) ans = max(ans, 0 LL);
  if (v[i][0] - '0' == end) ans = max(ans, solve(i + 1, st, v[i].back() - '0') + (int) v[i].size());
  return dp[i][st][end] = ans;
}
int main() {
  int t;
  cin >> t;
  while (t--) {
    cin >> n;
    v.resize(n);
    memset(dp, -1, sizeof(dp));
    for (int i = 0; i < n; i++) cin >> v[i];
    int ans = 0;
    for (int i = 0; i < n; i++) {
      ans = max((ll) ans, solve(i, v[i][0] - '0', v[i][0] - '0'));
    }
    cout << ans << endl;
  }
}
```

---
