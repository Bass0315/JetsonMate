
#!/bin/bash

sudo ./main.sh

echo "Start test Camera."

sleep 1

python dual_camera.py

while [ 1 ]
do
      sleep 1
done
