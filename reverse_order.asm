# CONVERT THIS PROGRAM TO PRINT REVERSE 1RST 
# THEN WORK ON TAKING USER INPUT FOR # OF PRINTED INTEGERS CAN BE IN REGULAR ORDER 
# Who:  Paul Sarmiento
# What: reverse_order.asm
# Why:  A template to be used for all CS264 labs
# When: Due March 3, 2019
# How:  This program prints the elements of an array from user input with one element per line 
.data
.align 2
array:		.space	80		# array big enough to hold 20 int values
array_size:	.word	20		# array size
prompt:		.asciiz "Enter an integer: "
space:		.asciiz " "
perLine:	.asciiz "Enter an integer n <= 20 to print per line: "
newLine:	.asciiz "\n"

.text
.globl main

main:
la $t0, array
la $t1, array_size		# holds address in t1 (load address into t1)
lw $t1, 0($t1)			# loading actual value into t1 w/ 0 offset t1 = 10 

sll  $t1, $t1, 2
addu $t1, $t0, $t1
la $t3, prompt			# holds address for prompt
 	
input_loop:
slt $t2, $t0, $t1
beq $t2, $0, exit_input_loop		# branch if equal, compare value in t2 to 0

# prompt for int input 
move $a0, $t3			# moves t3 into a0
li $v0, 4			# prepares system to output t3
syscall				# does the actual output 

# get input
li $v0, 5			
syscall
 	
sw $v0, 0($t0)			# store int 
 	
addiu $t0, $t0, 4		# increment iterator 
 	
j input_loop 			# go to loop
exit_input_loop:
 	
addi $t1, $zero, 76		# offset for array, start at end of array and move towards the front to print backwards 
addi $t2, $zero, 0		# set t2 to zero (incrementor for loop)

output:
beq $t2, 20, output_exit

lw $t4, array($t1)		# load value from array with offset at t1 into t4
li $v0, 1
move $a0, $t4
syscall				# print array value 

# print a space in between numbers 
li $v0, 4
la $a0, space
syscall

addi $t2, $t2, 1		# update value for incrementor by 1
addi $t1, $t1, -4		# subtract 4 from t1 (start at end) 

j output			# jump back to output
output_exit:

# print a new line 
li $v0, 4
la $a0, newLine
syscall

# get user input for how many to print per line 
li $v0, 4 
la $a0, perLine
syscall 

li $v0, 5 			# getting user input 
syscall 

move $t1, $v0			# store value from v0 into t1 this number represents how many integers per line 
				# should be printed 

addi $t0, $zero, 20 		# array size 
addi $t2, $zero, 0		# t2 is offset for array 
addi $t3, $zero, 0		# t3 keeps track of how many numbers have been printed 

# loop to print numbers per line 	
n_per_line:

# print int value in array 
lw $t4, array($t2)
li $v0, 1
move $a0, $t4
syscall 

# print space, no new line yet 
li $v0, 4
la $a0, space
syscall

addi $t2, $t2, 4		# update offset value 
addi $t3, $t3, 1		# update how many times printed number 

beq $t3, $t1, print_New_Line	# keep printing until t3 and t1 are equal 
j n_per_line

print_New_Line:
li $v0, 4			# print new line 
la $a0, newLine
syscall

sub $t4, $t0, $t3		# if t4 is less than t1, go to new loop to print rest of numbers 
slt $t5, $t4, $t1
beq $t5, 1, n_per_line_exit

n_per_line_exit:

exit:
li $v0, 10 
syscall 
