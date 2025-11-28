---
title: "飞牛NAS部署Dnsmasq - 局域网内搭建一台 DNS 服务器"
date: "2025-11-28T13:39:58Z"
draft: false
discussion_id: "D_kwDOCretjM4AjDT-"
---

1. 首先下载镜像
<img width="1710" height="893" alt="image" src="https://github.com/user-attachments/assets/79b4fb08-74f5-4394-8d1c-88d1a438ae6d" />

2. 运行镜像
<img width="1109" height="646" alt="image" src="https://github.com/user-attachments/assets/25350d2a-9fe5-40bd-98ac-385af1c1170a" />

3. 按需配置
<img width="1114" height="656" alt="image" src="https://github.com/user-attachments/assets/8ec35dd8-39ff-4b71-8445-9f47d9fb7a1b" />


4. 配置
### 场景 A：家庭 NAS，自定义几个域名

```conf
no-resolv
no-hosts
bind-interfaces
interface=eth0
port=53

# 上游 DNS
server=223.5.5.5
server=119.29.29.29

# 自定义域名
address=/nas.home/192.168.1.100
address=/home.home/192.168.1.101
address=/docker.home/192.168.1.100

# 日志
log-queries
log-facility=/var/log/dnsmasq.log
cache-size=1000
```

### 场景 B：办公网络，带广告过滤

```conf
no-resolv
no-hosts
bind-interfaces
interface=eth0
port=53

server=223.5.5.5
server=119.29.29.29

# 自定义本地域名
address=/intranet.corp/192.168.10.50

# 广告过滤（可以从文件加载）
# addn-hosts=/etc/dnsmasq-ads.hosts

# 某些广告域名直接返回 0.0.0.0（或其他 IP）来过滤
address=/ad.doubleclick.net/0.0.0.0
address=/ads.google.com/0.0.0.0

log-queries
log-facility=/var/log/dnsmasq.log
cache-size=2000
```

### 场景 C：分流 DNS（部分域名走指定上游）

```conf
no-resolv
no-hosts
bind-interfaces
interface=eth0
port=53

# 默认上游 DNS
server=223.5.5.5

# 部分域名走特定 DNS
server=/google.com/8.8.8.8
server=/github.com/1.1.1.1

# 本地域名
address=/nas.local/192.168.1.100

log-queries
log-facility=/var/log/dnsmasq.log
```

5. 验证
```
# 1. 检查容器运行状态
docker ps | grep dnsmasq

# 2. 查看启动日志
docker logs dnsmasq

# 3. 检查端口监听
ss -lun | grep :53

# 4. 查看配置文件是否正确加载
docker exec -it dnsmasq cat /etc/dnsmasq.conf | head -20

# 5. 测试自定义域名
dig @192.168.1.10 nas.home +short
# 期望：192.168.1.100

# 6. 测试公网域名
dig @192.168.1.10 [www.google.com](http://www.google.com/) +short
# 期望：一个 IP 地址

# 7. 查看实时 DNS 查询日志
docker logs -f dnsmasq

# 8. 测试 TCP DNS（可选）
dig @192.168.1.10 nas.home +tcp +short
```
