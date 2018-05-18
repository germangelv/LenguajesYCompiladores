#!/usr/bin/python

import os
import subprocess

def remove(filename):
    try:
        os.remove(filename)
    except OSError:
        pass

subprocess.call(["flex","lexico.l"]);
raw_input("Lexico Generado... Presione ENTER para Continuar");
subprocess.call(["bison","-dyv","sintaxis.y"]);
raw_input("Sintaxis Generada... Presione ENTER para Continuar");
subprocess.call(["gcc","lex.yy.c","y.tab.c","-o","compilador.bin"]);
raw_input("Compilacion finalizada... Presione ENTER para Continuar");
subprocess.call(["./compilador.bin", "Prueba.txt"]);
raw_input("Ejemplo finalizado! Presione ENTER para Salir");
remove("lex.yy.c");
remove("y.tab.c");
remove("y.output");
remove("y.tab.h");
remove("compilador.bin");
