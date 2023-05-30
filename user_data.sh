#!/bin/bash

echo "RUNNING - yum update"
sudo yum update -y

echo "RUNNING - Install apache and starting it..."
sudo yum install httpd -y
sudo service httpd on
sudo service httpd start

# for ARM systems, set ARCH to: `arm64`, `armv6` or `armv7`
ARCH=amd64
PLATFORM=$(uname -s)_$ARCH

# Download kubectl and eksctl
echo "RUNNING - Download kubectl and eksctl"
curl -sLO https://s3.us-west-2.amazonaws.com/amazon-eks/1.26.4/2023-05-11/bin/linux/amd64/kubectl
chmod +x ./kubectl

curl -sLO "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$PLATFORM.tar.gz"
tar -xzf eksctl_$PLATFORM.tar.gz -C /tmp && rm eksctl_$PLATFORM.tar.gz

echo "RUNNING - Moving kubectl and eksctl to /usr/local/bin"
sudo mv kubectl /usr/local/bin
sudo mv /tmp/eksctl /usr/local/bin

echo "RUNNING - Complete user data script"
