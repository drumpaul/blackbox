#!/bin/bash

src_cloud=cloud-config.template
dst_cloud=cloud-config.yml

ip link | awk '{print $2}'
echo

echo "digita il MAC address della scheda da configurare dall'elenco precedente"
read iface
echo
echo $iface
echo

sudo fdisk -l -o Device,Size
echo

echo "digita il disco su cui andrà installato il sistema operativo"
read dev
echo
echo $dev
echo

cp $src_cloud $dst_cloud

sed -i "s/___MACADDRESS___/${iface}/" $dst_cloud
sed -i "s+___DISK___+${dev}+" $dst_cloud

sudo ros config validate < cloud-config.yml

if [ $? -eq 0 ]
then
  echo "File $dst_cloud valido. Procedo all'installazione"
  sudo ros install -f -c $dst_cloud --append "rancher.password=rancher" -d $dev
else
  echo "File $dst_cloud non valido"
fi