/**
 * @file Ficheiro que contém as funções relativas ao guião 2
 */

#include <stdlib.h>
#include "guiao2.h"



/**
 * \brief Realiza a operação de duplicar na stack
 * 
 * @param *stack que vai sofrer modificações
 */
void DUPLICAR (STACK *stack) {
    DADOS x = stack->stack[(stack->top)-1];
    push(stack, x);
}
/**
 * \brief Realiza a operação de rodar dois elementos na stack
 * 
 * @param *stack que vai sofrer modificações
 */
void RODAR_DOIS_ELEMENTOS(STACK *stack) {
    DADOS x = pop(stack);
    DADOS y = pop(stack);
    push(stack,x);
    push(stack,y);
}
/**
 * \brief Realiza a operação de rodar três elementos na stack
 * 
 * @param *stack que vai sofrer modificações
 */
void RODAR_TRES_ELEMENTOS(STACK *stack) {
    DADOS x = pop(stack);
    DADOS y = pop(stack);
    DADOS z = pop(stack);
    push(stack,y);push(stack,x);push(stack,z);
}
/**
 * \brief Realiza a operação de copiar n elementos na stack
 * 
 * @param *stack que vai sofrer modificações
 */
void COPIAR_N_ELEMENTO(STACK *stack) {
    DADOS x = pop(stack);
    int a = (stack->top)-1-(*(long *) x.dados);
    push(stack,stack->stack[a]);
}

/**
 * \brief Realiza a operação de conversão de inteiros na stack
 * 
 * @param *stack que vai sofrer modificações
 */
void INT_CONVERTE (STACK *stack){
    DADOS x=pop(stack);
    if (x.tipo==DOUBLE){
        long y= (long)* (double*) x.dados;
        push (stack,MAKE_DADOS_LONG (y));
    }
    else if (x.tipo==CHAR){

        long y= (long)* (char*) x.dados;
        push (stack,MAKE_DADOS_LONG (y));
    }
    else if (x.tipo==STRING) {
        char *sobra1;
        long y = strtol(x.dados, &sobra1, 10);
        push(stack,MAKE_DADOS_LONG(y));
    } else {
        push(stack,x);
    }
}
/**
 * \brief Realiza a operação de conversão de doubles na stack
 * 
 * @param *stack que vai sofrer modificações
 */
void DOUBLE_CONVERTE (STACK *stack){
    DADOS x=pop(stack);
    if (x.tipo==LONG){
        double y= (double)* (long*) x.dados;
        push (stack,MAKE_DADOS_DOUBLE (y));
    }
    else if (x.tipo==CHAR){
        double y= (double)* (char*) x.dados;
        push (stack,MAKE_DADOS_DOUBLE (y));
    }
    else if (x.tipo==STRING) {
        char *sobra1;
        double y = strtod(x.dados, &sobra1);
        push(stack,MAKE_DADOS_DOUBLE(y));
    }
    else {
        push(stack, x);
    }
}
/**
 * \brief Realiza a operação de conversão de chars na stack
 * 
 * @param *stack que vai sofrer modificações
 */
void CHAR_CONVERTE (STACK *stack){
    DADOS x=pop(stack);
    if (x.tipo==LONG){
        char y= (char)* (long*) x.dados;
        push (stack,MAKE_DADOS_CHAR (y));
    }
    else if (x.tipo==DOUBLE){
        char y= (char)* (double*) x.dados;
        push (stack,MAKE_DADOS_CHAR (y));
    } else {
        push(stack ,x);
    }
}
