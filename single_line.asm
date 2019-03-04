# Who:  Paul Sarmiento
# What: single_line.asm
# Why:  A template to be used for all CS264 labs
# When: Due March 3, 2019
# How:  This program prints the elements of an array from user input all in one line 
.data
array:		.space	80
array_size:	.word	20	
prompt:		.asciiz "Enter an integer: "
space:	.asciiz " "

.text
.globl main

main:
la $t0, array
la $t1, array_size			# holds address in t1 (load address into t1)
lw $t1, 0($t1)				# loading actual value into t1 w/ 0 offset t1 = 10 
sll  $t1, $t1, 2
addu $t1, $t0, $t1
la $t3, prompt				# holds address for prompt
 	
input_loop:
slt $t2, $t0, $t1
beq $t2, $0, exit_input_loop		# branch if equal, compare value in t2 to 0
# prompt for int input 
move $a0, $t3				# moves t3 into a0
li $v0, 4				# prepares system to output t3
syscall					
# get input
li $v0, 5				# prepares system to get input 
syscall
 	
sw $v0, 0($t0)				# store int 
 	
addiu $t0, $t0, 4			# increment iterator 
 	
j input_loop 			
exit_input_loop:
 	
# input loop portion 
addi $t1, $zero, 0
addi $t2, $zero, 0			# set t2 to zero (incrementor for loop)

output:
beq $t2, 20, output_exit

lw $t4, array($t1)			# load value from array with offset at t1 into t4
li $v0, 1
move $a0, $t4
syscall					# print array value 


# print new line 
li $v0, 4
la $a0, space
syscall

addi $t2, $t2, 1			# update value for incrementor by 1
addi $t1, $t1, 4			# update value for offset by 4

j output 
output_exit:

exit:
li $v0, 10 
syscall 
