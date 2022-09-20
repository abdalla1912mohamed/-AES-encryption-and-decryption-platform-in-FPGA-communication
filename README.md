# -AES-encryption-and-decryption-platform-in-FPGA-communication
implementing a protected communication platform between 2 FPGA's. Data is entered through a keyboard-FPGA interface then the data is encrypted and sent to the second FPGA where the decryption occurs and the data is displayed using an FPGA-LCD interface using VHDL scripts
Project Description :
The project main task is to transfer sensitive encrypted  data between 2 FPGAs  using 128 bit AES encryption . To begin with ,  the typed   data is entered by a PS2 keyboard then it is encrypted using AES logic on the first FPGA .The encrypted data is displayed on the LCD interface as undefined symbols, then it is transferred  to the other FPGA interface through a UART serial  port where it gets decrypted by the targeted FPGA . The targeted interface must use  the same decryption key in order to decrypt and read the data . however , a switch in the 2nd FPGA can be  toggled between the 2 states ( the decrypted clear data state or the encrypted undefined data state )  . Finally , the Final output data is displayed  on the LCD of the second FPGA  . 
VHDL implementation of the Advanced

Encryption Standard-Rijndael Algorithm
The AES is a Federal InformationProcessing Standard, (FIPS), which is a cryptographic algorithm that is used to protect electronic data. The AES algorithm is a symmetric block cipher that can encrypt, (encipher), and decrypt, (decipher), information. Encryption converts data to an unintelligible form called cipher-text. Decryption of the cipher-text converts the data back into its original form, which is called plaintext. The AES algorithm is capable of using cryptographic keys of 128, 192, and 256 bits to encrypt and decrypt data blocks . However, we have assigned our Algorithm to use 128 data blocks only  , therefore the input and output for the AES algorithm consists of sequences of 128 bits .These sequences are referred to as blocks and the numbers of bits they contain are referred to as their length. The Cipher Key for the AES algorithm is also  a sequence of 128  , and the first key is chosen by both interface sides . so that the key in unique and random and only the interface with the same key can decrypt and access the data . 
states  :
Internally, the AES algorithm’s operations are performed on a two-dimensional array of bytes called the State. The State consists of four rows of bytes. Each row of a state contains Nb numbers of bytes, where Nb is the block length divided by 32. In the State array, which is denoted by the symbol S, each individual byte has two indices. The r ≤ 3 and the second bytefirst byte index is the row number r, which lies in the range 0 ≤  5 c ≤ Nb−1. Such indexing allowsindex is the column number c, which lies in the range 0 ≤  an individual byte of the State to be referred to as Sr,c or S[r,c]. For the AES Nb = 4, which c ≤ 3. At the beginning of the Encryption and Decryption the input, whichmeans that 0 ≤ is the array of bytes symbolized by in0in1···in15 is copied into the State array. This activity is illustrated in Figure 3. The Encryption or Decryption operations are conducted on the State array. After manipulation of the state array has completed its final value is copied to the output, which is an array of bytes symbolized by out0out1···out15.
Key Expansion :   At first the chosen key is expanded using an expansion technique in order to generate 10 more keys , so that we have an overall of 11 keys and 10 encryption  rounds . a function called key_generation was introduced in the package in order to calculate all 10 keys and to output the correct round key when it is provided by  the round number and the main key  . the key of the first round is generated by the following vhdl procedure . 
Rounds overview :
	the chosen key is expanded to 10 more keys 
	a sequence of 128 bit ( 16 -byte- block ) is entered by the keyboard interface 
	data is XORed with the main key 
	Substitution_bytes algorithm is executed
	 shift_rows algorithm is executed 
	mix_coloumn algorithm is executed  
	the whole processes from XOR  till mix_coloumn are executed 8 more times
	the final output of the previous rounds is XORed with the 10th  key 
	Substitution_bytes algorithm is executed one last time
	 shift_rows algorithm is executed  one last time
	finally the data is XORed with the last key   

