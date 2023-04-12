jal main
#                                           CS 240, Lab #3
# 
#                                          IMPORTATNT NOTES:
# 
#                       Write your assembly code only in the marked blocks.
# 
#                     	DO NOT change anything outside the marked blocks.
# 
#               Remember to fill in your name, student ID in the designated sections.
# 
#
j main
###############################################################
#                           Data Section
.data

# 
# Fill in your name, student ID in the designated sections.
# 
student_name: .asciiz "Chloe Kershner"
student_id: .asciiz "826281307"

new_line: .asciiz "\n"
space: .asciiz " "
testing_label: .asciiz "Testing "
unsigned_addition_label: .asciiz "Unsigned Addition (Hexadecimal Values)\nExpected Output:\n0154B8FB06E97360 BAC4BABA1BBBFDB9 00AA8FAD921FE305 \nObtained Output:\n"
fibonacci_label: .asciiz "Fibonacci\nExpected Output:\n0 1 5 55 6765 3524578 \nObtained Output:\n"
file_label: .asciiz "File Read\nObtained Output:\n"

addition_test_data_A:	.word 0xeee94560, 0x0154a8d0, 0x09876543, 0x000ABABA, 0xFEABBAEF, 0x00a9b8c7
addition_test_data_B:	.word 0x18002e00, 0x0000102a, 0x12349876, 0xBABA0000, 0x93742816, 0x0000d6e5

fibonacci_test_data:	.word 0, 1, 5, 10, 20, 33

hex_digits: .byte '0','1','2','3','4','5','6','7','8','9','A','B','C','D','E','F'

file_name:
	.asciiz	"lab3_data.dat"	# File name
	.word	0
read_buffer:
	.space	300			# Place to store character
###############################################################
#                           Text Section
.text
# Utility function to print hexadecimal numbers
print_hex:
move $t0, $a0
li $t1, 8 # digits
lui $t2, 0xf000 # mask
mask_and_print:
# print last hex digit
and $t4, $t0, $t2 
srl $t4, $t4, 28
la    $t3, hex_digits  
add   $t3, $t3, $t4 
lb    $a0, 0($t3)            
li    $v0, 11                
syscall 
# shift 4 times
sll $t0, $t0, 4
addi $t1, $t1, -1
bgtz $t1, mask_and_print
exit:
jr $ra
###############################################################
###############################################################
###############################################################
#                           PART 1 (Unsigned Addition)
# You are given two 64-bit numbers A,B located in 4 registers
# $t0 and $t1 for lower and upper 32-bits of A and $t2 and $t3
# for lower and upper 32-bits of B, You need to store the result
# of the unsigned addition in $t4 and $t5 for lower and upper 32-bits.
#
.globl Unsigned_Add_64bit
Unsigned_Add_64bit:
move $t0, $a0
move $t1, $a1
move $t2, $a2
move $t3, $a3
############################## Part 1: your code begins here ###

add $t4,$t0,$t2 #add last two registers of both numbers into $t4
bge $t4,$t2,jump #check if $t4 is less than $t2, don't need to add a carry over 1 if it is greater
addi $t1,$t1,1 #carry over a 1 into $t1
jump:
add $t5,$t1,$t3 #add the first two registers of both numbers




############################## Part 1: your code ends here   ###
move $v0, $t4
move $v1, $t5
jr $ra
###############################################################
###############################################################
###############################################################

###############################################################
###############################################################
###############################################################
#                            PART 2 (Fibonacci)
#
# 	The Fibonacci Sequence is the series of numbers:
#
#		0, 1, 1, 2, 3, 5, 8, 13, 21, 34, ...

#	The next number is found by adding up the two numbers before it.
	
#	The 2 is found by adding the two numbers before it (1+1)
#	The 3 is found by adding the two numbers before it (1+2),
#	And the 5 is (2+3),
#	and so on!
#
# You should compute and return the nth digit of the Fibonacci sequence.
# The digit you need to compute will be in $a0.
# Return your digit in $a1.
# 
.globl fibonacci
fibonacci:
move $a0, $s0
############################## Part 2: your code begins here ###

addi $t0,$zero,0 #first number
addi $t1,$zero,1 #second number
addi $t2,$zero,1 #counter
addi $a1,$zero,0 #return value
beq $a0,$zero,done #if nth term is 0, return 0
addi $a1,$zero,1 #return value 1 to check for nth term = 1
beq $a0,$t1,done #if nth term is 1, return 1
while:
beq $t2,$a0,done #check if counter is = nth term
addi $t2,$t2,1 #increment counter
add $a1,$t0,$t1 #add last two numbers
add $t0,$zero,$t1 #switch first number to second number
add $t1,$zero,$a1 #set second number equal to result
j while
done:




