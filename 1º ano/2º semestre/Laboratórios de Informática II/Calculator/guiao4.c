/**
 * @file Ficheiro que contém as funções relativas ao guião 4
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <assert.h>
#include "guiao4.h"

/**
 * \brief Efetua a concatenação entre strings e arrays
 * 
 * @param before conteúdo anterior
 * @param *str string recebida
 * @param after conteúdo posterior
 * @returns a string com a junção dos dados inseridos
 */
char *append(char before, char *str, char after){
    size_t len = strlen(str);
    if (before)
    {
        memmove(str + 1, str, ++len);
        *str = before;
    }
    if (after)
    {
        str[len] = after;
        str[len + 1] = 0;
    }
    return str;
}

/**
 * \brief Coloca na stack os elementos do array
 * 
 * @param *s1 stack recebida
 * @param *s2 stack recebida
 */
void transfer(STACK *s1,STACK *s2) {
    DADOS X;
    int K;
    for(K = 0; K < s2->top; K++) {
        DADOS elem = s2->stack[K];
        TIPO type = elem.tipo;
        switch (type) {
            case LONG:
                X = MAKE_DADOS_LONG(*(long *)elem.dados);
                break;
            case DOUBLE:
                X = MAKE_DADOS_DOUBLE(*(double *)elem.dados);
                break;
            case CHAR:
                X = MAKE_DADOS_CHAR(*(char *)elem.dados);
                break;
            case STRING:
                X = MAKE_DADOS_STRING((char *)elem.dados);
                break;
            case ARRAY:
                X = MAKE_DADOS_ARRAY((STACK *)elem.dados);
                break;
        }
        push(s1,X);
    }
}

/**
 * \brief Efetua a concatenação entre strings e arrays
 * 
 * @param x 1º valor recebido 
 * @param y 2º valor recebido 
 * @returns a junção entre os dados inseridos
 */
DADOS Concatea(DADOS x, DADOS y) {
    if (x.tipo == CHAR && y.tipo == STRING) {
        char d1 = *(char*)x.dados;
        char *d2 = (char*)y.dados;
        return MAKE_DADOS_STRING(append(d1,d2,0));
    }
    else if (x.tipo == STRING && y.tipo == CHAR) {
        char d2 = *(char*)y.dados;
        char *d1 = (char*)x.dados;
        return MAKE_DADOS_STRING(append(0,d1,d2));
    }
    else if (x.tipo == ARRAY && y.tipo != ARRAY) {
        push((STACK*)x.dados,y);
        return x;
    }
    else if (y.tipo == ARRAY && x.tipo != ARRAY) {
        STACK *xs = (STACK *)y.dados;
        push(xs,x);
        for (int i = xs->top; i > 0 ; i--) {
            xs->stack[i] = xs->stack[i-1];
        }
        xs->stack[0] = x;
        return MAKE_DADOS_ARRAY(xs);
    }
    else if (y.tipo == ARRAY && x.tipo == ARRAY) {
        STACK *xs = (STACK*)x.dados;
        STACK *ys = (STACK*)y.dados;
        transfer(xs,ys);
        return MAKE_DADOS_ARRAY(xs);
    }
    else {
        char *xs = (char *) x.dados;
        char *ys = (char *) y.dados;
        strcat(xs, ys);
        return MAKE_DADOS_STRING(xs);
    }
}

/**
 * \brief Efetua a concatenação múltiplas vezes de strings ou arrays
 * 
 * @param x 1º valor recebido 
 * @param y 2º valor recebido 
 * @returns a strings ou arrays repetido várias vezes
 */
void ConcateaMULT(STACK * stack,DADOS x,DADOS y) {
    long ys = *(long *)y.dados;
    if (x.tipo == ARRAY) {
        STACK *xs = (STACK *)x.dados;
        int top = xs->top;
        for (int i = 0; i < ys-1; i++) {
            for(int K = 0; K < top ; K++) {
                DADOS elem = xs->stack[K];
                TIPO type = elem.tipo;
                switch (type) {
                    case LONG:
                        push(xs, MAKE_DADOS_LONG(*(long*)elem.dados));
                        break;
                    case DOUBLE:
                        push(xs, MAKE_DADOS_DOUBLE(*(double*)elem.dados));
                        break;
                    case CHAR:
                        push(xs, MAKE_DADOS_CHAR(*(char*)elem.dados));
                        break;
                    case STRING:
                        push(xs, MAKE_DADOS_STRING((char *)elem.dados));
                        break;
                    case ARRAY:
                        push(xs, MAKE_DADOS_ARRAY((STACK *)elem.dados));
                        break;
                }
            }
        }
        push(stack,MAKE_DADOS_ARRAY(xs));
    }
    else {
        char *xs = (char *)x.dados;
        char *copy = malloc(sizeof (xs));
        strcpy(copy,xs);
        for (int i = ys; i > 1; i--) {
            strcat(xs, copy);
        }
        push(stack, MAKE_DADOS_STRING(xs));
    }
}
/**
 * \brief Tamanho do array inserido
 * 
 * @param x valor recebido 
 * @returns o comprimento em questão
 */
