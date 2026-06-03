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

### Input & Output Format
#### Input Format
* The first line contains $T$, the number of test cases.
* For each test case:
  * The first line contains three integers $H$, $W$, and $C$.
  * The next $H$ lines each contain $W$ integers representing the grid layout features.

#### Output Format
* For each test case, print a single integer representing the maximum total number of goods that can be successfully transported and unloaded at the airport within the budget $C$.

### Example Test Case (`small_edge.in`)
```text
4
2 2 7
3 3
4 2
3 3 14
3 0 4
1 0 0
0 3 2
3 3 13
0 0 1
3 2 4
3 3 0
3 4 14
0 0 0 1
0 0 3 0
1 2 1 4
```

### Example Output (`small_edge.out`)
```text
4
4
5
5
```

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
