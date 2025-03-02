---
title: K个数的和
mathjax: true
date: 2019-08-13 10:35:54
tags:
categories:
---

从 n 个数中选 k 个数的和为 sum 这个问题。

<!--more-->

方法1

> 用一个参数来表示对那个元素进行判断，对每一个状态有选和不选2种路径

```c++
#include <iostream>
using namespace std;
int n, k, sum, ans;
int a[40];
// i: 表示对 i 进行判断选还是不选; cnt: 当前已经选了多少数;  s: 所选数的和
void dfs(int i, int cnt, int s) { 
    if (i == n) {
        if (cnt == k && s == sum) {
            ans++;
        }
        return;
    }
    dfs(i + 1, cnt, s);
    dfs(i + 1, cnt + 1, s + a[i]);
}
int main() {
    // 输入数据
    cin >> n >> k >> sum;
    for (int i = 0; i < n; i++) {
        cin >> a[i];
    }
    ans = 0;
    dfs(0, 0, 0);
    cout << ans << endl;
    return 0;
}
```



方法2

> 标记每个数的是否被选择，通过for循环去找一个没有被选择的元素进行dfs

```c++
int n, k, sum, ans = 0, a[110];
bool vis[110];
void dfs(int cnt, int s) {
    if (cnt == n) {
        if (s = sum) {
            ans++;
        }
        for (int i = 0; i < n; i++) {
            if (!vis[i]) {
                vis[i] = true;
                dfs(cnt + 1, s + a[i]);
                vis[i] = false;
            }
        }
    }
}
```

