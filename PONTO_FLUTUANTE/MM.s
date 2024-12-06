.data
X: 	.float 0.5, 1.0, 1.5, 2.0
	.float 2.5, 3.0, 3.5, 4.0
	.float 4.5, 5.0, 5.5, 6.0
	.float 6.5, 7.0, 7.5, 8.0

Y: 	.float 1.0, 1.75, 2.0, 2.75
	.float 3.0, 3.75, 4.0, 4.75
	.float 5.0, 5.75, 6.0, 6.75
	.float 7.0, 7.75, 8.0, 8.75

Z: .space 64

virgula:  .asciiz ", "
linha: .asciiz "\n"

.text
.globl main

print:
    addi $sp,$sp,-12
    sw $t0,0($sp)
    sw $t1,4($sp)
	sw $s1,8($sp)
    
    li $s1,4

    add $t0,$s4,$zero
    li $t1,0				

forprint:
    beq $t1, $s1, endprint	

    lwc1   $f12, 0($t0)			
    li   $v0, 2 				
    syscall              

								
    la   $a0, virgula   
    li   $v0, 4           
    syscall               

								
    addi $t1, $t1, 1
    addi $t0, $t0,4

    j forprint

endprint:
    lw $t0,0($sp)
    lw $t1,4($sp)
	lw $s1,8($sp)
	

    addi $sp,$sp,12
    
    la   $a0, linha  
    li   $v0, 4           
    syscall

    jr $ra

main:

    li $s0, 4           
    la $s1, X           
    la $s2, Y           
    la $s3, Z           

	li $t0, 0			
forI:
	li $t1, 0			
forJ:
	li $t2, 0		
	li.s $f0, 0.0		

forK:
	li.s $f1, 0.0	
	
	mul $t3, $s0, $s0	
	mul $t3, $t3, $t0	
	
	mul $t4, $s0, $t2	
	
	add $t5, $s1, $t3	
	add $t5, $t5, $t4
	
	l.s $f2, 0($t5) 	
	
	
	
	mul $t3, $s0, $s0	
	mul $t3, $t3, $t2	
	
	mul $t4, $s0, $t1	
	
	add $t5, $s2, $t3	
	add $t5, $t5, $t4	
	
	l.s $f3, 0($t5) 		
	
	
	mul.s $f1, $f2, $f3	
	add.s $f0, $f0, $f1	
	
	
	addi $t2, $t2, 1
	blt $t2, $s0, forK

	
	mul $t3, $s0, $s0	
	mul $t3, $t3, $t0	
	
	mul $t4, $s0, $t1	
	
	add $t5, $s3, $t3	
	add $t5, $t5, $t4	
	
	s.s $f0, 0($t5)		


	
	addi $t1, $t1, 1
	blt $t1, $s0, forJ
	
	
	addi $t0, $t0, 1
	blt $t0, $s0, forI
	
printFinal:
	la $s4, 0($s3)	
	jal print

    la $s4, 16($s3)		
	jal print

    la $s4, 32($s3)		
	jal print

    la $s4, 48($s3)		
	jal print

exit:
    li $v0, 10         
    syscall
