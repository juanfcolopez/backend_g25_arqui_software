#!/bin/bash
cd ~/aws-codedeploy
touch entre
pm2 startOrReload ecosystem.config.js
