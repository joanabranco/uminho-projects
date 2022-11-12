/**
 * @file Ficheiro que contém as funções relativas ao guião 4
 */

#ifndef GUIAO4_H_INCLUDED
#define GUIAO4_H_INCLUDED
#include "stack.h"

DADOS Concatea(DADOS x, DADOS y);

void ConcateaMULT(STACK *stack,DADOS x,DADOS y);

DADOS TAMANHO(DADOS x);

void RANGE(DADOS x,STACK *s);

void REMPRIM(DADOS x,STACK *stack); 

void REMULT(DADOS x,STACK *stack);

void READLINE(STACK *stack);

char *append(char before, char *str, char after);

void transfer(STACK *s1, STACK *s2); /**<Coloca todos os elementos do array na stack*/

int procAUX (char *s1, char *s2);

void PROCURA (DADOS Y, DADOS X, STACK *stack);

void splitString(char* delims,STACK *s);

#endif //MAIN_C_GUIAO4_H
