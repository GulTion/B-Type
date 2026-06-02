

## Test 1: Points on Lattice Path

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
#### Other Solution
```cpp
#include <bits/stdc++.h>
using namespace std;

// Function to check if a value lies within any segment
bool isInSegment(const set<pair<int, int>> &segments, int val) {
    if (segments.empty()) return false;
   
    auto it = segments.upper_bound({val, INT_MAX});
    if (it != segments.begin()) {
        --it;
        if (it->first <= val && val <= it->second)
            return true;
    }
    return false;
}

// Function to merge overlapping segments in a single linear pass
void mergeOverlappingSegments(vector<pair<int, int>> &rawSegments, set<pair<int, int>> &mergedSegments) {
    if (rawSegments.empty()) return;
   
    // Sort segments by start position
    sort(rawSegments.begin(), rawSegments.end());
   
    // Initialize with first segment
    int start = rawSegments[0].first;
    int end = rawSegments[0].second;
   
    // Process all segments in a linear pass
    for (int i = 1; i < rawSegments.size(); i++) {
        if (rawSegments[i].first <= end + 1) {
            // Current segment overlaps or is adjacent, extend end
            end = max(end, rawSegments[i].second);
        } else {
            // No overlap, insert previous merged segment and start new one
            mergedSegments.insert({start, end});
            start = rawSegments[i].first;
            end = rawSegments[i].second;
        }
    }
   
    // Insert the last merged segment
    mergedSegments.insert({start, end});
}

int countPointsOnPath(vector<int> &Xq, vector<int> &Yq, vector<int> &Xp, vector<int> &Yp) {
    int M = Xp.size(), N = Xq.size();
   
    // Store raw segments first
    map<int, vector<pair<int, int>>> rawVertical, rawHorizontal;
    map<int, set<pair<int, int>>> vertical, horizontal;

    // Collect all segments
    for (int i = 1; i < M; ++i) {
        int x1 = Xp[i - 1], y1 = Yp[i - 1];
        int x2 = Xp[i], y2 = Yp[i];

        if (x1 == x2) // Vertical segment
            rawVertical[x1].push_back({min(y1, y2), max(y1, y2)});
        else // Horizontal segment
            rawHorizontal[y1].push_back({min(x1, x2), max(x1, x2)});
    }
   
    // Process all segments to merge overlapping ones
    for (auto &pai : rawVertical) {
        auto key=pai.first;
        auto segments=pai.second;
        mergeOverlappingSegments(segments, vertical[key]);
    }
   
    for (auto &pai : rawHorizontal) {
        auto key=pai.first;
        auto segments=pai.second;
        mergeOverlappingSegments(segments, horizontal[key]);
    }

    // Check query points
    int count = 0;
    for (int i = 0; i < N; ++i) {
        if (isInSegment(vertical[Xq[i]], Yq[i]) || isInSegment(horizontal[Yq[i]], Xq[i]))
            count++;
    }

    return count;
}

int main() {
    int T;
    cin >> T;
   
    while (T--) {
        int N, M;
        cin >> N >> M; // Number of query points and path points
       
        vector<int> Xq(N), Yq(N), Xp(M), Yp(M);
       
        for (int i = 0; i < N; i++) cin >> Xq[i];
        for (int i = 0; i < N; i++) cin >> Yq[i];
        for (int i = 0; i < M; i++) cin >> Xp[i];
        for (int i = 0; i < M; i++) cin >> Yp[i];
       
        cout <<"#"<<countPointsOnPath(Xq, Yq, Xp, Yp) << endl;
    }
   
    return 0;
}
```

---

## Test 2: Warehouse Inventory Management

### Problem Description
You are in charge of maintaining inventory for a warehouse containing $N$ different goods. You have an initial stock of goods given by an array $A$ of size $N$.

Each day starts with an inflow of incoming goods given by another array $B$ of size $N$. Therefore, at the beginning of day $t$, the stock for each item $i$ updates to:
$$A[i] = A[i] + B[i]$$

After the inflow, you can choose exactly **one** type of good and export its entire stock, reducing its inventory to $0$ for that day. Before leaving for the day, you must report the total sum of all items remaining in the warehouse to headquarters.

Your task is to find the minimum number of days required to make the total combined stock of all items less than or equal to $K$ ($\le K$).

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

## Test 3: Balanced Stone Necklace

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

## Test 4: Q1 City Truck Delivery Optimization

### Problem Description
There is a 2D matrix grid of size $H \times W$ representing a city map. Each cell in the grid represents a specific feature designated by an integer code:
* `0` $\rightarrow$ Road
* `1` $\rightarrow$ Tree (Obstacle)
* `2` $\rightarrow$ Garage (Starting Point)
* `3` $\rightarrow$ Warehouse (Loading Point)
* `4` $\rightarrow$ Airport (Unloading Point)

