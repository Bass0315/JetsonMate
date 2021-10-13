#!/bin/bash

cp test /usr/bin/
cp test.service /etc/systemd/system/
systemctl enable test.service
systemctl start test

exit 0
