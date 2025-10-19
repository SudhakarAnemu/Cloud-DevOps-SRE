js

https://docs.docker.com/engine/install/rhel/#install-from-a-package
https://docs.docker.com/compose/install/standalone/


[root@esb-poc-instance-1 docker]#  gsutil -m cpgs://esb_bucket/docker/* .
CommandException: Invalid command "cpgs://esb_bucket/docker/*".
[root@esb-poc-instance-1 docker]#  gsutil -m cp gs://esb_bucket/docker/* .
Copying gs://esb_bucket/docker/containerd.io-1.6.28-3.1.el8.x86_64.rpm...
Copying gs://esb_bucket/docker/docker-buildx-plugin-0.12.1-1.el8.x86_64.rpm...
Copying gs://esb_bucket/docker/docker-ce-25.0.3-1.el8.x86_64.rpm...
Copying gs://esb_bucket/docker/docker-ce-cli-25.0.3-1.el8.x86_64.rpm...
Copying gs://esb_bucket/docker/docker-ce-rootless-extras-25.0.3-1.el8.x86_64.rpm...
Copying gs://esb_bucket/docker/docker-compose-plugin-2.24.6-1.el8.x86_64.rpm...
[root@esb-poc-instance-1 docker]#   99% Done
[root@esb-poc-instance-1 docker]# pwd
/root/sws/docker
[root@esb-poc-instance-1 docker]#

sudo dnf install ./containerd.io-<version>.<arch>.rpm \
  ./docker-ce-<version>.<arch>.rpm \
  ./docker-ce-cli-<version>.<arch>.rpm \
  ./docker-buildx-plugin-<version>.<arch>.rpm \
  ./docker-compose-plugin-<version>.<arch>.rpm

  
[root@esb-poc-instance-1 docker]# ls -lrt
total 101552
-rw-r--r--. 1 root root 13642596 Dec  2 10:54 docker-compose-plugin-2.24.6-1.el8.x86_64.rpm
-rw-r--r--. 1 root root  5207500 Dec  2 10:54 docker-ce-rootless-extras-25.0.3-1.el8.x86_64.rpm
-rw-r--r--. 1 root root  7677464 Dec  2 10:54 docker-ce-cli-25.0.3-1.el8.x86_64.rpm
-rw-r--r--. 1 root root 13580412 Dec  2 10:54 docker-buildx-plugin-0.12.1-1.el8.x86_64.rpm
-rw-r--r--. 1 root root 27358736 Dec  2 10:54 docker-ce-25.0.3-1.el8.x86_64.rpm
-rw-r--r--. 1 root root 36511704 Dec  2 10:54 containerd.io-1.6.28-3.1.el8.x86_64.rpm
[root@esb-poc-instance-1 docker]#

sudo dnf install ./containerd.io-<version>.<arch>.rpm \
  ./docker-ce-<version>.<arch>.rpm \
  ./docker-ce-cli-<version>.<arch>.rpm \
  ./docker-buildx-plugin-<version>.<arch>.rpm \
  ./docker-compose-plugin-<version>.<arch>.rpm
  
rpm -ivh containerd.io-1.6.28-3.1.el8.x86_64.rpm

[root@esb-poc-instance-1 docker]# rpm -ivh containerd.io-1.6.28-3.1.el8.x86_64.rpm
warning: containerd.io-1.6.28-3.1.el8.x86_64.rpm: Header V4 RSA/SHA512 Signature, key ID 621e9f35: NOKEY
error: Failed dependencies:
        container-selinux >= 2:2.74 is needed by containerd.io-1.6.28-3.1.el8.x86_64
		
[root@esb-poc-instance-1 docker]# rpm -ivh containerd.io-1.6.28-3.1.el8.x86_64.rpm
warning: containerd.io-1.6.28-3.1.el8.x86_64.rpm: Header V4 RSA/SHA512 Signature, key ID 621e9f35: NOKEY
Verifying...                          ################################# [100%]
Preparing...                          ################################# [100%]
Updating / installing...
   1:containerd.io-1.6.28-3.1.el8     ################################# [100%]

[root@esb-poc-instance-1 docker]# yum install container-selinux
Updating Subscription Management repositories.
Unable to read consumer identity
[root@esb-poc-instance-1 docker]# rpm -ivh docker-ce-25.0.3-1.el8.x86_64.rpm docker-ce-cli-25.0.3-1.el8.x86_64.rpm docker-buildx-plugin-0.12.1-1.el8.x86_64.rpm
warning: docker-ce-25.0.3-1.el8.x86_64.rpm: Header V4 RSA/SHA512 Signature, key ID 621e9f35: NOKEY
error: Failed dependencies:
        libcgroup is needed by docker-ce-3:25.0.3-1.el8.x86_64


[root@esb-poc-instance-1 docker]# rpm -ivh docker-ce-25.0.3-1.el8.x86_64.rpm docker-ce-cli-25.0.3-1.el8.x86_64.rpm docker-buildx-plugin-0.12.1-1.el8.x86_64.rpm
warning: docker-ce-25.0.3-1.el8.x86_64.rpm: Header V4 RSA/SHA512 Signature, key ID 621e9f35: NOKEY
Verifying...                          ################################# [100%]
Preparing...                          ################################# [100%]
Updating / installing...
   1:docker-buildx-plugin-0:0.12.1-1.e################################# [ 33%]
   2:docker-ce-cli-1:25.0.3-1.el8     ################################# [ 67%]
   3:docker-ce-3:25.0.3-1.el8         ################################# [100%]
[root@esb-poc-instance-1 docker]#

[root@esb-poc-instance-1 docker]# rpm -ivh docker-compose-plugin-2.24.6-1.el8.x86_64.rpm
warning: docker-compose-plugin-2.24.6-1.el8.x86_64.rpm: Header V4 RSA/SHA512 Signature, key ID 621e9f35: NOKEY
Verifying...                          ################################# [100%]
Preparing...                          ################################# [100%]
Updating / installing...
   1:docker-compose-plugin-0:2.24.6-1.################################# [100%]
[root@esb-poc-instance-1 docker]#

[root@esb-poc-instance-1 docker]# rpm -ivh docker-compose-plugin-2.24.6-1.el8.x86_64.rpm
warning: docker-compose-plugin-2.24.6-1.el8.x86_64.rpm: Header V4 RSA/SHA512 Signature, key ID 621e9f35: NOKEY
Verifying...                          ################################# [100%]
Preparing...                          ################################# [100%]
Updating / installing...
   1:docker-compose-plugin-0:2.24.6-1.################################# [100%]
[root@esb-poc-instance-1 docker]# sudo systemctl enable --now docker
Created symlink /etc/systemd/system/multi-user.target.wants/docker.service → /usr/lib/systemd/system/docker.service.
[

 sudo systemctl enable --now docker-compose
 
 docker compose : 
 
 [root@esb-poc-instance-1 docker]# curl -SL https://github.com/docker/compose/releases/download/v2.30.3/docker-compose-linux-x86_64 -o /usr/local/bin/docker-compose
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
  0     0    0     0    0     0      0      0 --:--:-- --:--:-- --:--:--     0
100 61.0M  100 61.0M    0     0   243M      0 --:--:-- --:--:-- --:--:--  243M
[root@esb-poc-instance-1 docker]#

[root@esb-poc-instance-1 docker]# ls -l /usr/local/bin/docker-compose
-rw-r--r--. 1 root root 64044374 Dec  2 11:56 /usr/local/bin/docker-compose
[root@esb-poc-instance-1 docker]#


sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose


