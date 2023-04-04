# vaultwarden_backup
vaultwarden backup shell file
vaultwarden备份脚本，结合cron定时任务可以实现自动备份，如果使用rclone，还可以把加密的备份文件远程同步到云盘。例如：
```
rclone sync -v /tmp/backup/ onedrive:backupfile/ 
```
