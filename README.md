# ELK-Stack
**Automated ELK Stack Deployment**
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

**Description of the Topology**
The main purpose of this network is to expose a load-balanced and monitored instance of DVWA, the D*mn Vulnerable Web Application.

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

**Access Policies** 
The machines on the internal network are not exposed to the public Internet. 
Only the _Jump-Box_ machine can accept connections from the Internet. Access to this machine is only allowed from the following IP addresses:
* <my_personal_IP>
Machines within the network can only be accesssed by _Jump-Box_.
* Jump-Box (dynamic external; 10.0.0.5) can access the ELK VM
A summary of hte access policies in place can be found in the table below. 

Name | Publicly Accessbile | Allowed IP Addesses
Jump-Box | Yes | my_personal_IP
Web-1 | No | 10.0.0.5 via LB
Web-2 | No | 10.0.0.5 via LB
Web-3 | No | 10.0.0.5 via LB
ELK | No | 10.0.0.5 via SSH

**ELK Configuration**
Ansible was used to automate configuration of the ELK machine. NO configuration was performed manually, which is advantageous because...
* This significantly cuts down on labour hours needed for configuration, allowing personnel to focus their attention on more pressing concerns, such as analyzing the logs Filebeat and Metricbeat generate.

The install-elk playbook inplements the following tasks:
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

**Target Machines & Beats**
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

**Using the Playbook**
In order to use the pjlaybook, you will need to have an Ansible control node already configured. Assuming you have such a control node provisioned:

Open a tertminal and SSH into your Jump-Box
  ssh azadmin@[Jump-Box-external-IP]
Start the Ansible container
  sudo docker start [your-container-name]
  Hint: If you don't know your container's name, use sudo docker container list -a 
Use the Docker command to attach to your Ansible container
  sudo docker attach [your-container-name]
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

* The filebeat-playbook.yml file indicates which machine or group of machines install and launch filebeat in the hosts line. To change this:  nano /etc/ansible/roles/filebeat-playbook.yml and edit the [hosts] line
* To specify which machines run ELK and which run Filebeat, update the hosts file. 
  * The playbook indcates which group of machines to install the program on, and the hosts file indicates which machines are in that named group. 

  # This is the default ansible 'hosts' file.
#
# It should live in /etc/ansible/hosts
#
#   - Comments begin with the '#' character
#   - Blank lines are ignored
#   - Groups of hosts are delimited by [header] elements
#   - You can enter hostnames or ip addresses
#   - A hostname/ip can be a member of multiple groups

# Ex 1: Ungrouped hosts, specify before any group headers.

## green.example.com
## blue.example.com
## 192.168.100.1
## 192.168.100.10

# Ex 2: A collection of hosts belonging to the 'webservers' group

[webservers]
## alpha.example.org
## beta.example.org
## 1992.168.1.100
## 192.168.1.110
10.0.0.6 ansible_python_interpreter=/usr/bin/python3
10.0.0.9 ansible_python_interpreter=/usr/bin/python3
10.0.0.8 ansible_python_interpreter=/usr/bin/python3

[elk]
10.1.0.4 ansible_python_interpreter=/usr/bin/python3

# If you have multiple hosts following a pattern you can specify
# them like this:

## www[001:006].example.com

# Ex 3: A collection of database servers in the 'dbservers' group

## [dbservers]
##
## db01.intranet.mydomain.net
## db02.intranet.mydomain.net
## 10.25.1.56
## 10.25.1.57

# Here's another example of host ranges, this time there are no
# leading 0s:

## db-[99:101]-node.example.com

* Go to http://[your.ELK.VM.external.IP]:5601/app/kibana to make sure that your server is working properly. 

Metricbeat Configuration
* Metricabeat is configured the same as Filebeat
* Run the metricbeat module's enable docker command
* Run the metricbeat setup command
Verify that your playbook works as expected:
* On the Metricbeat Installation Page inthe ELK server GUI, scroll to **Step 5: Module Status** and click **Check Data.**
###################### Metricbeat Configuration Example #######################
 
# This file is an example configuration file highlighting only the most common
# options. The metricbeat.reference.yml file from the same directory contains all the
# supported options with more comments. You can use it as a reference.
#
# You can find the full configuration reference here:
# https://www.elastic.co/guide/en/beats/metricbeat/index.html
 
#==========================  Modules configuration ============================
 
