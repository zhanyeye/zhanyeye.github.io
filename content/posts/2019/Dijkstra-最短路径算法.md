---
title: Dijkstra 最短路径算法
date: 2019-04-28 18:00:12
tags:
- 图
categories:
- 算法
mathjax: true
---

###### 单源最短路问题

在带权图 *G*=(*V*,*E*) 中，每条边都有一个权值 *wi*，即边的长度。路径的长度为路径上所有边权之和。单源最短路问题是指：求源点 *s* 到图中其余各顶点的最短路径。

如果用我们之前学习的 dfs 来解决单源最短路问题，效率上会很慢，能解决的问题的数据规模非常小。

而 bfs 能解决的最短路问题只限制在边权为 1 的图上。对于边权不同的图，利用 bfs 求解最短路是错误的。



> 解决单源最短路径问题常用 Dijkstra 算法，用于计算一个顶点到其他所有顶点的最短路径。Dijkstra 算法的主要特点是以起点为中心，逐层向外扩展（这一点类似于 bfs，但是不同的是，bfs 每次扩展一个层，但是 Dijkstra 每次只会扩展一个点），每次都会取一个最近点继续扩展，直到取完所有点为止



非负权图 , 贪心思想

<!--more-->

######  算法流程

+ **一直维护一个还没有确定最短路的点的集合, 每次从集合中选出一个最小的点去更新其他的点**
+ **不能处理负权图**: 贪心正确的前提是没有负权

我们定义带权图 *G* 所有顶点的集合为 *V*，接着我们再定义**已确定从源点出发的最短路径的顶点集合**为 *U*，初始集合 *U* 为空，记**从源点 *s* 出发到每个顶点 *v* 的距离**为 *dist_v*，初始 *dist_s*=0，其他*dist_v*为∞。接着执行以下操作：

1. 从 *V*−*U* 中找出一个距离源点最近的顶点 *v*，将 *v* 加入集合 *U*。
2. 并用 dist_v 和点 *v* 连出的边来更新和 *v* 相邻的、不在集合 *U* 中的顶点的 dist，这一步称为松弛操作。
3. 重复步骤 1 和 2，直到 V=U或找不出一个从 *s* 出发有路径到达的顶点，算法结束。

如果最后V !=U，说明有顶点无法从源点到达；否则每个 dist_i表示从 *s* 出发到顶点 *i* 的最短距离。

Dijkstra 算法的时间复杂度为O(*V*^2)，其中 *V* 表示顶点的数量。

```c++
#include <iostream>
#include <cstring>

using namespace std;

const int N = 1000;
const int M = 10000;
const int INF = 0x3f3f3f3f;

//基于链表的邻接表
struct edge {
    int v;  //顶点
    int w;  //权值
    int next;  //指向head[i] 所链接的链表，表示v 和 i 相邻
    edge() {}
    edge(int _v, int _w, int _next): v(_v), w(_w), next(_next) {}
} E[M];

int head[N];  // head数组的每一个元素代表链表的头指针
int cnt; //边的数量

void init() {
    memset(head, -1, sizeof head);  // 初始化时，每个链表都没有元素，初始化为空，即：-1
    cnt = 0;
}

void insert(int u, int v, int w) {
    E[cnt] = edge(v, w, head[u]);
    head[u] = cnt;  // 更新链表的头指针
    cnt++;  // 结点计数器 +1
}

void insert2(int u, int v, int w) {
    insert(u, v, w);
    insert(v, u, w);
}

int n, m;
int dis[N];   // 标记点到 u 的距离
bool vis[N];  // 标记一个点有没有被加入已确定最小值集合


void dijkstra(int u) {
    memset(dis, 0x3f, sizeof dis);  //将所有定点到u的距离值 无穷大
    memset(vis, false, sizeof vis);
    dis[u] = 0;  // u点到自己距离为0


    // 循环 n 次，每次确定一个dis 最小的点，2种可能
    // 循环 n 次，最终到所有点的最小值都确定
    // 没有循环 n 次，该图非连通图 
    for (int i = 0; i < n; i++) {
        int min_dis = INF, min_index = -1;
        // 找点集中 dis 最小的一个，将该点加入已确定最小值集合
        for (int j = 1; j <= n; j++) {
            if (!vis[j] && min_dis > dis[j]) {
                min_dis = dis[j];
                min_index = j;
            }
        }
        if (min_index == -1) { //未确定点集中，顶点的min dis 是 无穷大， 该图非连通图
            return;
        }
        vis[min_index] = true;
        for (int e = head[min_index]; ~e; e = E[e].next) { //注意这里e是插入序号, 而不是点
            int v = E[e].v;
            int w = E[e].w;
            if (!vis[v] && dis[v] > min_dis + w) {
                dis[v] = min_dis + w;
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
        insert2(u, v, w);
    }
    dijkstra(1);
    cout << dis[n] << endl;

    return 0;
}
```



