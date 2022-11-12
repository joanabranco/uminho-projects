/**
 * @file Ficheiro que contém as funções executadas para a stack
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "stack.h"


/**
 * \brief Produz a stack
 *
 * @returns a stack
 */
STACK *create_stack() {
    STACK *s = (STACK *) malloc(sizeof (STACK));
    s->top = 0;
    s->size= 100;
    s->stack = (DADOS *) calloc(s->size, sizeof (DADOS));
    VAR *var = malloc(sizeof (struct variaveis)*26);
    s->var = var;
    for (int i=0; i<26;i++){
        s->var[i].t= LONG;
    }
    s->var['N'-'A'].t= CHAR;
    s->var['S'-'A'].t= CHAR;
    s->var['A'-'A'].v.x= 10;
    s->var['B'-'A'].v.x= 11;
    s->var['C'-'A'].v.x= 12;
    s->var['D'-'A'].v.x= 13;
    s->var['E'-'A'].v.x= 14;
    s->var['F'-'A'].v.x= 15;
    s->var['N'-'A'].v.y= '\n';
    s->var['S'-'A'].v.y= ' ';
    s->var['X'-'A'].v.x= 0;
    s->var['Y'-'A'].v.x= 1;
    s->var['Z'-'A'].v.x= 2;
    return s;
}

/**
 * \brief Adiciona um elemento dado ao topo da stack
 *
 * @param *s correspondente à stack inicial
 * @param o elemento a adicionar
 */
void push(STACK *s, DADOS elem) {
    if(s->size == s->top) {
        s->size += 100;
        s->stack = (DADOS *) realloc(s->stack, s->size * sizeof(DADOS));
    }
    s->stack[s->top] = elem;
    s->top++;
}

/**
 * \brief Imprime o array 
 *
 * @param *s stack que vai sofrer modificações
 */
void print_array(STACK *s) {
    for(int K = 0; K < s->top; K++) {
        DADOS elem = s->stack[K];
        TIPO type = elem.tipo;
        switch (type) {
            case LONG:
                printf("%ld",*(long *) elem.dados); break;
            case DOUBLE:
                printf("%g",*(double *)elem.dados); break;
            case CHAR:
                printf("%c",*(char *)elem.dados); break;
            case STRING:
                printf("%s",(char *)elem.dados); break;
            case ARRAY:
                print_array((STACK *)elem.dados);break;
        }
    }
    free(s);
}
/**
 * \brief Imprime a stack no endereço s
 *
 * @param *s endereço onde imprime a STACK
 */
void print_stack(STACK *s) {
    for(int K = 0; K < s->top; K++) {
        DADOS elem = s->stack[K];
        TIPO type = elem.tipo;
        switch (type) {
            case LONG:
                printf("%ld",*(long *) elem.dados); break;
            case DOUBLE:
                printf("%g",*(double *)elem.dados); break;
            case CHAR:
                printf("%c",*(char *)elem.dados); break;
            case STRING:
                printf("%s",(char *)elem.dados); break;
            case ARRAY:
                print_array((STACK *)elem.dados); break;
        }
    }
    printf("\n");
}

/**
 * \brief Retira elemento da stack no endereço s
 *
 * @param *s endereço onde imprime a STACK
 * @returns a stack sem elemento
 */
DADOS pop(STACK *s) {
        s->top--;
        return s->stack[s->top];

}

/**
 * \brief Indica qual o próximo elemento a ser retirado da stack no endereço s
 *
 * @param *s endereço onde imprime a STACK
 * @returns posição do próximo elemento a retirar
 */
DADOS top(STACK *s) {
    return s->stack[s->top - 1];
}

/**
 * \brief Verifica se a stack está vazia
 *
 * @param *s endereço onde imprime a STACK
 */
int is_empty(STACK *s) {
    return s->top == 0;
}

/**
 * \brief Produz os dados do tipo long
 *
 * @param v dado recebido do tipo long
 */
DADOS MAKE_DADOS_LONG(long v) {
    long *pv = (long *) malloc( sizeof(long));
    *pv = v;
    DADOS d = {LONG, pv};
    return d;
}

/**
 * \brief Produz os dados do tipo double
 *
 * @param v dado recebido do tipo double
 */
DADOS MAKE_DADOS_DOUBLE(double v) {
    double *pv = (double *) malloc( sizeof(double));
    *pv = v;
    DADOS d = {DOUBLE, pv};
    return d;
}

/**
 * \brief Produz os dados do tipo char
 *
 * @param v dado recebido do tipo char
 */
DADOS MAKE_DADOS_CHAR(char v) {
    char *pv = (char *) malloc( sizeof(char));
    *pv = v;
    DADOS d = {CHAR, pv};
    return d;
}

/**
 * \brief Produz os dados do tipo string
 *
 * @param v dado recebido do tipo string
 */
DADOS MAKE_DADOS_STRING(char *s) {
    char *ps = strdup(s);
    DADOS d = {STRING, ps};
    return d;
}

/**
 * \brief Produz os dados do tipo array
 *
 * @param *s stack onde está o array
 * @returns os dados do tipo array
 */
DADOS MAKE_DADOS_ARRAY(STACK *s) {
    STACK *pa = malloc(sizeof (struct stack));
    pa = s;
    DADOS d = {ARRAY, pa};
    return d;
}
