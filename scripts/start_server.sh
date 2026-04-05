#!/bin/bash
cd /var/www/simple-node-app
nohup node app.js > server.log 2>&1 &