# Docker-sshd_ready

sshd readyなイメージを作成するDockerfileです。
Jenkins+Chef Solo+serverspecでCIするときのコンテナとしての利用を想定しています。

[公式のCentOSイメージ](https://registry.hub.docker.com/_/centos/)を元に作成しています。

## Usage

### 1. CentOSイメージの取得

```
$ sudo docker pull centos:centos6
```

### 2. 公開鍵の準備

Dockerfileと同じディレクトリに公開鍵を`authorized_keys`という名前で配置してください。
これがコンテナ内の`/root/.ssh`以下に配置されます。

### 3. イメージを作成

最後の`.`を忘れないようにしてください。

```
$ sudo docker build -t {image_name} .
```

### 4. コンテナを実行

`--privileged`オプションは、これがないと`iptables`などいくつかの設定がうまくいかないので設定しています。
詳しくは[ドキュメント](http://docs.docker.com/reference/run/#runtime-privilege-linux-capabilities-and-lxc-configuration)を参照してください。

```
$ sudo docker run -d -p 22 -t --privileged --name {container_name} {image_name}
```

### 5. ssh接続

秘密鍵へのパスは適宜変更してください。

```
$ ssh -p 22 -i ~/.ssh/id_rsa root@`sudo docker inspect --format='{{ .NetworkSettings.IPAddress }}' {container_name}`
```

上記において、以下の部分はコンテナのIPアドレスを取得しています。

```
$ `sudo docker inspect --format='{{ .NetworkSettings.IPAddress }}' {container_name}`
```
