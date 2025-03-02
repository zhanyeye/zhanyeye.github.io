---
title: SPFA算法
date: 2019-05-18 23:11:29
tags:
- 图
categories:
- 算法
mathjax: true
---



#### SPFA 算法

> SPFA（Shortest Path Faster Algorithm）算法是单源最短路径的一种算法，通常被认为是 Bellman-ford 算法的队列优化，在代码形式上**接近于宽度优先搜索 BFS**，是一个在实践中非常高效的单源最短路算法。

在 SPFA 算法中，使用 d[i] 表示从源点到顶点 i 的最短路，额外用一个队列来保存即将进行拓展的顶点列表，并用 inq[i] 来标识顶点 i 是不是在队列中。

1. 初始队列中仅包含源点，且源点 s 的 d[s] = 0 ( 且其他的为INF )。
2. 取出队列头顶点u，扫描从顶点u出发的每条边，设每条边的另一端为v，边 `<u,v>`权值为 w，若 d[u] + w < d[v]，则
   - 将 d[v] 修改为 d[u] + w
   - 若v不在队列中，则
     - 将 v 入队
3. 重复步骤 2 直到队列为空

最终 d 数组就是从源点出发到每个顶点的最短路距离。如果一个顶点从没有入队，则说明没有从源点到该顶点的路径。

<!--more-->

#### SPFA 思想

在一定程度上，可以认为 SPFA 是由 BFS 的思想转化而来。从不含边权或者说边权为 1 个单位长度的图上的 BFS，推广到带权图上，就得到了 SPFA。只是 bfs 能保证第一次访问就一定是最短路，而 spfa 在每次更新了最短路以后又重新入队从而去更新后续结点的最短路。比如下图，2 搜到 3 的时候会再次更新 3 最短路。

