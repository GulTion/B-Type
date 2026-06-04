# Implementation of Classic Segment tree

#flashcards/segment_tree
#### Building of Segment tree
?
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

#flashcards/segment_tree
#### Update of Segment tree
?
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


#flashcards/segment_tree
#### SumQuery of Segment tree
?
```cpp
int sum(int v, int l, int r, int p, int q){
	if(l>r) return 0;
	if(l==p && r==q) return t[v];
	int m = (l+r)/2;
	return sum(2*v, l, m, p, min(m,q)) + sum(2*v+1, m+1, r, max(p, m+1), q);
}
```


#flashcards/segment_tree
#### Lazy Segment tree with Max operation for entire Tree
?
```cpp
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

```