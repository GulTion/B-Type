---
test id: "1"
ques id: "1"
done?: true
tags:
  - binary_search
  - upper_bound
  - lower_bound
  - greedy
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
