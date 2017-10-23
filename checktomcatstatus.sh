#!/bin/bash


	tomcat_path=/opt/tomcat
	TomcatID=$(ps -ef |grep tomcat |grep -w $tomcat_path|grep -v 'grep'|awk '{print $2}')


	StopTomcat=/opt/tomcat/bin/shutdown.sh


	if [ $TomcatID ]; then
	   echo "当前Tomcat进程ID为：$TomcatID, 需要关闭..."
	   $StopTomcat
	else
	   echo "当前环境没有Tomcat启动"
	fi


	rm -rf /opt/tomcat/webapps/webdemo
	rm -f /opt/tomcat/webapps/webdemo.war
