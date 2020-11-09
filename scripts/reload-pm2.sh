#!/bin/bash
cp ~/local_env.yml ~/aws-codedeploy/config
cd ~/aws-codedeploy
sudo docker-compose -f /home/ubuntu/aws-codedeploy/docker-compose.yml down
sudo docker-compose -f /home/ubuntu/aws-codedeploy/docker-compose.yml build
sudo docker-compose -f /home/ubuntu/aws-codedeploy/ run app rails db:migrate
sudo docker-compose -f /home/ubuntu/aws-codedeploy/docker-compose.yml up -d  
pm2 startOrReload ecosystem.config.js
