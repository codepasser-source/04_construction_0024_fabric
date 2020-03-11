# 04_construction_0024_fabric

## 环境篇 ##

### 系统版本 ###

```
Linux 3.10.0-862.el7.x86_64 #1 SMP Fri Apr 20 16:44:24 UTC 2018 x86_64 x86_64 x86_64 GNU/Linux
```

### 配置GIT ###

```
git config --global user.name  "Joker.cheng"
git config --global user.email "codepasser@aliyun.com"

git config --global alias.st status
git config --global alias.co checkout
git config --global alias.ci commit
git config --global alias.br branch
```

### 安装docker ###

- 参见 04_construction_0012_docker

### 安装docker-compose ###

```
https://docs.docker.com/compose/install/#install-using-pip
```

- 安装docker-compose
```
sudo curl -L "https://github.com/docker/compose/releases/download/1.25.3/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
```

- 查看版本
```
docker-compose version
```

### 安装GO ###

- 安装

```
yum install -y go
```

- 验证

```
go version
go version go1.13.3 linux/amd64
```

- 设置环境变量

```
# 添加go用户
groupadd go
adduser -g go go --home-dir=/home/go
passwd go
usermod -G docker go
usermod -G docker codepasser
usermod -G go codepasser

export GOPATH=/home/go
export GO_BIN=$GOPATH/bin
export PATH=$PATH:$GO_BIN
```
### 安装Python3（可选） ###

- 安装相应的编译工具
```
yum -y groupinstall "Development tools"
yum -y install zlib-devel bzip2-devel openssl-devel ncurses-devel sqlite-devel readline-devel tk-devel gdbm-devel db4-devel libpcap-devel xz-devel
yum install -y libffi-devel zlib1g-dev
yum install zlib* -y
```

- 源码安装 https://www.python.org/
```
wget https://www.python.org/ftp/python/3.8.1/Python-3.8.1.tar.xz
```

- 解压
```
tar -xvJf Python-3.8.1.tar.xz
```

- 安装
```
cd /usr/local/lib/python-3.8.1
./configure --prefix=/usr/local/lib/python-3.8.1 --enable-optimizations --with-ssl
#参数二：可以提高python10%-20%代码运行速度.
#参数三：是为了安装pip需要用到ssl,后面报错会有提到.
make && make install
```

- 创建软连
```
ln -s /usr/local/lib/python-3.8.1/bin/python3 /usr/local/bin/python3
ln -s /usr/local/lib/python-3.8.1/bin/pip3 /usr/local/bin/pip3
```

- 验证
```
python3 -V
pip3 -V
```

- 修改pip安装源
```
cd ~
mkdir .pip
cd .pip
vim pip.conf
#进入后添加以下内容,保存退出.
[global]
index-url = https://mirrors.aliyun.com/pypi/simple
```

- 更新pip
```
pip3 install --upgrade pip
```

### 安装node（可选） ### 

- 下载node
```
# https://nodejs.org/en/download/
wget https://nodejs.org/dist/v12.14.1/node-v12.14.1-linux-x64.tar.xz
```

- 解压安装
```
cd /usr/local/lib
tar -xvJf node-v12.14.1-linux-x64.tar.xz
```

- 设置环境变量
```
export NODE_HOME=/usr/local/lib/node-v12.14.1-linux-x64
export NODE_BIN=$NODE_HOME/bin

export PATH=$PATH:$GO_BIN:$NODE_BIN
```
