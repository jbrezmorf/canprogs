# Compilation

## Dependencies
The compilation needs a usual build tools and some libraries. 
Debian based systems can use apt-get for installation as follows:

  ```
  sudo apt-get update
  sudo apt-get install build-essential mysql-client libmysqlclient-dev
  ```

  
After that, recompile the program. Switch to the `can_progs` directory and run the script with ".arm":

  ```
  cd can_progs
  ./can_logger.arm
  ```
  
(In Linux, "./" is necessary. It means "this directory"; simply typing "can_logger.arm" is not enough!)

To regenerate all programs, use:

  ```
  ./make_all.arm
   ```

   
## Other notes

The program CS_Bruecke.exe requires two libraries, "vcl60.bpl" and "rtl60.bpl", on startup. 
However, there is a full version of CS_Bruecke.exe available in the "win/release" directory. 
In the "mingw" directory, you will find the cs_bruecke_dos.exe program. This can be used to analyze simulated data 
(of type "scan_data.inc") with ComfortSoft. This helps in precisely determining the Elster index and its associated CAN-ID.

CAN Id (from robots, haustechnikdialog):

    000 - direct
    180 - boiler
    280 - atez
    300, 301 ... - control modules (for me: 301, 302, and 303)
    400 - room remote sensor
    480 - manager
    500 - heating module
    580 - bus coupler
    600, 601 ... - mixer modules (for me: 601, 602, 603)
    680 - PC (ComfortSoft)
    700 - external device
    780 - DCF module

ModuleType based on the ComfortSoft protocol, 2nd byte (refer to robots, haustechnikdialog):

    0 - write
    1 - read
    2 - response
    3 - acknowledgment
    4 - write acknowledgment
    5 - write response
    6 - system
    7 - system response
    20/21 (hex) - write/read large telegram

CAN bus telegrams when turning on the controller (from chriss1980, knx-user-forum):


    0480  7  96 00 FD 09 00 00 00 
    0180  7  36 00 FD 09 00 00 00 
    0601  7  C6 01 FD 09 00 00 00 
    0301  7  66 01 FD 08 00 00 00 
    0680  7  D6 00 FD 08 00 00 00 
    0602  7  C6 02 FD 09 00 00 00 
    0302  7  66 02 FD 08 00 00 00

    Afterwards, every 7 minutes:

    bash
    0602  7  66 02 FE 01 00 00 00 
    0180  7  66 79 FE 01 00 00 00 
    0480  7  A6 79 FE 01 00 00 00

    CAN bus: 20kBit/s, 11-bit IDs

    ComfortSoft telegrams when turning on (from st0ne, knx-user-forum):

    bash
    401 7 86 01 FD 01 00 00 00
    69E 7 D6 1E FD 01 00 00 00  ... from the control unit

Software Versions WPM

(The decimal version on the display corresponds to the hexadecimal number in "Little-Endian" format):

    7077/165.27 (0xa51b): my heat pump
    17665/325.01 (0x0145): WPMiw, xanatos, haustechnikdialog
    17667/325.03 (0x0345): WPMiw, chriss1980, knx-user-forum
    9011/51.35 (0x3323): WPMI (tecalor TTF16), Gelbaerchen, knx-user-forum
    6502/102.25 (0x6619): winki, knx-user-forum
    6526/126.25 (0x7e19): WPMII, berti, knx-user-forum
    1470/190.05 (0xbe05): WPMi, robots, haustechnikdialog
    2204/156.8 (0x9c08): olima, ip-symcon
    5541/165.21 (0xa515): WPMII, hajo23
    not present (0x8000): WPM 3, heckmannju
    not present (0x8000): WPMme, radiator (the version number is found at Elster index 0x0199 and 0x019a)

Remarks

The first request (from ComfortSoft) via the optical interface requires the version mentioned above. It does not run over the CAN bus. The WP manager responds directly. After this query, ComfortSoft provides a selection for "Max. Bus Identifier in the System."

The first query from ComfortSoft on the serial interface is always as follows:

0d 00 0d 01 00 0b 00 00 00 00 00 26 (request for Elster index 0x000b to device 680)

Response:

55 55 55 55 55 55 55 55 a5 1b 03 68 (0xa51b corresponds to my version)

ISG Prerequisites (from Stiebel documentation)

    WPMiW at least version 2508 (204.9/0xcc09)
        If a FEK is installed, at least 9506 (37.34/0x2225)
    WPM II at least version 6529 or 8447 (depending on WP)
        If a FEK is installed, at least 9506 (37.34/0x2225)

My WPM II version is 6527.
Unresolved Issues

    Reset for WP: see chriss1980, knx-user-forum link

    Message 3000FA00FBxxxx (with optical interface 0d00090000fb800000000191 and response 555555555555...0352)

    I suspect that older WPMs cannot handle this over the CAN bus but only with the optical interface. Therefore, newer software versions for the manager are needed for the ISG.

    heckmannju has address 100: knx-user-forum link also has address 700 Are addresses 100 and 700 for the FEK? No, the FEK has address 301. It may use address 700 for queries.

July 24, 2015: Software restructuring and preparation for improving can_server
July 9, 2016: Software adjusted for the original optical interface. DTR must be set to false (-12V).
January 25, 2017:

    Project CS_Bruecke.cbproj was adapted to RAD Studio 10.1 Berlin, which can be downloaded for free for personal use.

    The entire software can also be used with a USB2CAN device from 8devices.com on Windows.




