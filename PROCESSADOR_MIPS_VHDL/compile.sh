#!/bin/bash

# Diretório contendo os arquivos .vhd
VHDL_DIR="./"  # Atualize com o caminho do diretório se necessário

# Compilar cada arquivo .vhd no diretório, exceto cpu.vhd
for vhdl_file in "$VHDL_DIR"*.vhd; do
    if [[ $(basename "$vhdl_file") != "mono_cpu.vhd" ]]; then
        echo "Compilando $vhdl_file..."
        ghdl -a --std=08 "$vhdl_file"
        if [ $? -ne 0 ]; then
            echo "Erro ao compilar $vhdl_file"
            exit 1
        fi
    fi
done

# Após todos os outros arquivos terem sido compilados com sucesso, compilar mono_cpu.vhd
echo "Compilando mono_cpu.vhd..."
ghdl -a --std=08 "${VHDL_DIR}mono_cpu.vhd"
if [ $? -ne 0 ]; then
    echo "Erro ao compilar mono_cpu.vhd"
    exit 1
fi

echo "Todos os arquivos foram compilados com sucesso."

