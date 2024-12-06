.data
array:      .word 163, 226, 222, 94, 247, 71, 97, 0, 64, 56, 224, 60, 58, 45, 38, 20
separator:  .asciiz ", "
new_line: .asciiz "\n"

.text
.globl main

main:
    la   $s0, array         # Endereço base do array
    li   $s1, 16           # Total de elementos

    add $t0,$s0,$zero # Copia endereço para o iterador
    li $t1,0
    jal printArray
    jal bubbleSort
    jal printArray

    li $v0, 10             # Código de saída
    syscall

    

bubbleSort:
    blez $s1, endBubbleSort

continue:
    li $t0, 0             # Inicializa o índice i = 0
    li $t1, 1             # Inicializa o próximo índice i+1
loop:
    bge $t0, $s1, endLoop  # Se i >= n, termina o loop

    # Carrega os elementos arr[i] e arr[i+1] para $t2 e $t3
    sll $t4, $t0, 2        # Calcula o deslocamento para arr[i]
    add $t4, $t4, $s0      # Calcula o endereço de arr[i]
    lw $t2, 0($t4)         # Carrega arr[i] para $t2

    sll $t5, $t1, 2        # Calcula o deslocamento para arr[i+1]
    add $t5, $t5, $s0      # Calcula o endereço de arr[i+1]
    lw $t3, 0($t5)         # Carrega arr[i+1] para $t3

    ble $t2, $t3, noSwap   # Se arr[i] <= arr[i+1], não troca

    # Troca arr[i] e arr[i+1]
    sw $t3, 0($t4)         # Armazena $t3 em arr[i]
    sw $t2, 0($t5)         # Armazena $t2 em arr[i+1]

noSwap:
    addi $t0, $t0, 1       # Incrementa o índice i
    addi $t1, $t1, 1       # Incrementa o próximo índice i+1
    j loop

endLoop:
    addi $s1, $s1, -1      # Decrementa o tamanho do array n
    addi $sp,$sp,-4
    sw $ra,0($sp)
    j bubbleSort           # Chama recursivamente a função bubbleSort com n-1

endBubbleSort:
    lw $ra,0($sp)
    addi $sp,$sp,4

    jr $ra


printArray:
    addi $sp,$sp,-8
    sw $t0,0($sp)
    sw $t1,4($sp)
    
    li $s1,16
    la $s0,array

    add $t0,$s0,$zero
    li $t1,0


loopingArray:
    beq $t1, $s1, returnFromPrint

    lw   $a0, 0($t0)
    li   $v0, 1 #Codigo para exibir INT
    syscall              

    # Imprime o separador
    la   $a0, separator   
    li   $v0, 4           #Codigo para exibir STRING
    syscall               

    addi $t1, $t1, 1
    addi $t0, $t0,4

    j loopingArray

returnFromPrint:
    lw $t0,0($sp)
    lw $t1,4($sp)

    addi $sp,$sp,8
    
    # Imprime o new_line
    la   $a0, new_line   
    li   $v0, 4           #Codigo para exibir STRING
    syscall


    jr $ra