DADOS TAMANHO(DADOS x) {
    if (x.tipo == ARRAY) {
        int K;
        STACK *s = (STACK *)x.dados;
        for(K = 0; K < s->top; K++);
        return MAKE_DADOS_LONG(K);
    }
    else return MAKE_DADOS_LONG((long) strlen((char *) x.dados));
}

/**
 * \brief Alcance do array inserido
 * 
 * @param x valor recebido 
 * @param *s stack que vai sofrer modificações
 * @returns a distância em questão
 */
void RANGE(DADOS x,STACK *s) {
    long xs = *(long *)x.dados;
    STACK *s2 = (STACK *) malloc(sizeof (STACK));
    s2->top = 0;
    s2->size= 100;
    s2->stack = (DADOS *) calloc(s2->size, sizeof (DADOS));
    s2->var = s->var;
    for (int i = 0; i < xs; i++) {
        push(s2, MAKE_DADOS_LONG(i));
    }
    push(s, MAKE_DADOS_ARRAY(s2));
}

/**
 * \brief Remover o primeiro elemento do array ou string e colocar na stack 
 * 
 * @param x valor recebido 
 * @param *stack que vai sofrer modificações
 * @returns a stack com o primeiro elemento do array
 */
void REMPRIM(DADOS x,STACK *stack) {
    if (x.tipo == STRING) {
        char *xs = (char *)x.dados;
        char result2 = xs[0];
        xs++;
        push(stack, MAKE_DADOS_STRING(xs));
        push(stack, MAKE_DADOS_CHAR(result2));
    }
    else {
        STACK*s = (STACK*)x.dados;
        DADOS res2 = s->stack[0];
        int top = s->top;
        for (int i = 0; i < top; i++) {
            s->stack[i] = s->stack[i+1];
        }
        pop(s);
        push(stack, MAKE_DADOS_ARRAY(s));
        push(stack, res2);
    }
}

/**
 * \brief Remover o último  elemento do array ou string e colocar na stack 
 * 
 * @param x valor recebido 
 * @param *stack que vai sofrer modificações
 * @returns a stack com o último elemento do array
 */
void REMULT(DADOS x,STACK *stack) {
    if (x.tipo == STRING) {
        char *xs = (char *)x.dados;
        char result2 = xs[((int)strlen(xs))-1];
        xs[((int)strlen(xs))-1] = '\0';
        push(stack, MAKE_DADOS_STRING(xs));
        push(stack, MAKE_DADOS_CHAR(result2));
    }
    else {
        STACK *s = (STACK*)x.dados;
        DADOS res2 = s->stack[s->top-1];
        pop(s);
        push(stack, MAKE_DADOS_ARRAY(s));
        push(stack, res2);

    }
}

/**
 * \brief Lẽ toda a linha do Input
 * 
 * @param *stack que vai sofrer modificações
 * @returns a stack com a string inserida
 */
void READLINE(STACK *stack) {
    char *str = malloc (sizeof (char)* 10240);
    char *res = malloc(sizeof (char)*10240);
    res = fgets(res,10240,stdin);
    while (fgets(str,10240,stdin) != NULL) {
        strcat(res,str);
    }
    assert (res != NULL);
    push(stack, MAKE_DADOS_STRING(res));
}

/**
 * \brief Função auxiliar à função PROCURA
 * 
 * @param s1 string lida no input
 * @param s2 string lida no input
 * @returns o valor na posiçao pedida
 */
int procAUX (char *s1, char *s2) {
    if (s2[0] == '\0') {
        return (int)strlen(s1);
    }
    int i, j, k;
    for (i = 0; s1[i] != '\0'; i++) {
        if (s1[i] == s2[0]) {
            for (k = i, j = 0; s1[k] != '\0' && s2[j] != '\0'; k++, j++) {
                if (s1[k] != s2[j]) break;
            }
            if (s2[j] == '\0') return i;
        }
    }
    return -1;
}

/**
 * \brief Procura substring na string e devolve o índice
 * 
 * @param Y
 * @param X 
 * @param *stack que vai sofrer modificações
 */
void PROCURA (DADOS Y, DADOS X, STACK *stack) {
    char *substr = strdup((char*)Y.dados);
    char *str = strdup((char*)X.dados);
    int i;
    i = procAUX (str, substr);
    push(stack, MAKE_DADOS_LONG(i));
}

/**
 * \brief Separa string por uma substring
 * 
 * @param *delims string inserida
 * @param *stack que vai sofrer modificações
 */
void splitString(char* delims,STACK *s){
    DADOS str = pop(s);
    char *split;
    split = strtok((char*)str.dados, delims);
    STACK *array = (STACK *) malloc(sizeof (STACK));
    array->top = 0;
    array->size= 100;
    array->stack = (DADOS *) calloc(array->size, sizeof (DADOS));
    array->var = s->var;
    char* elem;
    while(split != NULL){
        elem = strdup(split);
        push(array, MAKE_DADOS_STRING(elem));
        split = strtok(NULL, delims);
    }

    push(s, MAKE_DADOS_ARRAY(array));
}