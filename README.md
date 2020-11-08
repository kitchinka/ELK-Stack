Automated ELK Stack Deployment
The files in this repository were used to configure the network depicted below.

These files have been tested and used to generate a live ELK deployment on Azure. They can be used to either recreate the entire deployment pictured above. Alternatively, select portions of the DVWA-ELK Network file may be used to install only certain pieces of it, such as Filebeat.
The following script is the contents of the install-elk.yml file
---
- name: Configure Elk VM with Docker
  hosts: elk
  remote_user: azadmin
  become: true
  tasks:
    # Use apt module
    - name: Install docker.io
      apt:
        update_cache: yes
        force_apt_get: yes
        name: docker.io
        state: present
 
    # Use apt module
    - name: Install python3-pip
      apt:
        force_apt_get: yes
        name: python3-pip
        state: present
 
    # Use pip module (It will default to pip3)
    - name: Install Docker module
      pip:
        name: docker
        state: present
 
    # Use command module
    - name: Increase virtual memory
     sysctl:
        name: vm.max_map_count
        value: '262144'
        state: present
        reload: yes
 
    # Use docker_container module
    - name: download and launch a docker elk container
      docker_container:
        name: elk
       image: sebp/elk:761
        state: started
        restart_policy: always
        # Please list the ports that ELK runs on
        published_ports:
          -  5601:5601
          -  9200:9200
          -  5044:5044
