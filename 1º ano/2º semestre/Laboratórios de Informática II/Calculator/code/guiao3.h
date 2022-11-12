/**
 * @file Ficheiro que contém as funções relativas ao guião 3
 */

#ifndef GUIAO3_H_INCLUDED
#define GUIAO3_H_INCLUDED
#include "stack.h"

void igual (STACK *stack);

void menor (STACK *stack);

void maior (STACK *stack);

void negacao (STACK *stack);

void eComercial (STACK *stack);

void eBarra (STACK *stack);

void emenor (STACK *stack);

void eMaior (STACK *stack);

void ptInterr (STACK *stack);

int Evariavel (char x);

void handleVariable(char* token, STACK *stack);


#endif //MAIN_C_GUIAO3_H
