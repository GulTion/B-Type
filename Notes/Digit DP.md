## Sum of $S$ for the digit $0$ to $A$

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


## Count sum of $1$ in digit $0$ to $n$
```cpp
class Solution {
public:
    int dp[10][2][10];
    string num;
    int solve(int idx, int tight, int count){
        // base
        if(idx==num.length()){
            return count;
        }
        // memeory return
        if(!tight && dp[idx][tight][count]!=-1) 
	        return dp[idx][tight][count];

        int limit = tight?(num[idx]-'0'):9;
        int sum=0;
        for(int i=0;i<=limit; i++){
            int new_tight = tight&&i==limit;
            sum+=solve(idx+1, new_tight, count+(i==1));
        }
        if(!tight) dp[idx][tight][count]=sum;
        return sum;

    }
    int countDigitOne(int n) {
        memset(dp, -1, sizeof(dp));
        num = to_string(n);
        return solve(0, true,0);
    }
};
```
