---
test id: "4"
ques id: "2"
tags:
  - lower_bound
  - upper_bound
  - binary_search
  - segment_tree
  - sliding_window
  - review
id: tile_selection
done?: true
---
### Problem Description
Given $N$ geometric tiles, where each tile has a specified width and height. You need to select exactly $K$ tiles out of the $N$ available. 

Your objective is to minimize the maximum difference between any pair of selected tiles. The structural difference between two tiles $i$ and $j$ is defined as:
$$\text{Difference} = \max(|H_i - H_j|, |W_i - W_j|)$$

### Input Format
- The first line contains two integers $N$ and $K$ — the total number of available tiles and the number of tiles to select, respectively.
- The next $N$ lines each contain two space-separated integers $H_i$ and $W_i$ — the height and width of the $i$-th tile.

### Output Format
- Print a single integer representing the minimum possible maximum structural difference among the $K$ chosen tiles.

### Sample Input & Output

#### Sample Input
```text
4 3
10 20
12 25
15 18
30 40
```

#### Sample Output
```text
7
```

#### Solution
##### for high contrains
```cpp
#include <iostream>
#include <vector>
#include <algorithm>

using namespace std;

typedef long long ll;

struct Point {
    ll x, y;
};

struct SegmentTree {
    int n;
    vector<int> t, lazy;

    SegmentTree(int size) {
        n = size;
        t.assign(4 * n, 0);
        lazy.assign(4 * n, 0);
    }

    void reset() {
        fill(t.begin(), t.end(), 0);
        fill(lazy.begin(), lazy.end(), 0);
    }

    void push(int v) {
        if (lazy[v] != 0) {
            t[2 * v] += lazy[v];
            lazy[2 * v] += lazy[v];
            t[2 * v + 1] += lazy[v];
            lazy[2 * v + 1] += lazy[v];
            lazy[v] = 0;
        }
    }


    void update(int v, int l, int r, int p, int q, int val) {
        if (p > q) return;
        if (l == p && r == q) {
            t[v] += val;
            lazy[v] += val;
        } else {
            push(v);
            int m = (l + r) / 2;
            update(2 * v, l, m, p, min(m, q), val);
            update(2 * v + 1, m + 1, r, max(p, m + 1), q, val);
            t[v] = max(t[2 * v], t[2 * v + 1]);
        }
    }


    void update(int p, int q, int val) {
        if (p > q) return;
        update(1, 0, n - 1, p, q, val);
    }


    int getMax() {
        return t[1];
    }
};

void solve() {
    int n, k;
    if (!(cin >> n >> k)) return;

    vector<Point> pts(n);
    vector<ll> unique_y;
    unique_y.reserve(n);

    for (int i = 0; i < n; i++) {
        cin >> pts[i].x >> pts[i].y;
        unique_y.push_back(pts[i].y);
    }

    if (k == 1) {
        cout << 0 << "\n";
        return;
    }

    sort(pts.begin(), pts.end(), [](const Point& a, const Point& b) {
        return a.x < b.x;
    });

    sort(unique_y.begin(), unique_y.end());
    unique_y.erase(unique(unique_y.begin(), unique_y.end()), unique_y.end());

    SegmentTree st(unique_y.size());

    auto isValid = [&](ll mid) {
        st.reset();
        int left = 0;
        
        for (int right = 0; right < n; ++right) {
            ll h = pts[right].y;
            
            int l_idx = lower_bound(unique_y.begin(), unique_y.end(), h - mid) - unique_y.begin();
            int r_idx = upper_bound(unique_y.begin(), unique_y.end(), h) - unique_y.begin() - 1;
            
            st.update(l_idx, r_idx, 1);

            while (pts[right].x - pts[left].x > mid) {
                ll h_left = pts[left].y;
                int l_idx_left = lower_bound(unique_y.begin(), unique_y.end(), h_left - mid) - unique_y.begin();
                int r_idx_left = upper_bound(unique_y.begin(), unique_y.end(), h_left) - unique_y.begin() - 1;
                
                st.update(l_idx_left, r_idx_left, -1);
                left++;
            }

            if (st.getMax() >= k) {
                return true;
            }
        }
        return false;
    };

    ll low = 0, high = 2e9; 
    ll ans = high;

    while (low <= high) {
        ll mid = low + (high - low) / 2;
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
    ios_base::sync_with_stdio(false);
    cin.tie(NULL);
    solve();
    return 0;
}
```
##### for less contraints
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

