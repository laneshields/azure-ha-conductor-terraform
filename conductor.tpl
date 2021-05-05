write_files:
- path: /etc/128technology/salt/pki/master/master.pem
  content: |
    ${master_pem}
- path: /etc/128technology/salt/pki/master/master.pub
  content: |
    ${master_pub}
- path: /etc/128technology/ssh/pdc_ssh_key
  content: |
    ${pdc_key}
- path: /etc/128technology/ssh/pdc_ssh_key.pub
  content: |
    ${pdc_key_pub}
- path: /etc/128technology/ssh/authorized_keys
  content: |
    ${pdc_key_pub}
    ${pdc_peer_key_pub}
- path: /root/installer-preferences.json
  content: |
    {"node-role": "conductor", "node-ip": "${node_ip}", "node-name": "${node_name}", "router-name": "${router_name}", "admin-password": "${admin_password_hash}", "ha-peer-name": "${peer_node_name}", "ha-peer-ip": "${peer_ip}"}

runcmd:
#- mv /etc/sudoers.d/90-cloud-init-users /etc
- initialize128t -p /root/installer-preferences.json
- systemctl enable 128T
- reboot