[![img](https://res.jisuanke.com/img/upload/20180227/c786e72cb689e6b17b86eb4b57457c7952b6883f.png)](https://res.jisuanke.com/img/upload/20180227/c786e72cb689e6b17b86eb4b57457c7952b6883f.png)

正如我们前面所说，SPFA 的本质是 Bellman-ford 算法的队列优化。由于 SPFA 没有改变 Bellaman-ford 的时间复杂度，国外一般来说不认为 SPFA 是一个新的算法，而仅仅是 Bellman-ford 的队列优化。



#### 运行效率

很显然，SPFA 的空间复杂度为 $\mathcal{O}(V)$。如果顶点的平均入队次数为 k，则 SPFA 的时间复杂度为 $\mathcal{O}(kE)$，对于较为随机的稀疏图，根据经验 k 一般不超过 4。



```c++
bool inq[MAX_N];
int d[MAX_N];  // 如果到顶点 i 的距离是 0x3f3f3f3f，则说明不存在源点到 i 的最短路
void spfa(int s) {
    memset(inq, 0, sizeof(inq));
    memset(d, 0x3f, sizeof(d));
    d[s] = 0;
    inq[s] = true;
    queue<int> q;
    q.push(s);
    while (!q.empty()) {
        int u = q.front();
        q.pop();
        inq[u] = false;
        for (int i = p[u]; i != -1; i = e[i].next) {
            int v = e[i].v;
            if (d[u] + e[i].w < d[v]) {
                d[v] = d[u] + e[i].w;
                if (!inq[v]) {
                    q.push(v);
                    inq[v] = true;
                }
            }
        }
    }
}
```



### 优化

SPFA 算法有两个优化策略 SLF 和 LLL：

- SLF：Small Label First 策略，设要加入的顶点是 j，队首元素为 i，若 d[j]<d[i]，则将 j 插入队首，否则插入队尾；
- LLL：Large Label Last 策略，设队首元素为 i，队列中所有最短距离值的平均值为 x，若 d[i] > x 则将 i 插入到队尾，查找下一元素，直到找到某一顶点 i 使得 d[i] ≤ x，则将 i 出队进行松弛操作。
- SLF 可使速度提高 15 ~ 20%；SLF + LLL 可提高约 50%。

在解决算法题目时，不带优化的 SPFA 就足以解决问题；而一些题目会故意制造出让 SPFA 效率低下的数据，即使你使用这两个优化也无法避免“被卡”。因此，SLF 和 LLL 两个优化仅作了解就可以了，在竞赛中不必使用。

对于稀疏图而言，SPFA 相比堆优化的 Dijkstra 有很大的效率提升，但是对于稠密图而言，SPFA 最坏为 $\mathcal{O}(VE)$，远差于堆优化 Dijkstra 的 $\mathcal{O}((V+E)logV)$。当然，在图中**包含负权边时**，SPFA 几乎是唯一的选择（之后我们会讨论负权的问题）。因此，大家在做题时，还是要根据数据的具体情况来判断使用哪种最短路算法。









```c++
#include <iostream>
#include <cstring>
#include <queue>
using namespace std;
const int N = 1e3 + 9;
const int M = 1e4 + 9;

struct edge {
    int v, w, fail;
    edge() {}
    edge(int _v, int _w, int _fail) {
        v = _v;
        w = _w;
        fail = _fail;
    }
} e[M << 1];

int head[N], len;

void init() {
    memset(head, -1, sizeof(head));
    len = 0;
}

void add(int u, int v, int w) {
    e[len] = edge(v, w, head[u]);
    head[u] = len++;
}

void add2(int u, int v, int w) {
    add(u, v, w);
    add(v, u, w);
}

int n, m;
int dis[N];
bool vis[N];
void spfa(int u) {
    memset(vis, false, sizeof(vis));
    vis[u] = true;
    memset(dis, 0x3f, sizeof(dis));
    dis[u] = 0;
    queue<int> q;
    q.push(u);
    while (!q.empty()) {
        u = q.front();
        q.pop();
        vis[u] = false;
        for (int j = head[u]; ~j; j = e[j].fail) {
            int v = e[j].v;
            int w = e[j].w;
            if (dis[v] > dis[u] + w) {
                dis[v] = dis[u] + w;
                if (!vis[v]) {
                    q.push(v);
                    vis[v] = true;
                }
            }
        }
    }
}

int main() {
    init();
    int u, v, w;
    cin >> n >> m;
    while (m--) {
        cin >> u >> v >> w;
        add2(u, v, w);
    }
    spfa(1);
    cout << dis[n] << endl;
    return 0;
}
```



###### 负环

Dijkstra 不能处理有负权的图，而 **SPFA 可以处理任意不含负环（负环是指总边权和为负数的环）的图** 的最短路，并能 **判断图中是否存在负环**

![](https://raw.githubusercontent.com/zhanyeye/Figure-bed/img/img/20190703091751.png)

上图就存在 1->2->3->1 这样一个负环，一直沿着负环走下去，最短路径会越来越小，趋向于负无穷大。所以存在负环的时候，SPFA 算法无法停止下来。

###### SPFA判断负环

但是 SPFA 可以用来判断负环，在进行 SPFA 时，用一个数组 cnt[i]来标记每个顶点 **入队** 次数。如果一个顶点入队次数 cnt[i] 大于顶点总数 n，则表示该图中包含负环。

一般情况下，SPFA 判负环都只用在有向图上，因为在无向图上，一条负边权的边就是一个负环了。



```c++
#include <iostream>
#include <cstring>
#include <queue>

using namespace std;

const int N = 1e3 + 9;
const int M = 1e4 + 9;
const int INF = 0x3f3f3f3f;

struct edge {
    int v, w, next;
    edge() {}
    edge(int _v, int _w, int _next) : v(_v), w(_w), next(_next) {}
} E[2 * M];

int head[N];
int cnt;

void init() {
    memset(head, -1, sizeof head);
    cnt = 0;
}

void insert(int u, int v, int w) {
    E[cnt] = edge(v, w, head[u]);
    head[u] = cnt++;
}

void insert2(int u, int v, int w) {
    insert(u, v, w);
    insert(v, u, w);
}

int n, m;
int dis[N];
bool vis[N];
int in[N];

bool spfa(int u) {
    memset(dis, 0x3f, sizeof dis);
    memset(vis, false, sizeof vis);
    memset(in, 0, sizeof in);
    dis[u] = 0;
    vis[u] = true;
    in[u] = 1;
    
    queue<int> q;
    q.push(u);
    while (!q.empty()) {
        int tmp = q.front();
        q.pop();
        vis[tmp] = false;
        for (int e = head[tmp]; ~e; e = E[e].next) {
            int v = E[e].v;
            int w = E[e].w;
            if (dis[v] > dis[tmp] + w) {
                dis[v] = dis[tmp] + w;
                if (!vis[v]) {
                    q.push(v);
                    vis[v] = true;
                    in[v]++;
                    if (in[v] > n) {
                        return false;
                    }
                }
            }
        }
    }

    return true;
}

int main() {
    init();
    int u, v, w;
    cin >> n >> m;
    while (m--) {
        cin >> u >> v >> w;
        insert2(u, v, w);
    }
    if (spfa(1)) {
        cout << "没有负环" << endl;
    } else {
        cout << "有负环" << endl;
    }
    return 0;
}
```

