---
tags:
  - digit_dp
  - review
test id: "7"
ques id: "2"
done?: true
---
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

long long dp[101][2][1001];
string num;
long long dfs(int idx, bool tight, int curr_sum, int tar_sum)
{
    // base
    if (idx == num.length())
    {
        return curr_sum == tar_sum;
    }
    // mem return
    if (!tight && dp[idx][tight][curr_sum] != -1)
    {
        return dp[idx][tight][curr_sum];
    }

    int limit = tight ? (num[idx] - '0') : 9;
    long long sum = 0LL;
    for (int i = 0; i <= limit; i++)
    {
        bool new_tight = tight && i == limit;
        sum += dfs(idx + 1, new_tight, curr_sum + i, tar_sum);
    }
    if (!tight)
        dp[idx][tight][curr_sum] = sum;
    return sum;
}

long long solve(string A, int S)
{
    memset(dp, -1, sizeof(dp));
    num = A;
    return dfs(0, true, 0, S);
}

int main()
{
    int t;
    cin >> t;
    while (t--)
    {
        string A;
        int S;
        cin >> A >> S;
        cout << solve(A, S) << endl;
    }
}
```