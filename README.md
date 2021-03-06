# Automated ELK Stack Deployment

The files in this repository were used to configure the network depicted below. 

![DVWA-ELK Network](https://drive.google.com/file/d/1uacveNDT0zj8tn6eg-I0ACCPbBxvRta8/view?usp=sharing)

These files have been tested and used to generate a live ELK deployment on Azure. They can be used to either recreate the entire deployment pictured above. Alternatively,. select portions of the DVWA-ELK Network file may be used to install only certain pieces of it, such as Filebeat. 
* The following script is the contents of the **install-elk.yml** file
https://github.com/kitchinka/ELK-Stack/blob/main/Ansible/install-elk.yml

This document contains the following details:
* Description of the Topology
* Access Policies
* ELK Configuration
  * Beats in Use
  * Machines Being Monitored
* How to Use the Ansible Build

# Description of the Topology

The main purpose of this network is to expose a load-balanced and monitored instance of DVWA, the D&mn Vulnerable Web Application.

Load balancing ensures that the application will be highly _available_, in addition to restricting _access_ to the network. 
* Load balancers protect the availability of systems by distributing service requests across a network rather than overloading a single server. The advantage of a jump box is that it serves as a type of DMZ, restricting access to machines on the internal network by serving as a gateway. 
Integrating an ELK server allows users to easily monitor the vulnerable VMs fore changes to the logs and system traffic. 
* Filebeat collects log events from log files or specified locations, then forwards these events to Elasticsearch or Logstash for indexing. 
* Metricbeat collects metrics and statistics from the OS and services running on the server. These metrics are forwarded to Elasticsearch or Logstash. 
The configuration details of each machine may be found below. 

Name | Function | IP Addess | Operating System
-----|----------|-----------|-----------------
Jump-Box | Gateway, Ansible, Docker | <dynamic external IP> 10.0.0.05 | Linux (Ubuntu 18.04-LTS)
Web-1 | DVWA Web server, Docker | 10.0.0.6 | Linux (Ubuntu 18.04-LTS)
Web-2 | DVWA Web server, Docker | 10.0.0.9 | Linux (Ubuntu 18.04-LTS)
Web-3 | DVWA Web server, Docker | 10.0.0.8 | Linux (Ubuntu 18.04-LTS)
ELK | Monitoring, ELK stack, Docker | <dynamic external IP> 10.1.0.4 | Linux (Ubuntu 18.04-LTS)

# Access Policies

The machines on the internal network are not exposed to the public Internet. 
Only the _Jump-Box_ machine can accept connections from the Internet. Access to this machine is only allowed from the following IP addresses:
* <my_personal_IP>
Machines within the network can only be accesssed by _Jump-Box_.
* Jump-Box (dynamic external; 10.0.0.5) can access the ELK VM.
A summary of the access policies in place can be found in the table below. 

Name | Publicly Accessbile | Allowed IP Addesses 
-----|---------------------|--------------------
Jump-Box | Yes | my_personal_IP 
Web-1 | No | 10.0.0.5 via LB 
Web-2 | No | 10.0.0.5 via LB 
Web-3 | No | 10.0.0.5 via LB 
ELK | No | 10.0.0.5 via SSH 

# ELK Configuration

Ansible was used to automate configuration of the ELK machine. NO configuration was performed manually, which is advantageous because...
* This significantly cuts down on labour hours needed for configuration, allowing personnel to focus their attention on more pressing concerns, such as analyzing the logs Filebeat and Metricbeat generate.

The install-elk playbook implements the following tasks:

* Install Docker
* Install Python3-pip
* Install Docker module
* Increase virtual memory
* Download and launch Docker ELK container image

The following screenshots display the result of successful installation of ELK and of running docker ps after successfully configuring the ELK instance.

Successful installation:
PLAY [Configure Elk VM with Docker] ********************************************
 
TASK [Gathering Facts] *********************************************************
ok: [10.1.0.4]
 
TASK [Install docker.io] *******************************************************
ok: [10.1.0.4]
 
TASK [Install python3-pip] *****************************************************
ok: [10.1.0.4]
 
TASK [Install Docker module] ***************************************************
ok: [10.1.0.4]
 
TASK [Increase virtual memory] *************************************************
ok: [10.1.0.4]
 
TASK [download and launch a docker elk container] ******************************
ok: [10.1.0.4]
 
PLAY RECAP *********************************************************************
10.1.0.4                   : ok=6    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

running docker ps:
azadmin@ELK:~$ sudo docker ps
CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS              PORTS                                                                              NAMES
f67d4d668772        sebp/elk:761        "/usr/local/bin/star…"   11 days ago         Up 10 minutes       0.0.0.0:5044->5044/tcp, 0.0.0.0:5601->5601/tcp, 0.0.0.0:9200->9200/tcp, 9300/tcp   elk

# Target Machines & Beats

This ELK server is configured to monitor the following machines:
* Web-1: 10.0.0.6
* Web-1: 10.0.0.9
* Web-1: 10.0.0.8 

We have installed the following Beats on these machines:
* Filebeat
* Metricbeat

These Beats allow us to collect the following information from each machine:

* Filebeat collects log events from log files or specified locations, then forwards these events to Elasticsearch or Logstash for indexing.
* Metricbeat collects metrics and statistics from the OS and services running on the server. These metrics are forwarded to Elasticsearch or Logstash. 

# Using the Playbook

In order to use the playbook, you will need to have an Ansible control node already configured. Assuming you have such a control node provisioned:

Open a tertminal and SSH into your Jump-Box
- ssh azadmin@[Jump-Box-external-IP]

Start the Ansible container
- sudo docker start [your-container-name]
- Hint: If you don't know your container's name, use sudo docker container list -a 

Use the Docker command to attach to your Ansible container
- sudo docker attach [your-container-name]
  * Copy the filebeat-config.yml file to /etc/ansible/files
  curl https://gist.githubusercontent.com/slape/5cc350109583af6cbe577bbcc0710c93/raw/eca603b72586fbe148c11f9c87bf96a63cb25760/Filebeat > /etc/ansible/files/filebeat-config.yml
  * Update the filebeat-config.yml file to include: nano filebeat-config.yml
  
  Scroll to line #1106 and replace the IP address with the IP address of your ELK machine.
output.elasticsearch:
hosts: ["10.1.0.4:9200"]
username: "elastic"
password: "changeme"
 
Scroll to line #1806 and replace the IP address with the IP address of your ELK machine.
setup.kibana:
host: "10.1.0.4:5601"

* Run the playbook and navigate to http://[your.ELK.VM.external.IP]:5601/app/kibana to check that the installation worked as expected. 

Filebeat Playbook
* Copy the playbook filebeat-playbook.yml to /etc/ansible/roles

---
- name: installing and launching filebeat
  hosts: webservers
  become: yes
  tasks:
 
  - name: download filebeat deb
    command: curl -L -O https://artifacts.elastic.co/downloads/beats/filebeat/filebeat-7.4.0-amd64.deb
 
  - name: install filebeat deb
    command: dpkg -i filebeat-7.4.0-amd64.deb
 
  - name: drop in filebeat.yml
    copy:
      src: /etc/ansible/files/filebeat-config.yml
      dest: /etc/filebeat/filebeat.yml
 
  - name: enable and configure system module
    command: filebeat modules enable system
 
  - name: setup filebeat
    command: filebeat setup
 
  - name: start filebeat service
    command: sudo service filebeat start

* The filebeat-playbook.yml file indicates which machine or group of machines install and launch filebeat in the hosts line. To change this:  nano /etc/ansible/roles/filebeat-playbook.yml and edit the [hosts](https://github.com/kitchinka/ELK-Stack/blob/main/Ansible/hosts.txt) line
* To specify which machines run ELK and which run Filebeat, update the hosts file. 
  * The playbook indcates which group of machines to install the program on, and the hosts file indicates which machines are in that named group. 

* Go to http://[your.ELK.VM.external.IP]:5601/app/kibana to make sure that your server is working properly. 

# Metricbeat Configuration

* Metricbeat is configured the same as Filebeat
* Run the metricbeat module's enable docker command
* Run the metricbeat setup command
Verify that your playbook works as expected:
* On the Metricbeat Installation Page inthe ELK server GUI, scroll to **Step 5: Module Status** and click **Check Data.**
<https://github.com/kitchinka/ELK-Stack/blob/main/Ansible/metricbeat-config.yml>


# Metricbeat Playbook

<https://github.com/kitchinka/ELK-Stack/blob/main/Ansible/metricbeat-playbook.yml>
