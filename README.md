# -AES-encryption-and-decryption-platform-in-FPGA-communication
implementing a protected communication platform between 2 FPGA's. Data is entered through a keyboard-FPGA interface then the data is encrypted and sent to the second FPGA where the decryption occurs and the data is displayed using an FPGA-LCD interface using VHDL scripts
#Project Description :
The project main task is to transfer sensitive encrypted  data between 2 FPGAs  using 128 bit AES encryption . To begin with ,  the typed   data is entered by a PS2 keyboard then it is encrypted using AES logic on the first FPGA .The encrypted data is displayed on the LCD interface as undefined symbols, then it is transferred  to the other FPGA interface through a UART serial  port where it gets decrypted by the targeted FPGA . The targeted interface must use  the same decryption key in order to decrypt and read the data . however , a switch in the 2nd FPGA can be  toggled between the 2 states ( the decrypted clear data state or the encrypted undefined data state )  . Finally , the Final output data is displayed  on the LCD of the second FPGA  . 








