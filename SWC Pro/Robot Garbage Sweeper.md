---
test id: "7"
ques id: "1"
done?: true
tags:
  - dp
  - review
id: robot_sweeper
sr-due: 2026-06-07
sr-interval: 3
sr-ease: 250
---
### Problem Description
You are given an array representing a sequence of trash values, where each element at index $i$ indicates the volume of garbage located there.

The operations run under the following mechanics:
* A specialized robot cleaner can be newly deployed at any index $i$ by spending a flat fee $m$.
* Once deployed at $i$, the robot cleans the garbage at index $i$ and can only migrate progressively forward to $i+1$.
* At any point in time, you accumulate an penalty score equal to the sum of all remaining uncleaned garbage values.

Find the minimum total operational cost required to clean all garbage fields. You are allowed to deploy any number of robots at any index layout.

### Input Format
* The first line contains $T$, the number of test cases.
* For each test case, the first line contains two integers $N$ (the number of garbage fields) and $M$ (the robot deployment fee).
* The second line contains $N$ integers representing the garbage volumes $A[i]$.

### Output Format
* For each test case, output a single integer representing the minimum total operational cost required to clean all garbage fields.

### Sample Input
```text
2
20 100
1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1
5 50
10 20 30 40 50
```

### Sample Output
```text
290
210
```



```cpp
#include <bits/stdc++.h>
using namespace std;
using ll = long long;
const int mx=1e5+1;
ll dp[20][mx];
ll m,n,i;
vector<long long> A;
ll solve(int in, int l){
    if(in==n)return 0;
    if(dp[in][l]!=-1)return dp[in][l];
    dp[in][l]=min((ll)m+solve(in+1,in),(ll)(in-l)*A[in]+solve(in+1,l));
    return dp[in][l];
}
int main() {
    n = 20;
    m = 100;
    A={1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,1,1,1,1};
    memset(dp,-1,sizeof(dp));
    for(i=0;i<n;i++){
        if(A[i]!=0){break;}
    }
    if(i==n){
        cout<<0<<endl;
    }else{
        ll ans= m + solve(i+1,i);
        cout << ans << "\n";
    }
    return 0;
}
```

#flashcards/robot_sweeper
What are the Conditions for the Solve function?
?
#### 1. Base Condition
$$\text{if } in = n \implies 0$$
#### 2. Memoization Condition
$$\text{if } dp[in][l] \neq -1 \implies dp[in][l]$$
#### 3. Transition Choices
$$dp[in][l] = \min \Big( m + solve(in+1, in), \, (in - l) \cdot A[in] + solve(in+1, l) \Big)$$

#flashcards/robot_sweeper 
What are the running code for robot sweeper?
?
$$m+solve(i+1, i)$$that means that we are deploying robot at index 0, and we have to find solution for $i+1$.


#flashcards/robot_sweeper 
What are the Steps for the robot sweeper problem?
?
1. find the index $i$ of first non-zero trash in the array.
2. if $i==n$ return 0 else use running condition $m+solve(i+1, i)$ at index $i$.
3. $solve(in, l)$ means, we are at index $in$, and we are deployed robot at index $l$.
4. solve function have three condition
	1. **Base Condition**: $\text{if } in = n \implies 0$
	2. **Memoization Condition**: $\text{if } dp[in][l] \neq -1 \implies dp[in][l]$
	3. **Transition Choices**: $$dp[in][l] = \min \Big( m + solve(in+1, in), (in - l) \cdot A[in] + solve(in+1, l) \Big)$$


	