HEXO_PID=$(ps -ef | grep 'hexo' | grep -v grep | awk '{print $2}')
echo "查询到的hexo进程id:$HEXO_PID"

if [ -n "$HEXO_PID" ]; then
  kill -15 $HEXO_PID
fi

hexo clean && hexo g -d 

nohup hexo s > hexo.log 2>&1 &
tail -f hexo.log
