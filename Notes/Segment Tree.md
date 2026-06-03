# Implementation of Classic Segment tree
#### Building
```cpp
void build(vector<int> &a, int v, int l, int r){
	if(l==r) t[v] = a[l];
	else{
		int m = (l+r)/2;
		build(a, 2*v, l, m);
		build(a, 2*v+1, m+1, r);
		t[v] = t[2*v] + t[2*v+1];
	}
}
```
#### Update
```cpp
void update(int v, int l, int r, int pos, int val){
	if(l==r) t[v] = val;
	else{
		int m = (l+r)/2;
		if(pos<=m) update(2*v, l, m, pos, val);
		else update(2*v+1, m+1, r, pos, val);
		t[v] = t[2*v] + t[2*v+1];
	}
}
```
#### SumQuery
```cpp
int sum(int v, int l, int r, int p, int q){
	if(l>r) return 0;
	if(l==p && r==q) return t[v];
	int m = (l+r)/2;
	return sum(2*v, l, m, p, min(m,q)) + sum(2*v+1, m+1, r, max(p, m+1), q);
}
```

