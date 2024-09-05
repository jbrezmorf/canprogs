#!/bin/bash
set -x

rm -f can_logger
source ./config.sh

mysql_flag=""
if [ -f /usr/include/mysql/mysql.h ]
then
  echo "Found MYSQL ... enablad"
  mysql_flag="-D__MYSQL__"
fi


defs="-D__LINUX__ -D__ARM__ -D__CONSOLE__ -D__CAN__ -D__PYTHON__"

${CROSS_COMPILE}g++ -std=c++11 -Wall ${INCLUDE} ${defs} $mysql_flag -lc -lpthread -ldl \
  CanLogger.cpp \
  KIpSocket.cpp \
  KThread.cpp \
  KCriticalSection.cpp \
  KCanDriver.cpp \
  KComm.cpp \
  KRPiCanDriver.cpp \
  KCanServer.cpp \
  KStream.cpp \
  NUtils.cpp \
  NCanUtils.cpp \
  XmlParser.cpp \
  KXmlNodeList.cpp \
  KMySql.cpp \
  KElsterTable.cpp \
  KCanUVR.cpp \
  KTcpClient.cpp \
  KHttpClient.cpp \
  KCanCommDriver.cpp \
  KCanTcpDriver.cpp \
  -o can_logger