#flashcards/tile_selection
### Algorithm: Minimum Bounding Square for $K$ Points
?
This algorithm finds the minimum side length $D$ of an axis-aligned square that encloses at least $K$ points from a given set of $N$ points. It uses a combination of Binary Search, a Sliding Window, and a Segment Tree with Coordinate Compression.
**Inputs:**
* $N$: Total number of available tiles/points.
* $K$: Number of tiles/points to select.
* $P$: A list of points where $P_i = (X_i, Y_i)$.
**Output:** * $D$: The minimum maximum difference (smallest bounding square side length).
### **Step 1: Handle Edge Cases**
If $K = 1$, the minimum difference is strictly $0$ because a single tile compared to itself yields a difference of $0$.
* **If** $K == 1$:
* **Return** $0$ and terminate.
### **Step 2: Coordinate Compression (Y-Axis)**
To efficiently build the Segment Tree regardless of the coordinate scale, extract and index all unique $Y$ coordinates.
* Initialize an array $U$ containing all $Y_i$ from $P$.
* Sort $U$ in ascending order.
* Remove all duplicate values from $U$.
* *Result:* $U$ now acts as a dictionary mapping real Y-coordinates to array indices $[0, \text{length}(U) - 1]$.
### **Step 3: Point Sorting (X-Axis)**
Sort the original points to allow a sliding window to process them sequentially along the X-axis.
* Sort the list $P$ in ascending order based on the $X$ coordinate.
### **Step 4: Initialize Binary Search Boundaries**
Set the search space for the side length $D$.
* Set $Low = 0$.
* Set $High = 2 \times 10^9$ (or the maximum possible theoretical difference based on problem constraints).
* Set $Ans = High$.
### **Step 5: Define the Validation Function**
Create a function $isValid(D)$ that returns $True$ if a square of side length $D$ can enclose at least $K$ points.
* Initialize a Segment Tree of size equal to $\text{length}(U)$. It must support **Range Addition** and **Global Maximum Query** using lazy propagation.
#### **5.1. Initialize Data Structures**
- reset to the Segment tree
* Set $Left = 0$.
#### **5.2. Expand the Sliding Window**
**For** $Right = 0$ **to** $N - 1$:
* Let current point be $P_{right} = (X_{right}, Y_{right})$.
* Determine the valid range for the bottom edge of a box of height $D$ enclosing this point: $[Y_{right} - D, Y_{right}]$.
* Find the corresponding Segment Tree indices for this real coordinate range using binary search on $U$:
* $Index_{start} =$ Smallest index in $U$ where value $\ge Y_{right} - D$.
* $Index_{end} =$ Largest index in $U$ where value $\le Y_{right}$.
* Add $1$ to the Segment Tree over the interval $[Index_{start}, Index_{end}]$.
##### **5.3. Shrink the Sliding Window**
**While** $(X_{right} - X_{left}) > D$:
* Let the leftmost point be $P_{left} = (X_{left}, Y_{left})$.
* Find the corresponding Segment Tree indices for its range: $[Y_{left} - D, Y_{left}]$.
* $Index_{start\_left} =$ Smallest index in $U$ where value $\ge Y_{left} - D$.
* $Index_{end\_left} =$ Largest index in $U$ where value $\le Y_{left}$.
* Subtract $1$ from the Segment Tree over the interval $[Index_{start\_left}, Index_{end\_left}]$.
* Increment $Left$ by $1$.
 ##### **5.4. Check Global Maximum**
If the Segment Tree's current global maximum $\ge K$:
* **Return** `True`.
##### **5.5. End of Loop**
If the loop finishes checking all points and the condition in 5.4 was never met:
- **Return** `False`.
### **Step 6: Execute Binary Search**
Perform the binary search using the $isValid$ function to find the minimal $D$.
**While** $Low \le High$:
* $Mid = \lfloor \frac{Low + High}{2} \rfloor$.
* **If** $isValid(Mid)$ is $True$:
	* $Ans = Mid$ (Record as a potential minimum).
	* $High = Mid - 1$ (Search for a smaller valid $D$).
* **Else**:
	* $Low = Mid + 1$ (Search for a larger $D$).
### **Step 7: Output Result**
**Return** $Ans$.