############################## Part 2: your code ends here   ###
move $v0, $a1
jr $ra
###############################################################
###############################################################
###############################################################

###############################################################
###############################################################
###############################################################
#                           PART 3 (ReadFile)
#
# You will read characters (bytes) from a file (lab3_data.dat) and print them. Valid characters are defined to be
# alphanumeric characters (a-z, A-Z, 0-9),
# " " (space),
# "." (period),
# (new line).
#
# We have loaded the file for you and placed its contents in a buffer (300 bytes length)
# $a1 contains the address of the input buffer
# You need to print all valid characters in the buffer, while ignoring all invalid ones.
# Do not print anything else, including extra new lines.
#
# Hint: Remember the ascii table. You will NOT need to create a reference array of valid chars
#
.globl file_read
file_read:


############################### Part 3: your code begins here ##

#reading file
li $v0,13 
la $a0,file_name
li $a1,0
li $a2,0
syscall
move $t0,$v0 #$t0 holds file descriptor
#opening file
li $v0,14
move $a0,$t0
la $a1,read_buffer
li $a2, 300
syscall 
#close file
move $t1,$v0 #$t1 holds number of chars read
li $v0,16
syscall 

addi $t3,$zero,0 #counter
loop:
beq $t3,$t1,endloop #check if counter = number of chars read
lbu $t2,0($a1) #load next char
addi $a1,$a1,1 #increment address from read_buffer
addi $t3,$t3,1 #increment counter
#branch statements according to valid ascii values, determining whether to print or not
blt $t2,10,skipPrint
beq $t2,10,print
blt $t2,32,skipPrint
beq $t2,32,print
blt $t2,46,skipPrint
beq $t2,46,print
blt $t2,48,skipPrint
blt $t2,58,print
blt $t2,65,skipPrint
blt $t2,91,print
blt $t2,97,skipPrint
blt $t2,123,print
bge $t2,123,skipPrint

#printing numbers
print:
li $v0,11
add $a0,$zero,$t2 
syscall
skipPrint:
j loop
endloop:




############################### Part 3: your code ends here   ##
jr $ra
###############################################################
###############################################################
###############################################################

#                          Main Function
main:

li $v0, 4
la $a0, student_name
syscall
la $a0, new_line
syscall  
la $a0, student_id
syscall 
la $a0, new_line
syscall
la $a0, new_line
syscall
##############################################
##############################################
test_64bit_Add_Unsigned:
li $s0, 3
li $s1, 0
la $s2, addition_test_data_A
la $s3, addition_test_data_B
li $v0, 4
la $a0, testing_label
syscall
la $a0, unsigned_addition_label
syscall
##############################################
test_add:
add $s4, $s2, $s1
add $s5, $s3, $s1
# Pass input parameter
lw $a0, 0($s4)
lw $a1, 4($s4)
lw $a2, 0($s5)
lw $a3, 4($s5)
jal Unsigned_Add_64bit

move $s6, $v0
move $a0, $v1
jal print_hex
move $a0, $s6
jal print_hex

li $v0, 4
la $a0, space
syscall

addi $s1, $s1, 8
addi $s0, $s0, -1
bgtz $s0, test_add

li $v0, 4
la $a0, new_line
syscall
##############################################
##############################################
test_fibonacci:
li $v0, 4
la $a0, new_line
syscall
li $v0, 4
la $a0, testing_label
syscall
la $a0, fibonacci_label
syscall 

li $s1, 6 #num test cases
la $s2, fibonacci_test_data
li $s3, 0
test_fib:
beqz $s1, fib_test_done
add $s4, $s2, $s3
lw $s0, 0($s4)

jal fibonacci

move $a0, $v0
li $v0, 1
syscall
li $v0, 4
la $a0, space
syscall

add $s3, $s3, 4
add $s1, $s1, -1
j test_fib

fib_test_done:
li $v0, 4
la $a0, new_line
syscall
##############################################
##############################################
test_file_read:
li $v0, 4
la $a0, new_line
syscall
li $s0, 0
li $v0, 4
la $a0, testing_label
syscall
la $a0, file_label
syscall 
jal file_read
end:
# end program
li $v0, 10
syscall
