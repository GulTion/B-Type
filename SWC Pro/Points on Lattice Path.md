---
test id: "1"
ques id: "1"
done?: true
tags:
  - binary_search
  - upper_bound
  - lower_bound
  - greedy
  - review
sr-due: 2026-06-08
sr-interval: 4
sr-ease: 270
---

### Problem Description
You are given a path on an infinite 2D lattice. The path starts from a fixed position and consists of line segments parallel to either the $x$-axis or $y$-axis, moving sequentially through a set of turning points. 

You are also given a separate set of $N$ points in the 2D space. Your task is to find how many of these given $N$ points lie exactly on the path mapped out by the turning points.

### Input
The input is structured as follows:
* The first line contains two integers: $N$ (the number of target points) and $M$ (the number of turning points defining the path).
* The next section contains $N$ integers denoting the $x$-coordinates of the $N$ points.
* The next section contains $N$ integers denoting the $y$-coordinates of the $N$ points.
* The next section contains $M$ integers denoting the $x$-coordinates of the turning points along the path in sequence.
* The final section contains $M$ integers denoting the $y$-coordinates of the turning points along the path in sequence.

### Output
Print a single integer representing the number of target points that lie on the specified path.

### Example
**Path Description:**
If the turning point coordinates are given as:
* $X = [1, 1, 2]$
* $Y = [1, 5, 5]$

see `test_lattice_path` for the test cases

The path traces line segments from $(1, 1) \rightarrow (1, 5) \rightarrow (2, 5)$. Any target point falling on these segments should be counted.
### Solutions
#### GulTion's Solution
```cpp
#include <bits/stdc++.h>
using namespace std;

bool checkon(vector<pair<int, int>> &a, int x, int y)
{
    auto range = equal_range(
        a.begin(), a.end(),
        make_pair(x, INT_MIN),
        [](const auto &lhs, const auto &rhs)
        {
            return lhs.first < rhs.first;
        });
    if (range.first != range.second)
    {
        int b = range.first->second;
        int c = prev(range.second)->second;
        return b <= y && c >= y;
    }
    return false;
}

int solve(
    vector<int> &tx,
    vector<int> &ty,
    vector<int> &tnx,
    vector<int> &tny)
{
    vector<pair<int, int>> tx_y(tnx.size()), ty_x(tny.size());
    for (size_t i = 0; i < tx_y.size(); i++)
    {
        tx_y[i] = make_pair(tnx[i], tny[i]);
        ty_x[i] = make_pair(tny[i], tnx[i]);
    }

    sort(tx_y.begin(), tx_y.end(), [](auto a, auto b)
         {
        if(a.first==b.first){
            return a.second<b.second;
        }
        return a.first<b.first; });

    sort(ty_x.begin(), ty_x.end(), [](auto a, auto b)
         {
        if(a.first==b.first){
            return a.second<b.second;
        }
        return a.first<b.first; });

    int sum = 0;
    for (int i = 0; i < tx.size(); i++)
    {
        sum += (checkon(tx_y, tx[i], ty[i]) || checkon(ty_x, ty[i], tx[i]));
    }

    return sum;
}

int main()
{
    int t;
    cin >> t;
    while (t--)
    {
        int n, m;
        cin >> n >> m;
        vector<int> tx(n), ty(n), tnx(m), tny(m);
        for (auto &i : tx) cin >> i;
        for (auto &i : ty) cin >> i;
        for (auto &i : tnx) cin >> i;
        for (auto &i : tny) cin >> i;

        cout << solve(tx, ty, tnx, tny) << "\n";
    }
}
```
