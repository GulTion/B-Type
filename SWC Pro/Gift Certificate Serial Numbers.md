## Test 7 - Q2: Gift Certificate Serial Numbers

### Problem Description
A company issues customized gift certificates every day. The printing system mandates a strict set of rules to validate issued certificates:
* Each certificate contains a unique identification serial number composed solely of digits ($0$-$9$).
* The sum of the individual digits making up a serial number must equal a specific daily target $S$.
* The maximum numerical upper-bound value a serial number can take is $A$. The number of digits in maximum bound $A$ is denoted by $N$.

Given the bound $A$ and the digit sum target $S$, calculate the maximum total number of unique gift certificates the company can validly issue.

As the answer can be extremely large, return the total count modulo $10^9 + 7$.

### Constraints
* $1 \le A < 10^{100}$ (Note: $A$ can be up to $100$ digits long)
* $1 \le S \le 1000$

### Examples

#### Example 1
**Input:**
* $A = 101, S = 3$

**Output:**
```text
4
```
**Explanation:** The valid certificates that can be produced are numbers $3, 12, 21, 30$. (Note that $102$ equals digit sum $3$ but violates the constraint $\le A$).

#### Example 2
**Input:**
* $A = 172, S = 3$

**Output:**
```text
7
```
**Explanation:** Valid numbers are $3, 12, 21, 30, 102, 111, 120$.

#### Example 3
**Input:**
* $A = 50, S = 4$

**Output:**
```text
5
```
**Explanation:** Valid serials are $4, 13, 22, 31, 40$.

#### Example 4
**Input:**
* $A = 999, S = 500$

**Output:**
```text
0
```
**Explanation:** The maximum possible digit sum for a $3$-digit number is $9+9+9 = 27$. A target sum of $500$ is unreachable.
### Solution
```cpp
#include <bits/stdc++.h>
using namespace std;

const int MOD = 1e9 + 7;

int solve(int pos, int remSum, bool tight, const string &A, vector<vector<vector<int>>> &dp) {
    if (remSum < 0) return 0;  // If remaining sum is negative, return 0
    if (pos == A.size()) return remSum == 0;  // Check if sum is exactly S

    if (dp[pos][remSum][tight] != -1) return dp[pos][remSum][tight];

    int limit = tight ? (A[pos] - '0') : 9;
    int ans = 0;

    for (int digit = 0; digit <= limit; digit++) {
        ans = (ans + solve(pos + 1, remSum - digit, tight && (digit == limit), A, dp)) % MOD;
    }

    return dp[pos][remSum][tight] = ans;
}

int main() {
    string A;
    int S;
    cin >> A >> S;

    int n = A.size();
    vector<vector<vector<int>>> dp(n + 1, vector<vector<int>>(S + 1, vector<int>(2, -1)));

    cout << solve(0, S, 1, A, dp) << endl;
    return 0;
}
```