A delivery truck starts parked at the Garage (`2`). The truck's task is to drive to one or many Warehouses (`3`), load cargo goods, and transport them to be unloaded at the Airport (`4`). 

There is no limit to the number of goods the truck can carry simultaneously. However, operating the truck incurs a variable movement cost based on its weight. Moving one block costs:
$$\text{Cost} = 1 \times (1 + \text{Number of goods currently loaded})$$

* Moving $1$ block with an empty truck costs $1$.
* Moving $1$ block carrying $1$ good costs $2$.
* Moving $1$ block carrying $2$ goods costs $3$, and so on.

The truck cannot pass through any cell containing a Tree (`1`). When visiting a warehouse, loading goods is optional. Similarly, visiting an airport does not mandate unloading. Find the maximum total number of goods that can be successfully unloaded at the airport given a maximum budget cost $C$.

### Constraints
* **Number of test cases:** $\le 50$
* $2 \le H, W \le 40$
* $5 \le C \le 2000$
* Maximum number of warehouses $\le 13$

### Solution (C++)
```cpp
#include <iostream>
#include <vector>
#include <queue>
using namespace std;

typedef long long ll;
const ll INF = 1e9;
const ll dx[] = {0, 1, -1, 0}, dy[] = {1, 0, 0, -1};

void bfs(int sx, int sy, vector<vector<ll>> &dist, const vector<vector<ll>> &mat) {
    int h = mat.size(), w = mat[0].size();
    queue<pair<ll, ll>> q;
    dist[sx][sy] = 0;
    q.push({sx, sy});
    while (!q.empty()) {
        auto [x, y] = q.front(); q.pop();
        for (int i = 0; i < 4; i++) {
            int nx = x + dx[i], ny = y + dy[i];
            if (nx >= 0 && ny >= 0 && nx < h && ny < w && mat[nx][ny] != 1 && dist[nx][ny] > dist[x][y] + 1) {
                dist[nx][ny] = dist[x][y] + 1;
                q.push({nx, ny});
            }
        }
    }
}

void solve() {
    int t; cin >> t;
    while (t--) {
        ll h, w, c, gx, gy, ax, ay;
        cin >> h >> w >> c;
        vector<vector<ll>> mat(h, vector<ll>(w));
        vector<pair<ll, ll>> warehouses;
       
        for (ll i = 0; i < h; i++)
            for (ll j = 0; j < w; j++) {
                cin >> mat[i][j];
                if (mat[i][j] == 2) gx = i, gy = j;
                if (mat[i][j] == 4) ax = i, ay = j;
                if (mat[i][j] == 3) warehouses.emplace_back(i, j);
            }
       
        vector<vector<ll>> ds(h, vector<ll>(w, INF)), dd(h, vector<ll>(w, INF));
        bfs(gx, gy, ds, mat);
        bfs(ax, ay, dd, mat);
       
        ll max_goods = 0;
        for (auto [wx, wy] : warehouses) {
            ll cost = c - ds[wx][wy];
            if (cost > 0) {
                cost = (cost / dd[wx][wy]) - 1;
                if (cost > 0) max_goods = max(max_goods, cost);
            }
        }
        cout << max_goods << "\n";
    }
}

int main() {
    ios_base::sync_with_stdio(false); cin.tie(NULL);
    solve();
}
```

---

## Test 4 - Q2: Tile Selection Minimization

### Problem Description
Given $N$ geometric tiles, where each tile has a specified width and height. You need to select exactly $K$ tiles out of the $N$ available. 

Your objective is to minimize the maximum difference between any pair of selected tiles. The structural difference between two tiles $i$ and $j$ is defined as:
$$\text{Difference} = \max(|H_i - H_j|, |W_i - W_j|)$$
#### Solution
```cpp
#include <iostream>
 #include <vector>
 
 
 using namespace std;
 
 
 typedef long long ll;
 #define fastio ios_base::sync_with_stdio(false); cin.tie(NULL); cout.tie(NULL);
 
 
 void solve() {
     int n, k;
     cin >> n >> k;
    
     vector<vector<int>> freq(401, vector<int>(401, 0));
    
     for (int i = 0; i < n; i++) {
         int x, y;
         cin >> x >> y;
         freq[x][y]++;
     }
    
     for (int i = 0; i < 401; i++) {
         for (int j = 0; j < 401; j++) {
             if (i > 0) freq[i][j] += freq[i - 1][j];
             if (j > 0) freq[i][j] += freq[i][j - 1];
             if (i > 0 && j > 0) freq[i][j] -= freq[i - 1][j - 1];
         }
     }
    
     int low = 0, high = 400, ans = 400;
    
     auto isValid = [&](int mid) {
         for (int i = 0; i + mid < 401; i++) {
             for (int j = 0; j + mid < 401; j++) {
                 int cnt = freq[i + mid][j + mid];
                 if (i > 0) cnt -= freq[i - 1][j + mid];
                 if (j > 0) cnt -= freq[i + mid][j - 1];
                 if (i > 0 && j > 0) cnt += freq[i - 1][j - 1];
                 if (cnt >= k) return true;
             }
         }
         return false;
     };
    
     while (low <= high) {
         int mid = (low + high) / 2;
         if (isValid(mid)) {
             ans = mid;
             high = mid - 1;
         } else {
             low = mid + 1;
         }
     }
    
     cout << ans << "\n";
 }
 
 
 int main() {
     fastio;
     solve();
     return 0;
 }
 
```
---

