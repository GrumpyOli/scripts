#!/bin/bash

sudo apt update
sudo apt install mariadb-server
sudo systemctl status mariadb
sudo systemctl enable mariadb
sudo mysql_secure_installation
sudo systemctl restart mariadb