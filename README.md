# Mydbops_Binlog_Server

Mydbops binlog server helps you to copy the binlogs from production master to standalone remote server with out using any external binlog streaming tool.

The script is build on shell and integrated to systemctl to easy management.

Pre-requites for setting up the Binlog server.

A standalone remote server with required disk.
mysqlclient to be installed on remote server(where the Binlogs will be stored).
mysql user with REPLICATION SLAVE and REPLICATION CLIENT privilege.

How to set up the binlog server , is explained our blog , please go through the link.

