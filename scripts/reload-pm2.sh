#!/bin/bash
cd ~/aws-codedeploy
sudo docker-compose -f /home/ubuntu/aws-codedeploy/docker-compose.yml down
sudo docker-compose -f /home/ubuntu/aws-codedeploy/docker-compose.yml build
sudo docker-compose -f /home/ubuntu/aws-codedeploy/docker-compose.yml up
