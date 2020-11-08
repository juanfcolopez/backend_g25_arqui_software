#!/bin/bash
cd ~/aws-codedeploy
sudo docker-compose down
sudo docker-compose build
sudo docker-compose up 
touch hicecompose
