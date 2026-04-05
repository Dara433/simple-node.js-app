#!/bin/bash

# Ensure ec2-user owns the deployment directory
sudo chown -R ec2-user:ec2-user /home/ec2-user/simple-node-app
sudo chmod -R 755 /home/ec2-user/simple-node-app

cd /home/ec2-user/simple-node-app/src
npm install