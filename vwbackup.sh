#!/bin/bash

#####------V1.0----vaultwarden数据备份脚本----#####
##------适用于sql数据库类型版本及通过docker-compose安装
##-----此脚本为数据完整备份
##------需要提前安装sqlite3以及7z命令
#sqlite3数据库恢复命令示例：
#sqlite3 /root/vautlwarden/vw-data/db.sqlite3 ".restore'/root/db-202207231324.sqlite3'"

# vaultwarden文件夹目录位置，即docker-compose部署的vaultwarden位置
vw_dir="/dockerprojects/vaultwarden"
#sql数据文件夹位置，一般来讲是vw_dir的子目录
sql_dir="/dockerprojects/vaultwarden/vw-data"
#vaultwarden数据文件夹名字
sql_dirname="vw-data"
#需要备份到的位置
backup_dir="/tmp/backup/vaultwarden"
#压缩密码设置
zip_pwd=123456


#创建备份目录，防止不存在报错
mkdir -p $backup_dir && \
#复制vaultwarden数据到备份目录
cp -a $vw_dir/* $backup_dir && \
#删除掉不需要备份的文件
rm -rf $backup_dir/$sql_dirname/db.sqlite3* && \
#使用sqlite3标准备份命令备份sqlite数据
sqlite3 $sql_dir/db.sqlite3 ".backup '$backup_dir/$sql_dirname/db-$(date '+%Y%m%d%H%M').sqlite3'" && \
#压缩备份的文件，并且压缩后删除备份文件夹中的源文件
7z a -tzip -r -p$zip_pwd $backup_dir/backup$(date '+%Y%m%d%H%M').zip $backup_dir/ -sdel -x\!*.zip && \
#删除30天前的备份文件
find $backup_dir -mtime +30 -type f -name "*.zip" -exec rm -rf {} \;
