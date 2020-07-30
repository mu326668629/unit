# date: 2020-07-30
# desc: 安装执行脚本化 目前已经实现了最简化的 wsgi
# 从编译到启动一次性执行完
#

WORK_ROOT=/opt/

start()
{
	sbin/unitd  --control 0.0.0.0:8443
}

stop()
{
	local pidfile=unit.pid
	local pid=$(test -f $pidfile && cat $pidfile)
	if [ "$pid" = "" ];then
		echo "empty pid"
	else
		kill -3 $pid
	        echo "stop $pid success"
	fi
}

update()
{
	curl -X PUT -d @unit.json 127.0.0.1:8443/config
	echo "update success"
}

copyfile()
{
	if [ ! -f $WORK_ROOT/test/cpp/unit.json ] || \
	   [ ! -f $WORK_ROOT/test/cpp/index.py ] ;then
	  echo "error invalid root=$WORK_ROOT"
	  exit 1
	fi
	cp $WORK_ROOT/test/cpp/unit.json ./
	cp $WORK_ROOT/test/cpp/index.py applications/blog/
	echo "copy success"
}

install()
{
	local workpath=${PWD%unit*}/unit
	if [ ! -f $workpath/test/cpp/start.sh ];then
	  echo "invalid path"
	  exit 1
	fi 

	local python_opt=''
	local prefix_opt='/opt/unit'
	if  python3 --version >/dev/null;then
	  python_opt='--config=/usr/bin/python3.6-config'
	fi

    echo "* configure application"
	cd $workpath  || { echo "enter $workpath fail"; exit 1;}
	rm -rf build && \
	./configure --prefix=$prefix_opt && \
	./configure cpp && 
	./configure python $python_opt && \
	make && \
	make install || { echo "error configure fail"; exit 1;}
    
	echo "* install application" 
	if [ ! -d $prefix_opt ] || \
	   [ ! -f $prefix_opt/sbin/unitd ];then
	   echo "error install fail"
	   exit 1
	fi
	if [ ! -f test/cpp/start.sh  ] || \
	   [ ! -f test/cpp/unit.json ] || \
	   [ ! -f test/cpp/index.py  ] ;  then
	   echo "error lose file"
	   return
	fi

	mkdir -p $prefix_opt/applications/blog/ && \
	sed "s/^WORK_ROOT=.*/WORK_ROOT=$(echo $workpath|sed 's/\//\\\//g')/" test/cpp/start.sh >$prefix_opt/start.sh && \
	cp test/cpp/unit.json $prefix_opt/ && \
	cp test/cpp/index.py $prefix_opt/applications/blog/

	cd -

    echo "* start application"
	cd $prefix_opt
	sh start.sh start && \
	sh start.sh update &&
	sh start.sh test
	cd -
}

unittest()
{
	curl 127.0.0.1:8300
}

case "$1" in
	start)
		start
		;;
	stop)
		stop
		;;
	update)
		update
		;;
	copy)
		copyfile
		;;
	install)
	    install
		;;
	test)
	   unittest
	   ;;
	*)
		echo "invalid $1"
		;;
esac
