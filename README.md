# JetsonMate 功能程序

开机完成后，各个Worker模块独立测试，Worker测试完成后将测试日志上传到Master模块。

## 文件夹作用：
- Arduino：JetsonMate LDO、风扇选择的控制（软硬件可删减部分，但还想不到什么好法子，并且没时间，，哎，再而估计没人看，哈哈哈）
- master_20210927/worker20211009：老的测试程序，没有多大作用，因为新改好的程序是由此而来，所以留着自己看看。
- master_20211013：该文件是Master模块的测试程序；注意将master_host复制到Worker模块.ssh文件中。
- woker_20211013：文件夹下的文件是Worker模块的测试程序。（开机自动启动项）

## 安装支持：
- shell：iperf、scp
- python：cv2、numpy
>备注：或许遗漏很多相关支持，运行过程才能发现。

## 隐藏配置事项：
- 固定 IP 配置（静态 IP），为保证通讯正常，需确保与路由处于同一网域。（可更改路由）
- sshpass scp 文件传输时，为了避免公钥出问题，已将文件 ssh_config 内容配置为：StrictHostKeyChecking no.（这是比较麻烦的事项，，一旦没有正确配置，Worker的测试日志将无法上传到Master模块，master文件中的master_host只是一个参考，新master模块将不再是这个密钥）
- Master 与 Worker 之间的网速测试由 iperf3 完成。（iperf3在Master 端作为开机自动启动项）
- Worker 测试为开机自动测试，测试结果保存到 U 盘和自动上传到 Master。