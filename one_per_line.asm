.data
array:	.space		24			# array big enough to hold 20 integers (4 bytes each)
prompt:	.asciiz 	"Enter an integer: " 	
newLine: .asciiz	"\n "

.text

main:
la $t0, array 		# first loading address into t0 

#la $t1, prompt		# loading prompt into t1
addi $t1, $zero, 0	# incrementor for loop 
addi $t3, $zero, 0	# offset for storing into array 
loop:
	beq $t1, 20, exit_loop		# increment by 1, if t1 == 20 exit loop
	
	la $a0, prompt			# print prompt for user 
	li $v0, 4
	syscall
	
	li $v0, 5			# getting user input 
	syscall	
	
	sw $v0, 0($t0) 
	
	addi $t3, $t3, 4		# increment offset for array by 4
	addi $t1, $t1, 1
	j loop	# jumps back to top of loop 
exit_loop:
 
lw $t4, array($t3)
move $a0, $t4
li $v0, 1
syscall

# reset t1 to 0 in order to increment through this array 
addi $t1, $zero, 0
# also reset offest for array 
addi $t3, $zero, 0
print_loop:
	beq $t1, 20, exit
	
	lw $t4, array($t1)
	li $v0, 1
	move $a0, $t4
	syscall 
	
	la $a0, newLine		# create new line 
	li $v0, 4
	syscall
	
	addi $t1, $t1, 1		# increment loop iterator 
	addi $t3, $t3, 4		# increment offset for array 
	
	j print_loop


exit_print:

exit:
li $v0, 10 
syscall 
