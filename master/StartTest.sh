
#!/bin/bash

sudo ./JetsonMate/main.sh

echo "Please press <Enter> to continent."
read

python /JetsonMate/dual_camera.py

while [ 1 ]
do
      sleep 1
done