add _round _key :  the state arrays of both data and the chosen key are XORed where each data cell is XORed with its corresponding key cell .Therfore the add_round_key function is introduced in the package used by the encryption team and the function is eventually called in the add_round_key component . the round_key_component takes in two inputs , the key of type state as well as the data and it returns the XORed data in a state form or as a 128 bit block . 
substitution bytes : The bytes substitution transformation Bytesub (state) is a non-linear substitution of bytes that operates independently on each byte of the State using a substitution table(Sbox).so each byte has a corresponding byte in the Sbox and in order to reach the location of the sub_byte in the 16*16 sbox table , we should translate the first 4 bits of the data byte into the row number (x) and the 4 least significant bytes to the column number (y), Therefore our sub_byte is sbox(x,y)  and in order to complete the execution all the 16 bytes must be substituted so the function is recalled once for each byte . so a component called the substitution bytes is constructed to call that function 16 times in order to output the substituted state . 
 


shift rows : in shift _rows a circular right shift operation is executed for each row , where row number 0 is unaltered but row number 1 is circularly shifted once to the right , while row 2 is shifted twice and the last row is shifted 3 times to the right . Therefore a function called shift_rows is introduced in the package and a component called shift_rows is used to call the function and to output the  shifted state array  . 
mix columns : This transformation is based on Galois Field multiplication. Each byte of a column is replaced with another value that is a function of all four bytes in the given column. The MixColumns( ) transformation operates on the State column-by-column so that the entire state matrix is divided into 4 words (each word is represented by a column ) , then each word is multiplied by the mix matrix  , however the multiplication output can be extracted from already predefined multiplication tables such as mul3 and mul2 , so that a function can be called to get the corresponding value of each byte multiplication using the same logic behind the Sbox substitution or multiplication by 2 or 3 can be done on a 8bit level using the shift propeties of binary data , where multiplcation by 2 stands for shifting the data to the left and so on . 



Encryption Results  : 
data and key input examples from our references : 
 



Expected output : 



Our test bench : 
 







LCD Interface 
The LCD code was provided by eee.guc.edu.eg but it had to be edited on order to work properly as the code provided had only one simple functionality which is to print FPGA word where the next state FSM was known previously so that the next state was already known as the first state after the set address state was F followed by  P then G then A  . But in order to show the 16byte block we must have 16 states of all possible charachter , so a new signal array  of states was introduced so that each keyboard ps2code charachter is mapped to the corresponding display state so that we can access the display states of our data directly so we had to edit the code in 3 places . 
old display states :
 
edited display states :  
Also Regarding the process of converting the ps2 code into ascii , many more charachters had to be added , as Tx byte has a range of ascii values from a to z and 0 to 9 .     
                                                                                  edited TX Byte cases :
              
old TX Byte  cases :                      


Finally the FSMs description part has to be edited as the code provided by eee.guc.edu.eg  deals with predefined 4 states , but in order to show the data coming from the keyboard we must have all possible FSMs and we must access the state array in ascending order , so a counter was introduced in the FSMs in order to span the state array so that the whole 16 corresponding states are defined . 
old FSMs code : 






edited FSMs code :















SERIAL UART PORT INTERFACE 
The code for the serial port is previously defined in some external resources so that the Encrypted data can be transferred to the second FPGA in a seqeunce of 8 bits , so the code was edited in order to send the whole block on some clk intervals so that the second FPGA can receive a block 128 bits . 
Decryption 
This process is direct inverse of the Encryption process . All the transformations applied in Encryption process are inversely applied to this process. Hence the last round values of both the data and key are first round inputs for the Decryption process and follows in decreasing order. 
Decryption overview :
	starts with XORing the Encrypted data with the 11th key 
	inverse shift rows function is executed 
	inverse sbox_substitution is executed 
	XORing tha data with the 10th key 
	applying inverse mix_coloumns function 
	inverse shift rows function is executed 
	inverse sbox_substitution is executed 
	then repeating the last 4 instructions for 8 more times 
	finally XORing the final data with main key






Inverse S_box : The same lookup function(used in encryption )
 can be used to get substitution bytes of the data 

 
inverse shift rows : inverse Shift Rows Transformation is the inverse of the shift_row function used in encryption . where row number zero is not altered, but row number 1 is shifted circularly to the left while row 2 is shifted twice to the left and row number 3 is shifter 3 times to the left .
XORing the key : the process is the same for encryption and decryption . 

inverse mix columns :  Inverse Mixing of Columns) is the inverse of the MixColumns function used in encryption  where each coloumn of data (word) is multiplied by the inverse matrix . both 2 approaches used in the mixcolumns function  in encryption can be used . 
 

Decryption test bench :





Expected output : 32  






