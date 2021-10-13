# Jetson Mate Test--2021.10.12

## 测试思路

## 隐藏配置事项
1. 固定 IP 配置（静态 IP），为保证通讯正常，需确保与路由处于同一网域。（可更改路由）
2. sshpass scp 文件传输时，为了避免公钥出问题，已将文件 ssh_config 内容配置为：StrictHostKeyChecking no.
3. Master 与 Worker 之间的网速测试由 iperf3 完成，Master 端作为开机自动启动项。
4. Worker 测试为开机自动测试，测试结果保存到 U 盘和自动上传到 Master。