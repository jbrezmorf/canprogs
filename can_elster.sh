#!/bin/bash
# Always rebuild.
rm -f elster_py.so
source ./config.sh

defs="-D__LINUX__ -D__ARM__ -D__CONSOLE__ -D__CAN__ -D__PYTHON__"

${CROSS_COMPILE}g++ -std=c++11 -shared -fPIC -Wall ${defs} ${INCLUDE} ${PY_LIB} -lc -lpthread \
  KIpSocket.cpp \
  KThread.cpp \
  KCriticalSection.cpp \
  KCanDriver.cpp \
  KComm.cpp \
  KCanCommDriver.cpp \
  KRPiCanDriver.cpp \
  KCanServer.cpp \
  KStream.cpp \
  NUtils.cpp \
  NCanUtils.cpp \
  KElsterTable.cpp \
  KScanTable.cpp \
  KCanElster.cpp \
  elster_instance.cpp \
  KSniffedFrame.cpp \
  KCanTcpDriver.cpp \
  KTcpClient.cpp \
  elster_py.cpp \
  -o elster.so

