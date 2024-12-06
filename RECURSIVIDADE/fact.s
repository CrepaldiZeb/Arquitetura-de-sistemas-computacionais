.data
prompt: .asciiz "Entre com um numero positivo: 
"

.text
.globl main

main:
li $v0, 4
la $a0, prompt
syscall

li $v0, 5
syscall

move $a0, $v0
jal factorial

move $a0, $v0
li $v0, 1
syscall

li $v0, 10
syscall

factorial:
bgtz $a0, recursiveCase
li $v0, 1
jr $ra

recursiveCase:
addi $sp, $sp, -4
sw $ra, 0($sp)

addi $a0, $a0, -1
jal factorial

lw $ra, 0($sp)
addi $sp, $sp, 4

addi $a0, $a0, 1
mul $v0, $v0, $a0

jr $ra
