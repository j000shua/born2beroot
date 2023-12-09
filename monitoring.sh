ARCH=$(uname -a)

pCPU=$(cat /proc/cpuinfo | grep "physical id" | uniq | wc -l)
vCPU=$(cat /proc/cpuinfo | grep "processor" | wc -l)

tMEM=$(free -m | grep -Po '^[Mem:\s]+\K\d+')
uMEM=$(free -m | grep -Po '^Mem:\s+\d+\s+\K\d+')
pMEM=$((uMEM * 100 / tMEM))

tDISK=$(df -H --total | grep -Po '^total\s+\K[\d.]+')
uDISK=$(df -H --total | grep -Po '^total\s+[\d.]+G\s+\K[\d.]+')
pDISK=$(df -H --total | grep total | grep -Po '[\d.]+%')

CPUu=$(grep 'cpu ' /proc/stat | awk '{print 100 - ($5*100)/($2+$3+$4+$5+$6+$7+$8+$9+$10)}')

LASTBOOT=$(who -b | rev | cut -c 1-16 | rev)

LVM=$(lsblk | grep lvm | wc -l)
LVM2=$(if [$LVM -eq 0]; then echo no; else echo yes; fi)

TCP=$(ss -s | grep -Po 'estab \K\d+')

USERS=$(who | wc -l)

IP=$(ip addr show enp0s3 | grep -Po 'inet \K[\d.]+')
MAC=$(ip addr show enp0s3 | grep -Po 'ether \K[\da-z:]+')

SUDO=$(sudoreplay -d /var/log/sudo -l | wc -l)

wall "#Architecture: $ARCH
#CPU physical:  $pCPU
#vCPU: $vCPU
#Memory usage: $uMEM/$tMEM MB ($pMEM%)
#Disk usage: $uDISK/$tDISK GB ($pDISK)
#CPU usage: $CPUu%
#Last boot: $LASTBOOT
#LVM use: $LVM2
#Connections TCP: $TCP
#User log: $USERS
#Network: $IP ($MAC)
#Sudo: $SUDO"
