1. ## Деплой Kubernetes-кластера при помощи Rancher.

### Необходимо установить Rancher-server и создать кластер. Что нужно использовать:
-	ОС Linux (любой удобный дистрибутив). 
-	Docker
- Racher-server, Rancher-agent

2.	## Микросервис.

- Необходимо реализовать сервис, используя технологию ASP.NET Core MVC. Затем создать докер образ для установки этого сервиса. 

- Сервис должен содержать GET запрос, возвращающий строку "Hello World!".
Адрес запроса произвольный.

### Решение:

1.1 Развернул 2 сервера на Yandex Cloud. (VM server, VM agent).

![Ссылка 1](https://github.com/Firewal7/application-project/blob/main/images/1.jpg)

1.2 Установил на server docker

<details>
<summary>docker install</summary>

user@server:~$ sudo su
root@server:/home/user# curl -fsSL https://get.docker.com -o get-docker.sh
root@server:/home/user# sudo sh get-docker.sh
# Executing docker install script, commit: c2de0811708b6d9015ed1a2c80f02c9b70c8ce7b
+ sh -c apt-get update -qq >/dev/null
+ sh -c DEBIAN_FRONTEND=noninteractive apt-get install -y -qq apt-transport-https ca-certificates curl >/dev/null
+ sh -c install -m 0755 -d /etc/apt/keyrings
+ sh -c curl -fsSL "https://download.docker.com/linux/ubuntu/gpg" | gpg --dearmor --yes -o /etc/apt/keyrings/docker.gpg
+ sh -c chmod a+r /etc/apt/keyrings/docker.gpg
+ sh -c echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu bionic stable" > /etc/apt/sources.list.d/docker.list
+ sh -c apt-get update -qq >/dev/null
+ sh -c DEBIAN_FRONTEND=noninteractive apt-get install -y -qq docker-ce docker-ce-cli containerd.io docker-compose-plugin docker-ce-rootless-extras docker-buildx-plugin >/dev/null
+ sh -c docker version
Client: Docker Engine - Community
 Version:           24.0.2
 API version:       1.43
 Go version:        go1.20.4
 Git commit:        cb74dfc
 Built:             Thu May 25 21:52:13 2023
 OS/Arch:           linux/amd64
 Context:           default

Server: Docker Engine - Community
 Engine:
  Version:          24.0.2
  API version:      1.43 (minimum version 1.12)
  Go version:       go1.20.4
  Git commit:       659604f
  Built:            Thu May 25 21:52:13 2023
  OS/Arch:          linux/amd64
  Experimental:     false
 containerd:
  Version:          1.6.21
  GitCommit:        3dce8eb055cbb6872793272b4f20ed16117344f8
 runc:
  Version:          1.1.7
  GitCommit:        v1.1.7-0-g860f061
 docker-init:
  Version:          0.19.0
  GitCommit:        de40ad0

================================================================================

To run Docker as a non-privileged user, consider setting up the
Docker daemon in rootless mode for your user:

    dockerd-rootless-setuptool.sh install

Visit https://docs.docker.com/go/rootless/ to learn about rootless mode.


To run the Docker daemon as a fully privileged service, but granting non-root
users access, refer to https://docs.docker.com/go/daemon-access/

WARNING: Access to the remote API on a privileged Docker daemon is equivalent
         to root access on the host. Refer to the 'Docker daemon attack surface'
         documentation for details: https://docs.docker.com/go/attack-surface/

================================================================================
</details>


1.3 Добавил пользователя в группу docker

```
root@server:/home/user# sudo usermod -aG docker $USER

root@server:/home/user# su - $USER

root@server:~# docker version

Client: Docker Engine - Community
 Version:           24.0.2
 API version:       1.43
 Go version:        go1.20.4
 Git commit:        cb74dfc
 Built:             Thu May 25 21:52:13 2023
 OS/Arch:           linux/amd64
 Context:           default

Server: Docker Engine - Community
 Engine:
  Version:          24.0.2
  API version:      1.43 (minimum version 1.12)
  Go version:       go1.20.4
  Git commit:       659604f
  Built:            Thu May 25 21:52:13 2023
  OS/Arch:          linux/amd64
  Experimental:     false
 containerd:
  Version:          1.6.21
  GitCommit:        3dce8eb055cbb6872793272b4f20ed16117344f8
 runc:
  Version:          1.1.7
  GitCommit:        v1.1.7-0-g860f061
 docker-init:
  Version:          0.19.0
  GitCommit:        de40ad0
```

1.4 Запустил Rancher в Контейнере на VM server

```
root@server:~# docker run -d --restart=unless-stopped -p 80:80 -p 443:443 -v /opt/rancher:/var/lib/rancher --privileged rancher/rancher:latest
Unable to find image 'rancher/rancher:latest' locally
latest: Pulling from rancher/rancher
25db2d1fe29e: Pull complete 
865ffb362b40: Pull complete 
5b5134f7d794: Pull complete 
84ab582bce7e: Pull complete 
7878869d3a01: Pull complete 
7a993ec87c0f: Pull complete 
0a2fa8affd97: Pull complete 
8775dee5969b: Pull complete 
91fec06047de: Pull complete 
6b6c2e73e8e3: Pull complete 
fd97ba8511dd: Pull complete 
4f09e1aeb6b8: Pull complete 
5e9278cdae67: Pull complete 
4a4134a1a2ff: Pull complete 
76642f1df511: Pull complete 
b31afa519ee6: Pull complete 
534ed6dca93d: Pull complete 
c6e69a0b6980: Pull complete 
68a2e3b859f0: Pull complete 
ea2979d1e156: Pull complete 
Digest: sha256:5ba20e4e51a484f107f3f270fa52c5e609cad0692dd00a26169cc3541b1f3788
Status: Downloaded newer image for rancher/rancher:latest
e7b7e3806ab057e6a181f14a40d178b0d9aa8568128493d3cf16a522ba2524e8
root@server:~#  docker ps
CONTAINER ID   IMAGE                    COMMAND           CREATED              STATUS              PORTS                                                                      NAMES
e7b7e3806ab0   rancher/rancher:latest   "entrypoint.sh"   About a minute ago   Up About a minute   0.0.0.0:80->80/tcp, :::80->80/tcp, 0.0.0.0:443->443/tcp, :::443->443/tcp   flamboyant_grothendieck
```

1.5 Запустил на VM agent созданный на Rancher cluster 

```
root@agent:/home/user# curl --insecure -fL https://158.160.64.30/system-agent-install.sh | sudo  sh -s - --server https://158.160.64.30 --label 'cattle.io/os=linux' --token w7nbbqvj5s9wqrgfbfddpw6nlwrmb5vdhtqhn7fdflxlv7wdg9h47n --ca-checksum 27d3265c60a10f8b5ab57a5203da746fbbfebbaeebed0ae3b287ebeecf8de9d6 --etcd --controlplane --worker
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100 30851    0 30851    0     0  4397k      0 --:--:-- --:--:-- --:--:-- 5021k
[INFO]  Label: cattle.io/os=linux
[INFO]  Role requested: etcd
[INFO]  Role requested: controlplane
[INFO]  Role requested: worker
[INFO]  Using default agent configuration directory /etc/rancher/agent
[INFO]  Using default agent var directory /var/lib/rancher/agent
[INFO]  Determined CA is necessary to connect to Rancher
[INFO]  Successfully downloaded CA certificate
[INFO]  Value from https://158.160.64.30/cacerts is an x509 certificate
[INFO]  Successfully tested Rancher connection
[INFO]  Downloading rancher-system-agent binary from https://158.160.64.30/assets/rancher-system-agent-amd64
[INFO]  Successfully downloaded the rancher-system-agent binary.
[INFO]  Downloading rancher-system-agent-uninstall.sh script from https://158.160.64.30/assets/system-agent-uninstall.sh
[INFO]  Successfully downloaded the rancher-system-agent-uninstall.sh script.
[INFO]  Generating Cattle ID
[INFO]  Successfully downloaded Rancher connection information
[INFO]  systemd: Creating service file
[INFO]  Creating environment file /etc/systemd/system/rancher-system-agent.env
[INFO]  Enabling rancher-system-agent.service
Created symlink /etc/systemd/system/multi-user.target.wants/rancher-system-agent.service → /etc/systemd/system/rancher-system-agent.service.
[INFO]  Starting/restarting rancher-system-agent.service
```

![Ссылка 2](https://github.com/Firewal7/application-project/blob/main/images/2.jpg)

2.1 В Visual Studio Code создал сервис, используя технологию ASP.NET Core MVC. GET запрос, возвращающий строку "Hello World!".

![Ссылка 3](https://github.com/Firewal7/application-project/blob/main/images/3.jpg)
![Ссылка 4](https://github.com/Firewal7/application-project/blob/main/images/4.jpg)

2.2 Создал докер образ для установки этого сервиса. 

<details>
<summary>docker build -t bbb8c2e28d7d/application:v1 .</summary>

root@agent:/home/user/app/Application/Application# docker build -t bbb8c2e28d7d/application:v1 .
[+] Building 62.2s (17/17) FINISHED                                                                docker:default
 => [internal] load build definition from Dockerfile                                                         0.0s
 => => transferring dockerfile: 1.15kB                                                                       0.0s
 => [internal] load .dockerignore                                                                            0.0s
 => => transferring context: 2B                                                                              0.0s
 => [internal] load metadata for mcr.microsoft.com/dotnet/aspnet:6.0                                         0.3s
 => [internal] load metadata for mcr.microsoft.com/dotnet/sdk:6.0                                            0.2s
 => [build 1/7] FROM mcr.microsoft.com/dotnet/sdk:6.0@sha256:8818cbf00fcea05359f04a0fe4acaf70228f6cf85c94fc  0.0s
 => [service 1/3] FROM mcr.microsoft.com/dotnet/aspnet:6.0@sha256:2e6e92e69f4e4395a0887ab373de3e8df5ec99cf2  0.0s
 => CACHED [service 2/3] WORKDIR /app                                                                        0.0s
 => [internal] load build context                                                                            0.1s
 => => transferring context: 34.13kB                                                                         0.0s
 => CACHED [build 2/7] WORKDIR /src                                                                          0.0s
 => CACHED [build 3/7] COPY [Application.csproj, ./]                                                         0.0s
 => CACHED [build 4/7] RUN dotnet restore "Application.csproj"                                               0.0s
 => CACHED [build 5/7] WORKDIR /src/Application                                                              0.0s
 => CACHED [build 6/7] COPY . .                                                                              0.0s
 => [build 7/7] RUN dotnet build "Application.csproj" -c Release -o /app/build                              31.8s
 => [publish 1/1] RUN dotnet publish "Application.csproj" -c Release -o /app/publish /p:UseAppHost=false    18.9s 
 => [service 3/3] COPY --from=publish /app .                                                                 0.5s 
 => exporting to image                                                                                       0.6s 
 => => exporting layers                                                                                      0.4s 
 => => writing image sha256:6594b155838fe90293891c4e3f02578885271659b34191ecc0e1bdd0e47fe3d2                 0.0s 
 => => naming to docker.io/bbb8c2e28d7d/application:v1             
</details>

```
root@agent:/home/user# docker images
REPOSITORY                 TAG       IMAGE ID       CREATED       SIZE
bbb8c2e28d7d/application   v1        a65a7e428b77   4 hours ago   216MB
```

2.3 Запуск Docker контейнера. 

```
root@agent:/home/user/app/Application/Application# docker run -it -p 8080:80 bbb8c2e28d7d/application:v1
warn: Microsoft.AspNetCore.DataProtection.Repositories.FileSystemXmlRepository[60]
      Storing keys in a directory '/root/.aspnet/DataProtection-Keys' that may not be persisted outside of the container. Protected data will be unavailable when container is destroyed.
warn: Microsoft.AspNetCore.DataProtection.KeyManagement.XmlKeyManager[35]
      No XML encryptor configured. Key {9d9653e8-2c1e-4732-8752-60faa296adb7} may be persisted to storage in unencrypted form.
info: Microsoft.Hosting.Lifetime[14]
      Now listening on: http://[::]:80
info: Microsoft.Hosting.Lifetime[0]
      Application started. Press Ctrl+C to shut down.
info: Microsoft.Hosting.Lifetime[0]
      Hosting environment: Production
info: Microsoft.Hosting.Lifetime[0]
      Content root path: /app/
warn: Microsoft.AspNetCore.HttpsPolicy.HttpsRedirectionMiddleware[3]
      Failed to determine the https port for redirect.
```
```
root@agent:/home/user# docker ps
CONTAINER ID   IMAGE                         COMMAND                  CREATED       STATUS       PORTS                                   NAMES
0f7461853941   bbb8c2e28d7d/application:v1   "dotnet Application.…"   3 hours ago   Up 3 hours   0.0.0.0:8080->80/tcp, :::8080->80/tcp   modest_poincare
```

![Ссылка 5](https://github.com/Firewal7/application-project/blob/main/images/5.jpg)

[Dockerfile](https://github.com/Firewal7/devops-netology/blob/main/image/09-ci-04-jenkins-2.jpg)
