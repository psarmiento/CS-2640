# Project 3
# Smart thing to do when inserting...
# start from the top down, and shift values while also sorting 
# TO DO LIST: 1) Work on sorting function, making sure to properly store a value into array 
.data
# array to hold sorted integers in ascending order 
array:					.space 160 
# prompt for number of signed integers to input
numberOfInput:				.asciiz "Enter the number of signed integers to enter: " 
# prompt for user to enter an integer
integerInput:				.asciiz "Enter a signed number: "
newLine:				.asciiz "\n"

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

exit:
li $v0, 10
syscall


.data
loadInput:				.word 0		
.text
# This function should insert an integer entered from user input (signed integer ie positive)
# and sort it into an array in ascending order 
# a0 = number of elements to be inserted 
# a1 = address of array 
# a2 = user input being inserted 
insertArr:
addi $sp, $sp, -4				# allocate some space for s0 on the stack 
sw $s0, 0($sp)					# save s0 on stack 
move $t1, $a2					# move user input (a2) into t1
move $t2, $s0					# set t2 = s0 (counter for looping through array)
addi $a1, $zero, 0				# start at the beginning of the loop
	
	# this loop will find the proper place for user's input to be inserted into 
	# when the position is found, branch to shift
	insert:
	beq $t2, $zero, exit_insert		# if t2 = 0, break from loop 
	lw $t3, array($a1)			# load value in array into t3
	slt $t4, $a2, $t3			# if value is 1, then a2 will replace t3 and everything else in the array should be
						# shifted to the left by 1
	beq $t4, 1, exit_insert			# if t4 = 1, shift to sorting portion
	
	addi $a1, $a1, 4			# increment a1 by 4
	addi $t2, $t2, -1			# increment t2 by -1
	j insert
	exit_insert:
	
	addi $a1, $a1, 4			# increment a1 by 4 in order to get next element 
	# inserts user input into array position and moves all over values left by 1
	shift:
	
	
	addi $t2, $t2, -1			# increment t2
	beq $t2, $zero, exit_shift
	j shift
	exit_shift:

addi $sp, $sp, 4
jr $ra
