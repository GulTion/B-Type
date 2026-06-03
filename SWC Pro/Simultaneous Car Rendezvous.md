---
test id: "6"
ques id: "1"
done?: true
tags:
  - math
  - greedy
---

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

### Input Format
* The first line contains an integer $T$, the number of test cases.
* For each testcase:
  * The first line contains two integers $N$ and $M$.
  * The second line contains two integers $p$ and $q$, representing the target coordinates.
  * The next $N$ lines each contain two integers $x$ and $y$, representing the initial coordinates of a car.

### Output Format
* For each testcase, print `# C Ans` where `C` is the testcase number starting from 1, and `Ans` is the minimum number of drive steps required, or `-1` if it is impossible.

### Sample Input
```text
2
2 10
1 1
2 3
-4 1
2 10
0 0
0 1
0 2
```

### Sample Output
```text
# 1 5
# 2 -1
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
