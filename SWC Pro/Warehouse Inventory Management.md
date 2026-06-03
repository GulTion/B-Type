## Test 2: Warehouse Inventory Management

### Problem Description
You are in charge of maintaining inventory for a warehouse containing $N$ different goods. You have an initial stock of goods given by an array $A$ of size $N$.

Each day starts with an inflow of incoming goods given by another array $B$ of size $N$. Therefore, at the beginning of day $t$, the stock for each item $i$ updates to:
$$A[i] = A[i] + B[i]$$

After the inflow, you can choose exactly **one** type of good and export its entire stock, reducing its inventory to $0$ for that day. Before leaving for the day, you must report the total sum of all items remaining in the warehouse to headquarters.

Your task is to find the minimum number of days required to make the total combined stock of all items less than or equal to $K$ ($\le K$).

### Input & Output Format
#### Input
* The first line contains $T$, the number of test cases.
* For each test case, the first line contains two integers $N$ and $K$.
* The next $N$ lines each contain two integers: $A[i]$ (initial stock) and $B[i]$ (daily inflow rate).

#### Output
For each test case, print `#t` followed by the minimum number of days required. If it's impossible, print `-1`.

### Example Test Case (`small_edge.in`)
```text
5
3 100
10 5
20 10
5 2
2 0
10 10
5 5
1 10
10 5
1 5
10 2
3 10
0 100
0 200
0 300
```

### Example Output (`small_edge.out`)
```text
#1 0
#2 -1
#3 0
#4 1
#5 0
```

### Constraints
* $1 \le N \le 10^5$
* $0 \le K \le 10^{14}$

```cpp
#include <bits/stdc++.h>
using namespace std;
#define ll long long

void solve(ll ind, ll days, ll &mini, ll as, ll bs, ll &asum, ll &bsum, ll &n, ll &m, vector<pair<ll, ll>> &v)
{
    if (ind == n)
    {
        ll total = asum + bsum * days;
        if (total - as - bs <= m)
        {
            mini = min(mini, days);
        }
        return;
    }
    solve(ind + 1, days + 1, mini, as + v[ind].second, bs + (v[ind].first) * (days + 1), asum, bsum, n, m, v);
    solve(ind + 1, days, mini, as, bs, asum, bsum, n, m, v);
}

int main()
{
    ll T;
    cin >> T;
    for (ll t = 1; t <= T; t++)
    {
        ll n, M;
        cin >> n >> M;
        vector<pair<ll, ll>> v;
        ll asum = 0, bsum = 0;
        for (ll i = 0; i < n; i++)
        {
            ll a, b;
            cin >> a >> b;
            v.push_back({b, a});
            asum += a;
            bsum += b;
        }
        sort(v.begin(), v.end());

        if (asum <= M)
        {
            cout << "#" << t << " " << 0 << "\n";
        }
        else
        {
            ll mini = INT_MAX;
            solve(0, 0, mini, 0, 0, asum, bsum, n, M, v);
            if (mini == INT_MAX)
            {
                mini = -1;
            }
            cout << "#" << t << " " << mini << "\n";
        }
    }
    return 0;
}

```
---

