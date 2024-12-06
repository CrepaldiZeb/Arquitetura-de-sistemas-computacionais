.data
text_input_message: .asciiz "Digite um numero em ponto fixo: "
mask_remove_one: .word 0x003FFFFF
.text

main:
    
    #Exibe o texto do ponto fixo
    li $v0,4
    la $a0, text_input_message
    syscall

    #Pede para o usuário inserir um número
    li $v0,5
    syscall

    beq $v0,$zero,done

    #Copia para s0 a entrada do usuário
    addu $s0,$v0,$zero
    #Aloca e armazena na pilha o valor dado pelo usuário do ponto-fixo
    addi $sp,$sp,-4
    sw $v0,0($sp)

    #Isola a parte inteira
    srl  $s0,$s0,8
    ori $s2,$s2,0xFFFF
    and $s0,$s0,$s2
    
    
    addiu $t0,$zero,1
    #Contador para calcular expoente
    addiu $t1,$zero,0

    #Calcula o expoente, deslocando até que seja <= 1.

expo_loop:
    ble $s0,$t0,exit_loop
    srl $s0,$s0,1
    addiu $t1,$t1,1

    j expo_loop

exit_loop:
    #Restaura o ponto-fixo original e desaloca memória
    lw $s0,0($sp)
    addi $sp,$sp,4

    #Copia para t0 o ponto-fixo
    addu $t0,$s0,$zero

    #Quantidade de deslocamentos para a esquerda
    addi $t4,$zero,15
    sub $t4,$t4,$t1

    #Desloca para a esquerda a mantissa baseado no expoente.
    lw $t3,mask_remove_one
    sll $s0,$s0,$t4
    and $s0,$s0,$t3

    #127 + 8 para considerar os deslocamentos
    addiu $s2,$t1,135
    
    #Mascara para o expoente
    move $s4,$s2
    sll $s4,$s4,23

    #Junta o expoente com a mantissa
    or $s4,$s4,$s0

    addi $sp,$sp,-4
    sw $s4,0($sp)

    l.s $f12,0($sp)    
    addi $sp,$sp,4


done:
    #Exibe o valor em ponto flutuante
    addiu $v0,$zero,2
    syscall

    jr $ra