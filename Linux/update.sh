!/bin/bash
mkdir -p /var/backup
tar cvf /var/backup/home.tar /home
mv /var/backup/home.tar /var/backup/home.last.tar
tar cvf /var/backup/system.tar /home
ls -lh /var/backup > /var/backup/file_report.txt
free -h > /var/backup/disk_report.txtupdate.sh
#!/bin/bash
apt update -y
apt upgrade -y
apt full-upgrade -y
apt autoremove --purge -y
apt update -y && apt upgrade -y && apt full-upgrade -y && apt-get autoremove --purge -y