## Test 4 - Q3: Stone Removal Cost

### Problem Description
You are given a sequence of stones that need to be completely cleared out. Removing a stone incurs a cost depending on its current adjacent neighbors at the time of removal:
* Different cost if it has **one neighbor**.
* Different cost if it has **two neighbors**.
* **Zero cost** ($0$) if it has no neighbors left.

Each individual stone has its own distinct cost parameters for each neighbor condition. Find the minimum total cost required to remove all stones from the sequence.

### Solution
```cpp
#include <iostream>
#include <vector>
#include <algorithm>
using namespace std;


long long min_removal_cost(int n, const vector<long long>& a, const vector<long long>& b) {
    // dp[i][0] = min cost for stones 1..i if stone i+1 is removed before stone i
    // dp[i][1] = min cost for stones 1..i if stone i+1 is removed after stone i
    vector<vector<long long>> dp(n + 1, vector<long long>(2, 0));
   
    // Base case for the first stone
    dp[1][0] = 0;
    dp[1][1] = a[0];
   
    // Fill dp table for stones 2..n
    for (int i = 2; i <= n; ++i) {
        dp[i][0] = min(dp[i - 1][0] + a[i - 1], dp[i - 1][1] + 0);
        dp[i][1] = min(dp[i - 1][0] + b[i - 1], dp[i - 1][1] + a[i - 1]);
    }
   
    // The answer is dp[n][0] because stone n+1 doesn't exist
    return dp[n][0];
}


int main() {
    int n;
    cin >> n;
   
    vector<long long> a(n), b(n);
    // Read cost array a (cost if stone is removed before its neighbor)
    for (int i = 0; i < n; ++i) {
        cin >> a[i];
    }
    // Read cost array b (cost if stone is removed after its neighbor)
    for (int i = 0; i < n; ++i) {
        cin >> b[i];
    }
   
    cout << min_removal_cost(n, a, b) << endl;
    return 0;
}

```

---

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

## Test 5 - Q2: Optimal Threshold Score Difference

### Problem Description
You are given two arrays $A$ and $B$ of size $N$. You need to choose an integer threshold $D$. The performance score of any element $x$ in either array is evaluated using the following rule:
$$\text{Score}(x) = \begin{cases} 1 & \text{if } x \le D \ 2 & \text{if } x > D \end{cases}$$

The total score of an array is the sum of scores of its elements. Your task is to find a threshold $D$ within the valid range that maximizes the difference:
$$\text{Maximized Value} = \text{Total Score}(A) - \text{Total Score}(B)$$

### Constraints
* $1 \le A.\text{size}(), B.\text{size}() \le 10^5$
* $1 \le A[i], B[i] \le 10^8$
* $0 \le D \le 10^9$

### solution
```cpp

#include <bits/stdc++.h>
using namespace std;
int maxDiffD(const vector<int> &a, const vector<int> &b)
{
    vector<int> sa = a, sb = b;
    sort(sa.begin(), sa.end());
    sort(sb.begin(), sb.end());

    set<int> s;
    for (int x : sa)s.insert(x);
    for (int x : sb)s.insert(x);

    vector<int> c;
    c.push_back(*s.begin() - 1);
    for (int x : s)
        c.push_back(x);
    c.push_back(*s.rbegin() + 1);

    int mx = INT_MIN, bestD = 0;
    for (int d : c)
    {
        int ca = upper_bound(sa.begin(), sa.end(), d) - sa.begin();
        int cb = upper_bound(sb.begin(), sb.end(), d) - sb.begin();

        int as = ca + (sa.size() - ca) * 2;
        int bs = cb + (sb.size() - cb) * 2;

        int diff = as - bs;
        if (diff > mx)
        {
            mx = diff;
            bestD = d;
        }
    }
    return bestD;
}
int main()
{
    int t;cin >> t;
    while (t--){
        int n, m;cin >> n >> m;
        vector<int> a(n), b(m);
        for (int i = 0; i < n; i++)cin >> a[i];
        for (int i = 0; i < m; i++)cin >> b[i];
        cout << "Optimal D: " << maxDiffD(a, b) << endl;
    }
    return 0;
}
```