metricbeat.config.modules:
  # Glob pattern for configuration loading
  path: ${path.config}/modules.d/*.yml
 
  # Set to true to enable config reloading
  reload.enabled: false
 
  # Period on which files under path should be checked for changes
  #reload.period: 10s
 
#==================== Elasticsearch template setting ==========================
 
setup.template.settings:
  index.number_of_shards: 1
  index.codec: best_compression
  #_source.enabled: false
 
#================================ General =====================================
 
# The name of the shipper that publishes the network data. It can be used to group
# all the transactions sent by a single shipper in the web interface.
#name:
 
# The tags of the shipper are included in their own field with each
# transaction published.
#tags: ["service-X", "web-tier"]
 
# Optional fields that you can specify to add additional information to the
# output.
#fields:
#  env: staging
 
 
#============================== Dashboards =====================================
# These settings control loading the sample dashboards to the Kibana index. Loading
# the dashboards is disabled by default and can be enabled either by setting the
# options here or by using the `setup` command.
#setup.dashboards.enabled: false
 
# The URL from where to download the dashboards archive. By default this URL
# has a value which is computed based on the Beat name and version. For released
# versions, this URL points to the dashboard archive on the artifacts.elastic.co
# website.
#setup.dashboards.url:
 
#============================== Kibana =====================================
 
# Starting with Beats version 6.0.0, the dashboards are loaded via the Kibana API.
# This requires a Kibana endpoint configuration.
setup.kibana:
  host: "10.1.0.4:5601"
 
  # Kibana Host
  # Scheme and port can be left out and will be set to the default (http and 5601)
  # In case you specify and additional path, the scheme is required: http://localhost:5601/path
  # IPv6 addresses should always be defined as: https://[2001:db8::1]:5601
  #host: "localhost:5601"
 
  # Kibana Space ID
  # ID of the Kibana Space into which the dashboards should be loaded. By default,
  # the Default Space will be used.
  #space.id:
 
#============================= Elastic Cloud ==================================
 
# These settings simplify using Metricbeat with the Elastic Cloud (https://cloud.elastic.co/).
 
# The cloud.id setting overwrites the `output.elasticsearch.hosts` and
# `setup.kibana.host` options.
# You can find the `cloud.id` in the Elastic Cloud web UI.
#cloud.id:
 
# The cloud.auth setting overwrites the `output.elasticsearch.username` and
# `output.elasticsearch.password` settings. The format is `<user>:<pass>`.
#cloud.auth:
 
#================================ Outputs =====================================
 
# Configure what output to use when sending the data collected by the beat.
 
#-------------------------- Elasticsearch output ------------------------------
output.elasticsearch:
  # Array of hosts to connect to.
  hosts: ["10.1.0.4:9200"]
  username: "elastic"
  password: "changeme"
 
  # Optional protocol and basic auth credentials.
  #protocol: "https"
  #username: "elastic"
  #password: "changeme"
 
#----------------------------- Logstash output --------------------------------
#output.logstash:
  # The Logstash hosts
  #hosts: ["localhost:5044"]
 
  # Optional SSL. By default is off.
  # List of root certificates for HTTPS server verifications
  #ssl.certificate_authorities: ["/etc/pki/root/ca.pem"]
 
  # Certificate for SSL client authentication
  #ssl.certificate: "/etc/pki/client/cert.pem"
 
  # Client Certificate Key
  #ssl.key: "/etc/pki/client/cert.key"
 
#================================ Processors =====================================
 
# Configure processors to enhance or manipulate events generated by the beat.
 
processors:
  - add_host_metadata: ~
  - add_cloud_metadata: ~
 
#================================ Logging =====================================
 
# Sets log level. The default log level is info.
# Available log levels are: error, warning, info, debug
#logging.level: debug
 
# At debug level, you can selectively enable logging only for some components.
# To enable all selectors use ["*"]. Examples of other selectors are "beat",
# "publish", "service".
#logging.selectors: ["*"]
 
#============================== X-Pack Monitoring ===============================
# metricbeat can export internal metrics to a central Elasticsearch monitoring
# cluster.  This requires xpack monitoring to be enabled in Elasticsearch.  The
# reporting is disabled by default.
 
# Set to true to enable the monitoring reporter.
#monitoring.enabled: false
 
# Sets the UUID of the Elasticsearch cluster under which monitoring data for this
# Metricbeat instance will appear in the Stack Monitoring UI. If output.elasticsearch
# is enabled, the UUID is derived from the Elasticsearch cluster referenced by output.elasticsearch.
#monitoring.cluster_uuid:
 
# Uncomment to send the metrics to Elasticsearch. Most settings from the
# Elasticsearch output are accepted here as well.
# Note that the settings should point to your Elasticsearch *monitoring* cluster.
# Any setting that is not set is automatically inherited from the Elasticsearch
# output configuration, so if you have the Elasticsearch output configured such
# that it is pointing to your Elasticsearch monitoring cluster, you can simply
# uncomment the following line.
#monitoring.elasticsearch:
 
#================================= Migration ==================================
 
# This allows to enable 6.7 migration aliases
#migration.6_to_7.enabled: true

Metricbeat Playbook
---
- name: installing and launching metricbeat
  hosts: webservers
  become: yes
  tasks:
 
  - name: download metricbeat deb
    command: curl -L -O https://artifacts.elastic.co/downloads/beats/metricbeat/metricbeat-7.4.0-amd64.deb
 
  - name: install metricbeat deb
    command: dpkg -i metricbeat-7.4.0-amd64.deb
 
  - name: drop in metricbeat.yml
    copy:
      src: /etc/ansible/files/metricbeat-config.yml
      dest: /etc/metricbeat/metricbeat.yml
 
  - name: enable and configure system module
    command: metricbeat modules enable docker
 
  - name: setup metricbeat
    command: metricbeat setup
 
  - name: start metricbeat service
    command: service metricbeat start
