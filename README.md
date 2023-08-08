1.  Деплой Kubernetes-кластера при помощи Rancher.

    Необходимо установить Rancher-server и создать кластер. Что нужно использовать:
-   ОС Linux (любой удобный дистрибутив).
-   Docker
-   Racher-server, Rancher-agent

2.  Микросервис.

- Необходимо реализовать сервис, используя технологию ASP.NET Core MVC. Затем создать докер образ для установки этого сервиса.

- Сервис должен содержать GET запрос, возвращающий строку "Hello World!".
Адрес запроса произвольный.

3.  Разработать helm-чарт для деплоя сервиса.
    Helm-чарт должен содержать описание следующих элементов:
-   Deployment
-   ConfigMap (если необходимо)
-   Service
-   Ingress (если необходимо)


4.  Загрузить HELM-чарт в любой Chart Museum (либо создать свой) и выполнить развертывание чарта в созданном на этапе 1 кластере Rancher.

5.  Продемонстрировать в браузере работу развернутого сервиса (вывод “Hello World!” либо стартовую страницу приложения)


### Решение:

1.1 Развернул 2 сервера на Yandex Cloud. (VM server, VM agent).

![Ссылка 1](https://github.com/Firewal7/application-project/blob/main/images/1.jpg)

1.2 Установил на VM server docker

<details>
<summary>docker install</summary>

user@server:/home/user# sudo curl -fsSL https://get.docker.com -o get-docker.sh && sudo sh get-docker.sh
 Executing docker install script, commit: c2de0811708b6d9015ed1a2c80f02c9b70c8ce7b
+ sh -c apt-get update -qq >/dev/null
+ sh -c DEBIAN_FRONTEND=noninteractive apt-get install -y -qq apt-transport-https ca-certificates curl >/dev/null
+ sh -c install -m 0755 -d /etc/apt/keyrings
+ sh -c curl -fsSL "https://download.docker.com/linux/ubuntu/gpg" | gpg --dearmor --yes -o /etc/apt/keyrings/docker.gpg
+ sh -c chmod a+r /etc/apt/keyrings/docker.gpg
+ sh -c echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu jammy stable" > /etc/apt/sources.list.d/docker.list
+ sh -c apt-get update -qq >/dev/null
+ sh -c DEBIAN_FRONTEND=noninteractive apt-get install -y -qq docker-ce docker-ce-cli containerd.io docker-compose-plugin docker-ce-rootless-extras docker-buildx-plugin >/dev/null
+ sh -c docker version
Client: Docker Engine - Community
 Version:           24.0.5
 API version:       1.43
 Go version:        go1.20.6
 Git commit:        ced0996
 Built:             Fri Jul 21 20:35:18 2023
 OS/Arch:           linux/amd64
 Context:           default

Server: Docker Engine - Community
 Engine:
  Version:          24.0.5
  API version:      1.43 (minimum version 1.12)
  Go version:       go1.20.6
  Git commit:       a61e2b4
  Built:            Fri Jul 21 20:35:18 2023
  OS/Arch:          linux/amd64
  Experimental:     false
 containerd:
  Version:          1.6.22
  GitCommit:        8165feabfdfe38c65b599c4993d227328c231fca
 runc:
  Version:          1.1.8
  GitCommit:        v1.1.8-0-g82f18fe
 docker-init:
  Version:          0.19.0
  GitCommit:        de40ad0

</details>

1.3 Запустил Rancher в Контейнере на VM server

```
user@server:~$ sudo docker run -d --restart=unless-stopped -p 80:80 -p 443:443 -v /opt/rancher:/var/lib/rancher --privileged rancher/rancher:latest
Unable to find image 'rancher/rancher:latest' locally
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
f54bb56e844d853d32ad1626cdcba885bd354847f268426ae089267aa3eeb3ea
```

1.5 Запустил на VM agent созданный на Rancher cluster

```
ser@agent:~$ sudo curl --insecure -fL https://158.160.65.138/system-agent-install.sh | sudo  sh -s - --server https://158.160.65.138 --label 'cattle.io/os=linux' --token pcmwfx8l6rvh965gwbp9bbdznncwn8fnqt4569d94wbsztn4t9cbrw --ca-checksum 9f44aed915e0aa868b2dce1adda08aa39c08486e9d0da0548be8e6a0f3d9892d --etcd --controlplane --worker
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100 30853    0 30853    0     0   729k      0 --:--:-- --:--:-- --:--:--  734k
[INFO]  Label: cattle.io/os=linux
[INFO]  Role requested: etcd
[INFO]  Role requested: controlplane
[INFO]  Role requested: worker
[INFO]  Using default agent configuration directory /etc/rancher/agent
[INFO]  Using default agent var directory /var/lib/rancher/agent
[INFO]  Determined CA is necessary to connect to Rancher
[INFO]  Successfully downloaded CA certificate
[INFO]  Value from https://158.160.65.138/cacerts is an x509 certificate
[INFO]  Successfully tested Rancher connection
[INFO]  Downloading rancher-system-agent binary from https://158.160.65.138/assets/rancher-system-agent-amd64
[INFO]  Successfully downloaded the rancher-system-agent binary.
[INFO]  Downloading rancher-system-agent-uninstall.sh script from https://158.160.65.138/assets/system-agent-uninstall.sh
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
```
root@agent:/home/user/app/Application/Application# docker build -t bbb8c2e28d7d/application:latest .
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
 => => naming to docker.io/bbb8c2e28d7d/application:latest             
```

```
root@agent:/home/user# docker images
REPOSITORY                 TAG       IMAGE ID       CREATED       SIZE
bbb8c2e28d7d/application   latest        a65a7e428b77   4 hours ago   216MB
```

2.3 Запушил docker images на Dockerhub

```
root@agent:/home/user/app/Application/Application# docker login -u bbb8c2e28d7d
Password:
WARNING! Your password will be stored unencrypted in /root/.docker/config.json.
Configure a credential helper to remove this warning. See
https://docs.docker.com/engine/reference/commandline/login/#credentials-store

Login Succeeded
root@agent:/home/user/app/Application/Application# docker push bbb8c2e28d7d/application:latest
The push refers to repository [docker.io/bbb8c2e28d7d/application]
8cc29b3bd156: Pushed
f22821468b1c: Pushed
be37720e5f82: Pushed
72a7e3e0cdae: Pushed
8de6f7578c38: Pushed
b63bee926c4e: Pushed
8ce178ff9f34: Pushed
v1: digest: sha256:9b986b0312b4f0a47687e1d01b2bb6a3cc74d3df60266f09703d9d9cdc1007f0 size: 1788
```
![Ссылка 6](https://github.com/Firewal7/application-project/blob/main/images/6.jpg)

2.4 Запуск Docker контейнера.

```
user@server:~$ sudo docker run -it -p 8080:80 bbb8c2e28d7d/application:latest
Unable to find image 'bbb8c2e28d7d/application:latest' locally
latest: Pulling from bbb8c2e28d7d/application
1d5252f66ea9: Pull complete
75b8c875f256: Pull complete
615785a9af88: Pull complete
57e202db4287: Pull complete
91c4be48c2b1: Pull complete
05ee0f944a9c: Pull complete
4f4fb700ef54: Pull complete
75c96ee47b9f: Pull complete
Digest: sha256:bc9e637c8cce5edde2ffba54880a56b2e733580da07cecec77930e77b95819ee
Status: Downloaded newer image for bbb8c2e28d7d/application:latest
warn: Microsoft.AspNetCore.DataProtection.Repositories.FileSystemXmlRepository[60]
      Storing keys in a directory '/root/.aspnet/DataProtection-Keys' that may not be persisted outside of the container. Protected data will be unavailable when container is destroyed.
warn: Microsoft.AspNetCore.DataProtection.KeyManagement.XmlKeyManager[35]
      No XML encryptor configured. Key {0f44da5f-6672-44ac-8221-d7a0387734e4} may be persisted to storage in unencrypted form.
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
user@server:~$ sudo docker ps
CONTAINER ID   IMAGE                    COMMAND           CREATED          STATUS          PORTS                                                                      NAMES
f54bb56e844d   rancher/rancher:latest   "entrypoint.sh"   21 minutes ago   Up 21 minutes   0.0.0.0:80->80/tcp, :::80->80/tcp, 0.0.0.0:443->443/tcp, :::443->443/tcp   naughty_gates

```

- Приложение работает на locahost сервера VM Server на порте 8080.

![Ссылка 5](https://github.com/Firewal7/application-project/blob/main/images/5.jpg)

[Ссылка на Dockerfile](https://github.com/Firewal7/application-project/blob/main/Dockerfile)

[Ссылка на Application](https://github.com/Firewal7/application-project/blob/main/Application)

3. Разработал helm-чарт для деплоя сервиса.

[Ссылка на Helm-Chart](https://github.com/Firewal7/application-project/blob/main/helm-chart)

4. Загрузил Helm в Chart Museum (https://sofin.baltorepo.com/application/app/)

```
└─# helm package helm-chart/                                                                       
Successfully packaged chart and saved it to: /home/kali/app/application-project/helm-chart-0.1.0.tgz

```
<details>
<summary>Загрузка helm-chart в Chart Museum</summary>

└─# sudo curl --verbose   --header "Authorization: Bearer b7c8e8d902c367c608b7e0feea044138c73d51f1"   --form "chart=@helm-chart-0.1.0.tgz"   https://sofin.baltorepo.com/application/app/upload/
*   Trying 178.128.157.133:443...
* Connected to sofin.baltorepo.com (178.128.157.133) port 443 (#0)
* ALPN: offers h2,http/1.1
* TLSv1.3 (OUT), TLS handshake, Client hello (1):
*  CAfile: /etc/ssl/certs/ca-certificates.crt
*  CApath: /etc/ssl/certs
* TLSv1.3 (IN), TLS handshake, Server hello (2):
* TLSv1.2 (IN), TLS handshake, Certificate (11):
* TLSv1.2 (IN), TLS handshake, Server key exchange (12):
* TLSv1.2 (IN), TLS handshake, Server finished (14):
* TLSv1.2 (OUT), TLS handshake, Client key exchange (16):
* TLSv1.2 (OUT), TLS change cipher, Change cipher spec (1):
* TLSv1.2 (OUT), TLS handshake, Finished (20):
* TLSv1.2 (IN), TLS handshake, Finished (20):
* SSL connection using TLSv1.2 / ECDHE-RSA-AES256-GCM-SHA384
* ALPN: server accepted http/1.1
* Server certificate:
*  subject: CN=*.baltorepo.com
*  start date: Jun 17 23:15:39 2023 GMT
*  expire date: Sep 15 23:15:38 2023 GMT
*  subjectAltName: host "sofin.baltorepo.com" matched cert's "*.baltorepo.com"
*  issuer: C=US; O=Let's Encrypt; CN=R3
*  SSL certificate verify ok.
* using HTTP/1.1
> POST /application/app/upload/ HTTP/1.1
> Host: sofin.baltorepo.com
> User-Agent: curl/7.88.1
> Accept: */*
> Authorization: Bearer b7c8e8d902c367c608b7e0feea044138c73d51f1
> Content-Length: 1006
> Content-Type: multipart/form-data; boundary=------------------------d79c748b1286a31d
> 
* We are completely uploaded and fine
< HTTP/1.1 200 OK
< Server: nginx/1.18.0 (Ubuntu)
< Date: Tue, 08 Aug 2023 12:29:09 GMT
< Content-Type: application/json
< Content-Length: 181
< Connection: keep-alive
< Vary: Accept
< Allow: POST, OPTIONS
< X-Frame-Options: SAMEORIGIN
< 
* Connection #0 to host sofin.baltorepo.com left intact
{"success":true,"message":"","package_site_url":"/application/app/packages/helm-chart/releases/0.1.0/","package_api_url":"/api/v1/project/44/repository/57/helmchart/22/release/50/"}

</details>

![Ссылка 6](https://github.com/Firewal7/application-project/blob/main/images/6.jpg)

4.1 Добавил Helm репозиторий, установил Helm-chart.

![Ссылка 7](https://github.com/Firewal7/application-project/blob/main/images/7.jpg)

5. Работающий в браузере сервис. 

![Ссылка 8](https://github.com/Firewal7/application-project/blob/main/images/8.jpg)

![Ссылка 9](https://github.com/Firewal7/application-project/blob/main/images/9.jpg) 
