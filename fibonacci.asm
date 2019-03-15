# Who:  Paul Sarmiento
# What: fibonacci.asm
# Why:  A template to be used for all CS 2640 labs
# When: Due March 17, 2019
# How:  This program takes an input from the user and performs the fibonacci sequence 
#	depending on the users input.  Proper bounds checking is also included.
.data
array:					.space 100
userInput:				.asciiz "Enter an integer for fib " 
newLine:				.asciiz "\n"
space:					.asciiz " "
inputNeg:				.asciiz "The value that was entered was less than 0, must be a positive integer"
inputTooBig:				.asciiz "The value that was entered cannot be respresented in 32 unsigned bits"
fibVal:					.asciiz "The value of the fib number is "
arrVal:					.asciiz "\nThe values inside of the array are the following\n"
.align 2

.text
.globl main
main:					# main program entry
#Prompt user for fib number
li $v0, 4
la $a0, userInput
syscall

li $v0, 5				# get user input for fib
syscall

# range for 32 bit unsigned integer (2^32 - 1) 4,294,967,296
# max input that can be accepted: 47
# 47 fib = 2,971,215,073 
# check for valid input 
slt $t2, $v0, $zero			# if (v0 < 0) then go print an error message in inputNegative
bne $t2, $zero, inputNegative

addi $t3, $zero, 47			# t3 represents max input accepted
slt  $t2, $t3, $v0			# if (t3 < v0) then the input is larger than 47, print error message 
bne  $t2, $zero, inputTooLarge

move $s0, $v0				# store user input into s0, so that t0 can be altered but not forget user input
move $t0, $v0				# store value into t0, this is n
la $t1, array				# load address of array into t1

addi $t2, $zero, 0			# t2 will initially be 0 (a from the algorithm)
addi $t3, $zero, 1			# t3 will initially be 0 (b from the algorithm)

	# loop to calculate fib and store it into the array
	fib:
	beq $t0, 0, exit_fib		# if t0 = 0, then exit loop 
	sw $t2, 0($t1)			# store in value from a, (array[i] = a)
	move $t4, $t3			# put value of b into a temp variable (temp = b)
	add $t3, $t3, $t2		# add a with b and store that value (b += a)
	move $t2, $t4			# store value in temp into t2 (a = temp)
	addi $t1, $t1, 4		# update value for t1 (array) by 4
	addi $t0, $t0, -1		# decrement value of t0 (n) by -1
	j fib
	exit_fib:


# print value of nth element first 
li $v0, 4
la $a0, fibVal
syscall 

addi $t0, $zero, 4			# multiply the value stored in s0, by 4 to get the last position in array	
mult $s0, $t0
mflo $s1				# store value into s1 
addi $s1, $s1, -4			# aligns s1 to proper place in array for nth element in array
lw $t0, array($s1)
li $v0, 1
move $a0, $t0				
syscall

	li $v0, 4			# print output telling user the following integers are the fib sequence
	la $a0, arrVal
	syscall
	# print loop for array elements
	li $v0, 4
	la $a0, newLine			# print new line 
	syscall
	addi $t1, $zero, 0		# reset array to beginning
	addi $t0, $s0, 0		# reset t0 back to what n is (stored in s0)
	print_loop:
	beq $t0, 0, exit_loop
	
	lw $t2, array($t1)
	li $v0, 1			# print int value in array by offset (t1)
	move $a0, $t2
	syscall
	
	li $v0, 4			# print a space
	la $a0, space
	syscall
	
	addi $t1, $t1, 4		# update offset (t1)
	addi $t0, $t0, -1		# update n (t0)
	
	j print_loop
	exit_loop:
	j exit				# after this loop the program should jump to exit because it done
					# prompts below are printing messages for error input
	
inputNegative:				# prints an error message telling the user the number input was less than 0
li $v0, 4
la $a0, inputNeg
syscall 
j exit

inputTooLarge:				# prints an error message telling user input was too large 
li $v0, 4
la $a0, inputTooBig
syscall 
j exit

exit:					# exit program
li $v0, 10
syscall
