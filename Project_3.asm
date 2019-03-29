# Project 3
# Smart thing to do when inserting...
# start from the top down, and shift values while also sorting 
# TO DO LIST: 1) Work on sorting function, making sure to properly store a value into array 
.data
# array to hold sorted integers in ascending order 
array:					.space 200 
# prompt for number of signed integers to input
numberOfInput:				.asciiz "Enter the number of signed integers to enter: " 
# prompt for user to enter an integer
integerInput:				.asciiz "Enter a signed number: "
newLine:				.asciiz "\n"
space:					.asciiz " "

.text
.globl main
main:
li $v0, 4					# prompt user to input number of integers to read in 
la $a0, numberOfInput
syscall 

li $v0, 5					# get user input
syscall

move $s0, $v0					# store number of input inside of v0 into s0
						# loop to input integers into array and call insertArr function 
	addi $t0, $s0, 0			# set t0 to s0, counter for loop
	insert_Loop:
	li $v0, 4				
	la $a0, integerInput			# prompt user to enter an integer
	syscall
	
	li $v0, 5				# get user input
	syscall
	
	move $a0, $s0				# move contents from s0 (number of input) into a0 
	la   $a1, array				# load address of array into a1
	move $a2, $v0				# move userinput in v0 into a2
						# a0, a1, a2 are the arguments being passed into the function call
						# for insertArr
	
	jal insertArr				# call function insertArr
	
	li $v0, 4				# print a new line after calling insertArr
	la $a0, newLine
	 
	addi $t0, $t0, -1			# increment t0 by -1
	beq $t0, $zero, exit_insert_Loop	# if (t0 = 0) exit loop
	j insert_Loop
	exit_insert_Loop:
	
	
	addi $t0, $zero, 0			# printing loop for array
	addi $a1, $zero, 0			# reset position of array
	print_loop:
	beq $t0, $s0, exit_print		# if (t0 = s0) break from loop
	lw $t1, array($a1)
	
	li $v0, 1				# print integer value
	move $a0, $t1
	syscall 
	
	li $v0, 4				# print space in between integers
	la $a0, space
	syscall
	
	addi $t0, $t0, 1			# increment t0
	addi $a1, $a1, 4			# increment a1
	j print_loop
	exit_print:

exit:
li $v0, 10
syscall


.data
loadInput:				.word 4		
.text
# This function should insert an integer entered from user input (signed integer ie positive)
# and sort it into an array in ascending order 
# a0 = number of elements to be inserted 
# a1 = address of array 
# a2 = user input being inserted 
insertArr:
addi $a1, $zero, 0				# start at beginning of the array 
move $s1, $a0					# move number if inputs into s1 

	find_pos:
	lw $t1, array($a1)			# load current array value 
	slt $t2, $a2, $t1			# if a2 < t1   t2 == 1
	
	beq $t1, $zero, zero			# no 0s in array, if the array is empty, then insert the value
	beq $t2, 1, exit_find_pos		# break if position in array is found otherwise, iterate through array
	
	
	addi $a1, $a1, 4			# update a1 and s1
	addi $s1, $s1, -1
	j find_pos
	exit_find_pos:

	# save user input
	sw $a2, array($a1)
	# shifts all other values down 
	shift:
	addi $a1, $a1, 4
	addi $s1, $s1, -1
	
	lw $t2, array($a1)			# load next value to be shifted
	
	sw $t1, array($a1)			# save previous value
	
	move $t1, $t2				# move previous into next value variable
	
	beq $s1, $zero, exit_shift
	j shift
	exit_shift:
	jr $ra
	
	# inserts user input into start of array if there are no other elements
	zero:
	sw $a2, array($a1)
	jr $ra




