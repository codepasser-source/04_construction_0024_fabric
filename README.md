### 04_construction_0024_fabric ###

#### 过程

> GO LEVEL DB(SOLO)

> CouchDB

> Kafka

> EtcdRaft

> CA

> Private Data

> Logpout

> Cluster

#### 示例说明

> fabric-0001-course

|    链码    |    状态存储    |    排序服务    |    组织    |    节点    |    排序节点    |    CA    |    集群    |
|  ----  |  ----  |  ----  |  ----  |  ----  |  ----  |  ----  |  ----  |
|    node(mycc)    |   goleveldb     |   solo     |   Org(1~2)   |   peer(0~1).org(1~2).example.com     |   orderer.example.com     |   无     |    单机环境    |

> fabric-0002-course

|    链码    |    状态存储    |    排序服务    |    组织    |    节点    |    排序节点    |    CA    |    集群    |
|  ----  |  ----  |  ----  |  ----  |  ----  |  ----  |  ----  |  ----  |
|    go(marbles)    |   couchdb     |   solo     |   Org(1~2)   |   peer(0~1).org(1~2).example.com     |   orderer.example.com     |   无     |    单机环境    |


> fabric-0003-course

|    链码    |    状态存储    |    排序服务    |    组织    |    节点    |    排序节点    |    CA    |    集群    |  应用程序  |
|  ----  |  ----  |  ----  |  ----  |  ----  |  ----  |  ----  |  ----  |  ----  |
|    go(fabcar)    |   couchdb(0~1).org(1~2).example.com     |   kafka.example.com    |   Org(1~2)   |   peer(0~1).org(1~2).example.com     |   orderer.example.com     |   ca.org(1~2).example     |    单机环境    |  fabcar  |

> fabric-0004-course

|    链码    |    状态存储    |    排序服务    |    组织    |    节点    |    排序节点    |    CA    |    集群    |  应用程序  |
|  ----  |  ----  |  ----  |  ----  |  ----  |  ----  |  ----  |  ----  |  ----  |
|    go(fabcar)    |   couchdb(0~1).org(1~2).example.com     |   order(~2~5).example.com etcdraft    |   Org(1~2)   |   peer(0~1).org(1~2).example.com     |   orderer.example.com     |   ca.org(1~2).example     |    单机环境    |  fabcar  |