---

## Test 6: Q1-Simultaneous Car Rendezvous

### Problem Description
There are $N$ cars parked at separate initial coordinates on an $x$-$y$ cartesian plane. All initial coordinates reside inside a bounded square region extending from $(-M, -M)$ to $(M, M)$.

You need to coordinate the movement of all $N$ cars so that they reach a specific rendezvous location $(p, q)$ at the **exact same drive step**. The travel execution operates in discrete synchronized drives structured as follows:
* **Drive 1:** Every moving car travels a total path length of exactly $1$ unit.
* **Drive 2:** Every moving car travels a total path length of exactly $2$ units.
* $\dots$
* **Drive $t$:** Every moving car travels a total path length of exactly $t$ units.

During any single drive step, a car can move in standard orthogonal grid directions: Left, Right, Up, or Down. Re-visiting coordinates within a drive sequence is completely permitted (e.g., if a car is executing Drive $5$, it can perform $2$ downs, $2$ ups, and $1$ right to effectively displace by only $1$ net unit). 

Find the minimum number of drives required for all cars to land on $(p, q)$ simultaneously. If it is mathematically impossible, return `-1`.

### Constraints
* $1 \le N \le 100$
* $1 \le M \le 10^{17}$

### Examples

#### Example 1
**Input:**
* $N = 2$
* Target Destination: $(1, 1)$
* Car Positions: $(2, 3)$ and $(-4, 1)$

**Output:**
```text
5
```
**Explanation:** Total distance moves budget accumulated across $5$ drives = $1 + 2 + 3 + 4 + 5 = 15$ units.

#### Example 2
**Input:**
* $N = 2$
* Target Destination: $(0, 0)$
* Car Positions: $(0, 1)$ and $(0, 2)$

**Output:**
```text
-1
```

### Solution

```cpp
#include<bits/stdc++.h>
#define ll long long
#define MAXN 100

using namespace std;

ll a[MAXN];

ll parity(ll n) {
	// finding the max distance that we have to reach
	ll x = *max_element(a, a + n);

	// finding number of drives / turns it will take to reach or cross the max distance
	ll turns = (ll)ceil((sqrt(1 + 8 * x) - 1 ) / 2);

	// finding the actual distance reached for the above number of turns
	ll actual = (turns * (turns + 1)) / 2;

	// replacing the distances with the parity of the difference between distance reached and the distance to be reached
	for(int i = 0; i < n; i++)
		a[i] = (actual - a[i]) & 1;

	// returning the turns for the answer
	return turns;
}

void solve(){
	ll n, m;
	cin >> n >> m;

	ll p, q, x, y;
	cin >> p >> q;
	for(int i = 0 ; i < n; i++) {
		cin >> x >> y;

		// calculating the min distace to reach the center
		a[i] = abs(max(p, x) - min(p, x)) + abs(max(q, y) - min(q, y));
	}

	// converting the array to the parity array of extra distance as well as returning the turns 
	ll turns = parity(n);

	for(int i = 0; i < n; i++) {
		if(a[0] != a[i]){
			cout << -1 << "\n";
			return;
		}
	}

	// if the parity of the distance array is 1 and the turns is also 1 then in the next turn it will be even.
	// we cannot filp in even turns, so we need 2 extra turns.
	if(a[0] && turns & 1)
		cout << turns + 2 << "\n";

	// else we can filp in the next turn
	else if(a[0])
		cout << turns + 1 << "\n";

	// else we are already at the destination
	else
		cout << turns << "\n";

}

int main(){
    ios_base :: sync_with_stdio(false);
    cin.tie(NULL);
    cout.tie(NULL);
	ll t, cnt = 1; 
	cin >> t;
	while(t--){
		cout << "# " << cnt << " ";
		solve();
		cnt++;
	}
}
```
---

## Test 7 - Q1: Robot Garbage Sweeper

### Problem Description
You are given an array representing a sequence of trash values, where each element at index $i$ indicates the volume of garbage located there. 

The operations run under the following mechanics:
* A specialized robot cleaner can be newly deployed at any index $i$ by spending a flat fee $m$.
* Once deployed at $i$, the robot cleans the garbage at index $i$ and can only migrate progressively forward to $i+1$.
* At any point in time, you accumulate an penalty score equal to the sum of all remaining uncleaned garbage values.

Find the minimum total operational cost required to clean all garbage fields. You are allowed to deploy any number of robots at any index layout.

// 3 1 4 1 5 
// m = 2 -> 8

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

---

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