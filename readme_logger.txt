/*
 *
 *  Copyright (C) 2014 Jürg Müller, CH-5524
 *
 *  This program is free software: you can redistribute it and/or 
 *  modify it under the terms of the GNU Lesser General Public 
 *  License as published by the Free Software Foundation version 3
 *  of the License.
 *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 *  GNU Lesser General Public License for more details.
 *
 *  You should have received a copy of the GNU Lesser General Public
 *  License along with this program. If not, 
 *  see http://www.gnu.org/licenses/ .
 */

The included program can_logger can run on a Raspberry Pi. It can be generated with:

  ./can_logger.arm

When calling:

  ./can_logger

you will see:

can-bus data logger
copyright (c) 2014 Jürg Müller, CH-5524

usage:
  can_logger <can dev> <sample time in sec> [ (<filename> | <mysql host>) [ csv | mysql ] ]
or
  can_logger <file.xml>

example: ./can_logger can0 10 192.168.1.137 mysql
or       ./can_logger can1 3600 canlog csv

can dev: can0
sample time: 10 sec

1. Example (above): MySQL host is 192.168.1.137; the data is read every 10 seconds.

2. Example: The data is stored in the file canlog_DATUM; the data is read every hour; a new file is created for each day.

csv (comma separated values): The values are separated by commas. (Used, for example, by Excel.) 

mysql: can_logger writes in the MySQL table "can_log" (see create.sql). 

_______________________________________________________________

# Purpose of the program can_logger:

a) To view the can data flow in a Bash shell. For example, to see the response to a "cansend" command.

b) To store can protocols in a file. Since the Raspberry Pi works with a flash card, saving too frequently should be avoided (flash has only 100k or 200k write cycles), which is why a "sample time" of 10 minutes or more can be selected.

c) To store can protocols in a remote MySQL database. See also the changes/extensions of 8.9.2014.

_______________________________________________________________

# Changes:

- 8. 9. 2014: see below

- 12. 9. 2014: <sample time in sec> is now the second parameter (previously it was the third).

_______________________________________________________________

can_logger works with 2 threads (independent "execution objects"). One thread reads the Can-Bus frames and stores them in a ring buffer (with 10240 frames). The other, the "main thread", empties the ring buffer. The time between the emptying can be predefined (<sample time in sec>). If the ring buffer is 3/4 full, it is emptied immediately without waiting for the sample time. The data can be stored either in a local file or in a MySQL database.

The program is very efficient! 
Tested with the MCP2515 Can-Bus Demo Board from Microchip as sender and the Raspberry Pi as receiver: 
  60 Can-Frames per second at a Can-Bus bitrate of 125000 bit/s, 
  "sample time" of 10 seconds, and 
  a MySQL database on the network (parameter "mysql").

_______________________________________________________________

# Requirements for the generation and use of can_logger:

- Headers: can.h, raw.h, and mysql.h

- Library: libmysqlclient (dynamically loaded)

- Loaded modules (see candump): spi-bcm2708.ko, can.ko, can-dev.ko, can-raw.ko, and mcp251x.ko 

_______________________________________________________________

# Example of the XML file structure (not fully developed):

<?xml version="1.0" encoding="UTF-8" ?>
<can>
  <device     Name="can0" />
  <mysql      User="pi" 
              Password="raspberry" 
              DB="log" 
              Host="192.168.1.115" />
  <sleep      Name="54" /> 
</can>

<?xml version="1.0" encoding="UTF-8" ?>
<can>
  <device     Name="can0" />
  <log_file   Name="logfile" />
  <sleep      Name="54" /> 
</can>

_______________________________________________________________

# Keywords: 
  Raspberry Pi CAN-BUS 
  Stiebel-Eltron Elster-Kromschröder Heat Pump WPL33 WPMII Heat Pump Manager WPM2
  mysql logging

_______________________________________________________________

# Changes from 8.9.2014:

- The MySQL table "log" is now called "can_log" and the structure has also changed (see create.sql). (timestamp instead of the <date_stamp, ms_stamp> pair; the flag is no longer recorded.)

- Logging of all incoming CAN telegrams on a rented homepage with a MySQL database. I couldn't figure out how to directly access the DB using a MySQL client connection, so I decided to write the data to the DB with a server-side PHP script.

  "can_logger" prepares a stream in which all telegrams to be saved are packed in MySQL "INSERTs". The script *put_can_log.php* receives the stream on the HTTP server and stores the "INSERTs" in the database.

_______________________________________________________________

# Procedure to store all telegrams in the MySQL database:

- Provide the correct data in *konfiguration.php*. Set PASS and PASS_VALUE to any access code (do not use HTTP special characters). 

- Copy *konfiguration.php* and *put_can_log.php* to the HTTP server.

- Generate the MySQL table *can_log* on the server (see create.sql).

- Adjust *can_log.xml* (used on the Raspberry Pi).

- To test on the Raspberry Pi:

    $./can_logger can_log.xml trace 

  If everything is fine, remove "trace". After each transmission interval, the last CAN protocol line is output. The line with "result" is generated by the PHP script.

    215  8.9.2014 14:22:25.340  14611234 00 [4] 00 01 02 03              ....
    result: Ok: 216   not Ok: 0

_______________________________________________________________

# Extension from 22. Sept. 2014:

The CAN232 from Lawicel can be used. The call on the Mac, for example, is:

  mac/can_logger tty.usbserial-FTK1S17H 0

Note: the device can be found in the /dev directory (ls /dev/tty*)

For Windows:

  win/can_logger COM3 0

_______________________________________________________________

# Extension from 15. Nov. 2014:

Control-C is intercepted. Afterward, the program terminates properly.
