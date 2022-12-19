#!/bin/sh
# use: bash /config/qBittorrent/scripts/qb_complete.sh "%N" "%F" "%Z" "%D"
# %N：Torrent 名称
# %L：分类
# %G：标签（以逗号分隔）
# %F：内容路径（与多文件 torrent 的根目录相同）
# %R：根目录（第一个 torrent 的子目录路径）
# %D：保存路径
# %C：文件数
# %Z：Torrent 大小（字节）
# %T：当前 tracker
# %I: 信息哈希值 v1
# %J：信息哈希值 v2
# %K: Torrent ID

torrent_name=$1
save_dir=$2
torrent_size=$3
root_dir=$4

log_dir="/config/qBittorrent/logs" #日志保存路径
target_dir="/media/pt_complete" #目标路径

root_dir_array=(
  "/media_tmp/pt_complete"
)

time=$(date "+%Y-%m-%d %H:%M:%S")
echo "${time} qb_complete.sh"
echo "${time}" >> ${log_dir}/qb_complete.log
echo "种子名称：${torrent_name}" >> ${log_dir}/qb_complete.log
echo "保存路径：${save_dir}" >> ${log_dir}/qb_complete.log
echo "文件大小：${torrent_size} Bytes" >> ${log_dir}/qb_complete.log
echo "根目录：${root_dir}" >> ${log_dir}/qb_complete.log

echo "sleep 1min ..." >> ${log_dir}/qb_complete.log
sleep 1m

if [[ "${root_dir_array[@]}" =~ "${root_dir}" ]]; then
  echo "${root_dir} in root_dir_array" >> ${log_dir}/qb_complete.log
  echo "starting copy ${torrent_name} to ${target_dir} ..." >> ${log_dir}/qb_complete.log
  # rsync -av Ph ${save_dir} ${target_dir} --log-file=${log_dir}/qb_complete_rsync.log
  cp -r ${save_dir} ${target_dir} 2>> ${log_dir}/qb_complete.log
  echo "copy complete" >> ${log_dir}/qb_complete.log
  
  # rednode 通知
  echo "sending notify to nodered ..." >> ${log_dir}/qb_complete.log
  text=$(printf '{"title":"北洋园下载完成","name":"%s","size":"%s Bytes"}' "${torrent_name}" "${torrent_size}" )
  curl -X POST -d "${text}" https://nodered.zhouyuqian.com/qBittorrent\?from\=qBittorrent-qnap\&to\=@all --header "Content-Type: application/json" 2>> ${log_dir}/qb_complete.log
else
  echo "${root_dir} is not in ${root_dir_array}" >> ${log_dir}/qb_complete.log
fi

echo -e "-------------------------------------------------------------\n" >> ${log_dir}/qb_complete.log
