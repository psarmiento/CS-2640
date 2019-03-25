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
addi $sp, $sp, -4				# allocate some space for s0 on the stack 
sw $s0, 0($sp)					# save s0 on stack 
move $t1, $a2					# move user input (a2) into t1
addi $a1, $zero, 0				# start at the beginning of the loop
mul $a1, $a0, 4					# a1 = s0 * 4
addi $a1, $a1, -4				# properly align a1 
move $s1, $a1					# temporarily store a1 into s1 for case where
						# inserted element goes at end of array 
	# this loop will find the proper place for user's input to be inserted into 
	# all elements will first be shifted and then compared to see if the value 
	# is in the proper place 
	insert:
	#beq $t2, 0, exit_insert		# if t2 = 0, break from loop 
	lw $t3, array($a1)			# load value in array into t3
	slt $t2, $t3, $t1			# if (t3 < t1) then insert t1 into array and exit loop 
	beq $t2, 1, pos_found			# branch if t2 == 1
	addi $a1, $a1, 4			# shift a1 into the next position, and store the array value
	sw $t3, 0($a1)
	addi $a1, $a1, -4			# move a1 back to original position 
	sw $a2, 0($t1)				# temporarily store user input into array 
	addi $a1, $a1, -4			# increment a1 by -4
	j insert
	exit_insert:
	
	pos_found:
	beq $a1, $s1, last_Pos			# if the element is being inserted into the last position in array
						# then break, else jump back to main
	addi $sp, $sp, 4			# unload off stack
	jr $ra
	
	last_Pos:
	#addi $a1, $a1, 4
	move $t4, $a1
	sw $a2, 0($t4)				# store t1 (user input) into last element of array
	addi $sp, $sp, 4
	jr $ra