再回顾一下 Dijkstra 算法的核心思想，就是一直维护一个还没有确定最短路的点的集合，然后每次从这个集合中选出一个最小的点去更新其他的点。

**堆优化**

如果每次暴力枚举选取距离最小的元素，则总的时间复杂度是 $\mathcal{O}(V^2)$。

结合之前学习的数据结构，如果考虑用堆优化，用一个`set`来维护点的集合，这样的时间复杂度就优化到了 $\mathcal{O}((V+E)\log V)$，对于稀疏图的优化效果非常好。

小根堆优化的 Dijkstra 示例代码如下：

```c++
#include <iostream>
#include <algorithm>
#include <cstring>
#include <set>

using namespace std;

const int N = 1005;
const int M = 5005;

struct edge {
    int v, w, next;
    edge() {}
    edge(int _v, int _w, int _next):v(_v), w(_w), next(_next) {}
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

int dis[N];
bool vis[N];
int n, m;
typedef pair<int, int> PII;
set<PII, less<PII> > min_heap;


bool dijstra(int u) {
    memset(dis, 0x3f, sizeof dis);
    memset(vis, false, sizeof vis);
    dis[u] = 0;
    min_heap.insert(make_pair(0, u));

    for (int i = 0; i < n; i++) {
        if (min_heap.size() == 0) {
            return false;
        }

        set<PII, less<PII> >::iterator it = min_heap.begin();
        int min_v = it->second;
        vis[min_v] = true;
        min_heap.erase(*it);

        for (int e = head[min_v]; e != -1; e = E[e].next) {
            int v = E[e].v;
            int w = E[e].w;
            if (!vis[v] && dis[min_v] + w < dis[v]) {
                min_heap.erase(make_pair(dis[v], v));
                dis[v] = dis[min_v] + w;
                min_heap.insert(make_pair(dis[v], v));
            }
        }
    }
    return true;
}


int main() {
    int a, b, c;
    cin >> n >> m;
    init();
    while (m--) {
        cin >> a >> b >> c;
        insert2(a, b, c);
    }
    dijstra(1); 
    cout << dis[n] << endl;
}
```



> 算法演示
>
> 接下来，我们用一个例子来说明这个算法。
>
> ![img](https://res.jisuanke.com/img/upload/20170428/15072f3ce9f3e53579a6c2e02d87ef57d56cb3fe.png)
>
> 
>
> 初始每个顶点的 dist 设置为无穷大 inf，源点 *M* 的 dist_M 设置为 0。
>
> 1. 当前*U*=∅，*V*−*U* 中 dist 最小的顶点是 M。
> 2. 从顶点 M 出发，更新相邻点的 dist。
>
> ![](https://res.jisuanke.com/img/upload/20170428/02b208d277615bebf57d9a796e46bc96900181a3.png)
>
> 
>
> 更新完毕，此时 *U*={*M*}，
>
> 1. *V*−*U* 中 dist 最小的顶点是 *W*。
> 2. 从 *W* 出发，更新相邻点的 dist。
>
> ![img](https://res.jisuanke.com/img/upload/20170428/a310ffeebb4ebd561660aeed7cf81db5448b98cc.png)
>
> 
>
> 更新完毕，此时 *U*={*M*,*W*}，
>
> 1. *V*−*U* 中 dist 最小的顶点是 *E*。
> 2. 从 *E* 出发，更新相邻顶点的 dist。
>
> ![img](https://res.jisuanke.com/img/upload/20170428/18bf6b9ce78f61fa85ce4b6563b8d3508b2b0470.png)
>
> 
>
> 更新完毕，此时 *U*={*M*,*W*,*E*}，
>
> 1. V*−*U* 中 dist最小的顶点是 *X*。
> 2. 从 *X* 出发，更新相邻顶点的 dist。
>
> ![img](https://res.jisuanke.com/img/upload/20170428/39744d7c33d595558c4c79205c7778b3ae476a01.png)
>
> 
>
> 更新完毕，此时 *U*={*M*,*W*,*E*,*X*}，
>
> 1. V*−*U* 中 dist 最小的顶点是 *D*。
> 2. 从 *D* 出发，没有其他不在集合 *U* 中的顶点。
>
> [![img](https://res.jisuanke.com/img/upload/20170428/ced8460a27686319529c898a1c7daec893bba313.png)](https://res.jisuanke.com/img/upload/20170428/ced8460a27686319529c898a1c7daec893bba313.png)
>
> 此时*U*=*V*，算法结束，单源最短路计算完毕。