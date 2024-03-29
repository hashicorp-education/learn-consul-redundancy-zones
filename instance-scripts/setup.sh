#!/usr/bin/env bash
set -ex

setup_deps() {
  add-apt-repository universe -y
  curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
  apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
  apt update -qy
  version="${consul_version}"
  consul_package="consul-enterprise="$${version:1}"*"
  apt install -qy apt-transport-https gnupg2 curl lsb-release $${consul_package} unzip jq tree apache2-utils nginx awscli
}

setup_networking() {
  # echo 1 | tee /proc/sys/net/bridge/bridge-nf-call-arptables
  # echo 1 | tee /proc/sys/net/bridge/bridge-nf-call-ip6tables
  # echo 1 | tee /proc/sys/net/bridge/bridge-nf-call-iptables
  curl -L -o cni-plugins.tgz "https://github.com/containernetworking/plugins/releases/download/v1.0.0/cni-plugins-linux-$([ $(uname -m) = aarch64 ] && echo arm64 || echo amd64)"-v1.0.0.tgz
  mkdir -p /opt/cni/bin
  tar -C /opt/cni/bin -xzf cni-plugins.tgz
  rm /home/ubuntu/cni-plugins.tgz
  hostnamectl set-hostname "${hostname}"
}

setup_consul() {
  echo "${consul_ca}" | base64 -d >/etc/consul.d/ca.pem
  echo "${consul_license}" | base64 -d >/etc/consul.d/consul.hclic
  echo "${consul_config}" | base64 -d >client.temp.1
  jq '.bind_addr = "{{ GetPrivateInterfaces | include \"network\" \"'${vpc_cidr}'\" | attr \"address\" }}"' client.temp.1 >/etc/consul.d/client.json
  rm /home/ubuntu/client.temp.*
  sed -i 's/notify/simple/g' /usr/lib/systemd/system/consul.service
  systemctl daemon-reload
  systemctl enable consul.service
  systemctl start consul.service
  usermod -a -G consul ubuntu
}

cd /home/ubuntu/

setup_networking
setup_deps
setup_consul

echo "done"
