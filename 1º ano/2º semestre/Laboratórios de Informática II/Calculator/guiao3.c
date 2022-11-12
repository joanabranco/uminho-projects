/**
 * @file Ficheiro que contém as funções relativas ao guião 3
 */

#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include "guiao3.h"

// =
/**
 * \brief Compara a igualdade entre dois valores inseridos na stack
 * 
 * @param *stack que vai sofrer modificações
 * @returns o valor lógico da operação realizada (zero ou um)
 */
void igual (STACK *stack){
    DADOS n1 = pop (stack);
    DADOS n2 = pop (stack);
    if (n1.tipo==DOUBLE && n2.tipo==DOUBLE){
        double d1 = *(double *) n1.dados;
        double d2 = *(double *) n2.dados;
        if (d1 == d2) push(stack,MAKE_DADOS_LONG(1));
        else push (stack, MAKE_DADOS_LONG(0));
    }
    else if (n1.tipo == LONG && n2.tipo == DOUBLE) {
        long d1 = *(long *) n1.dados;
        double d2 = *(double *) n2.dados;
        if (d1 == d2) push(stack,MAKE_DADOS_LONG(1));
        else push (stack, MAKE_DADOS_LONG(0));
    }
    else if (n1.tipo == DOUBLE && n2.tipo == LONG) {
        double d1 = *(double *) n1.dados;
        long d2 = *(long *) n2.dados;
        if (d1 == d2) push(stack,MAKE_DADOS_LONG(1));
        else push (stack, MAKE_DADOS_LONG(0));
    }
    else if (n2.tipo == STRING && n1.tipo == LONG) {
        long d1 = *(long *)n1.dados;
        char *d2 = (char *)n2.dados;
        char result = d2[d1];
        push(stack,MAKE_DADOS_CHAR(result));
    }
    else if (n2.tipo == ARRAY && n1.tipo == LONG) {
        long d1 = *(long *)n1.dados;
        STACK *xs = (STACK *)n2.dados;
        push(stack,xs->stack[d1]);
    }
    else  {
        long d1 = *(long *) n1.dados;
        long d2 = *(long *) n2.dados;
        if (d1 == d2) push(stack,MAKE_DADOS_LONG(1));
        else push (stack, MAKE_DADOS_LONG(0));

    }
}


// <
/**
 * \brief Compara entre dois valores qual o menor deles
 *
 * @param *stack que vai sofrer modificações
 * @returns o valor lógico da operação realizada (zero ou um)
 */
void menor (STACK *stack){
    DADOS n1 = pop (stack);
    DADOS n2 = pop (stack);

    if (n1.tipo==DOUBLE && n2.tipo==DOUBLE){
        double d1 = *(double *) n1.dados;
        double d2 = *(double *) n2.dados;
        if (d2 < d1) push(stack,MAKE_DADOS_LONG(1));
        else push(stack,MAKE_DADOS_LONG(0));
    }
    else if (n1.tipo == LONG && n2.tipo == DOUBLE) {
        long d1 = *(long *) n1.dados;
        double d2 = *(double *) n2.dados;
        if (d1 == 0 || d2 == 0.0) push(stack,MAKE_DADOS_LONG(0));
        if (d2 < d1) push(stack,MAKE_DADOS_LONG(1));
        else push(stack,MAKE_DADOS_LONG(0));
    }
    else if (n1.tipo == DOUBLE && n2.tipo == LONG) {
        double d1 = *(double *) n1.dados;
        long d2 = *(long *) n2.dados;
        if (d1 == 0.0 || d2 == 0) push(stack,MAKE_DADOS_LONG(0));
        if (d2 < d1) push(stack,MAKE_DADOS_LONG(1));
        else push(stack,MAKE_DADOS_LONG(0));
    }
    else if (n2.tipo == STRING && n1.tipo == LONG) {
        long d1 = *(long*)n1.dados;
        char *d2 = (char *)n2.dados;
        char *result = strdup(d2);
        result[d1] = '\0';
        push(stack, MAKE_DADOS_STRING(result));
    }
    else if (n2.tipo == ARRAY && n1.tipo == LONG) {
        long d1 = *(long*)n1.dados;
        STACK *s = (STACK *)n2.dados;
        for(int K = 0; K < d1; K++) {
            DADOS elem = s->stack[K];
            TIPO type = elem.tipo;
            switch (type) {
                case LONG:
                    push(stack, MAKE_DADOS_LONG(*(long *) elem.dados));
                    break;
                case DOUBLE:
                    push(stack, MAKE_DADOS_DOUBLE(*(double *) elem.dados));
                    break;
                case CHAR:
                    push(stack, MAKE_DADOS_CHAR(*(char *) elem.dados));
                    break;
                case STRING:
                    push(stack, MAKE_DADOS_STRING((char *) elem.dados));
                    break;
                case ARRAY:
                    push(stack, MAKE_DADOS_ARRAY((STACK *) elem.dados));
                    break;
            }
        }
    }
    else if (n2.tipo == STRING && n1.tipo == STRING) {
        char *d1 = (char*) n1.dados;
        char *d2 = (char*) n2.dados;
        if (d2 < d1) push(stack, MAKE_DADOS_LONG(0));
        else push(stack, MAKE_DADOS_LONG(1));
    }
    else  {
        long d1 = *(long *) n1.dados;
        long d2 = *(long *) n2.dados;
        if (d1 == 0 || d2 == 0) push(stack,MAKE_DADOS_LONG(0));
        if (d2 < d1) push(stack,MAKE_DADOS_LONG(1));
        else push(stack,MAKE_DADOS_LONG(0));

    }
}


// >
/**
 * \brief Compara entre dois valores qual o maior deles
 *
 * @param *stack que vai sofrer modificações
 * @returns o valor lógico da operação realizada (zero ou um)
 */
void maior (STACK *stack){
    DADOS n1 = pop(stack);
    DADOS n2 = pop(stack);

    if (n1.tipo==DOUBLE && n2.tipo==DOUBLE){
        double d1 = *(double *) n1.dados;
        double d2 = *(double *) n2.dados;
        if (d2 > d1) push(stack,MAKE_DADOS_LONG(1));
        else push(stack,MAKE_DADOS_LONG(0));
    }
    else if (n1.tipo == LONG && n2.tipo == DOUBLE) {
        long d1 = *(long *) n1.dados;
        double d2 = *(double *) n2.dados;
        if (d1 == 0 || d2 == 0.0) push(stack,MAKE_DADOS_LONG(0));
        if (d2 > d1) push(stack,MAKE_DADOS_LONG(1));
        else push(stack,MAKE_DADOS_LONG(0));
    }
    else if (n1.tipo == DOUBLE && n2.tipo == LONG) {
        double d1 = *(double *) n1.dados;
        long d2 = *(long *) n2.dados;
        if (d1 == 0.0 || d2 == 0) push(stack,MAKE_DADOS_LONG(0));
        if (d2 > d1) push(stack,MAKE_DADOS_LONG(1));
        else push(stack,MAKE_DADOS_LONG(0));
    }
    else if (n2.tipo == STRING && n1.tipo == LONG) {
        long d1 = *(long*)n1.dados;
        char *d2 = (char *)n2.dados;
        char *result = strdup(d2+((int)strlen(d2)-d1));
        push(stack, MAKE_DADOS_STRING(result));
    }
    else if (n2.tipo == ARRAY && n1.tipo == LONG) {
        long d1 = *(long*)n1.dados;
        STACK *s = (STACK *)n2.dados;
        int top = s->top;
        for(int K = top-d1; K < top; K++) {
            DADOS elem = s->stack[K];
            TIPO type = elem.tipo;
            switch (type) {
                case LONG:
                    push(stack, MAKE_DADOS_LONG(*(long *) elem.dados));
                    break;
                case DOUBLE:
                    push(stack, MAKE_DADOS_DOUBLE(*(double *) elem.dados));
                    break;
                case CHAR:
                    push(stack, MAKE_DADOS_CHAR(*(char *) elem.dados));
                    break;
                case STRING:
                    push(stack, MAKE_DADOS_STRING((char *) elem.dados));
                    break;
                case ARRAY:
                    push(stack, MAKE_DADOS_ARRAY((STACK *) elem.dados));
                    break;
            }
        }
    }
    else if (n2.tipo == STRING && n1.tipo == STRING) {
        char *d1 = (char*) n1.dados;
        char *d2 = (char*) n2.dados;
        if (d2 > d1) push(stack, MAKE_DADOS_LONG(0));
        else push(stack, MAKE_DADOS_LONG(1));
    }
    else  {
        long d1 = *(long *) n1.dados;
        long d2 = *(long *) n2.dados;
        if (d1 == 0 || d2 == 0) push(stack,MAKE_DADOS_LONG(0));
        if (d2 > d1) push(stack,MAKE_DADOS_LONG(1));
        else push(stack,MAKE_DADOS_LONG(0));

    }
}


// !
/**
 * \brief Nega um dado valor inserido na stack
 *
 * @param *stack que vai sofrer modificações
 * @returns a negação do valor (zero ou um)
 */
void negacao (STACK *stack){
    DADOS n1 = pop (stack);

    if (n1.tipo == DOUBLE) {
        if (*(double*)n1.dados == 0.0) push(stack,MAKE_DADOS_LONG(1));
        else push(stack,MAKE_DADOS_LONG(0));
    }
    else if (n1.tipo == LONG){
        if (*(long*)n1.dados == 0) push(stack,MAKE_DADOS_LONG(1));
        else push(stack,MAKE_DADOS_LONG(0));
    }
    else {
        if (*(char*)n1.dados == 0) push(stack,MAKE_DADOS_LONG(1));
        else push(stack,MAKE_DADOS_LONG(0));
    }

}


// e&
/**
 * \brief Compara entre dois valores qual o maior, exceto para zero
 * 
 * @param *stack que vai sofrer modificações
 * @returns o valor zero se um deles for zero ou, caso contrário, o maior entre os dois valores
 */
void eComercial (STACK *stack){
    DADOS n1 = pop(stack);
    DADOS n2 = pop(stack);
    if (n1.tipo==DOUBLE && n2.tipo==DOUBLE){
        double d1 = *(double *) n1.dados;
        double d2 = *(double *) n2.dados;
        if (d1 == 0.0 || d2 == 0.0) push(stack,MAKE_DADOS_LONG(0));
        else if (d1>d2) push(stack, n1);
        else push (stack, n2);
    }
    else if (n1.tipo == LONG && n2.tipo == DOUBLE) {
        long d1 = *(long *) n1.dados;
        double d2 = *(double *) n2.dados;
        if (d1 == 0 || d2 == 0.0) push(stack,MAKE_DADOS_LONG(0));
        else if (d1>d2) push(stack, n1);
        else push (stack, n2);
    }
    else if (n1.tipo == DOUBLE && n2.tipo == LONG) {
        double d1 = *(double *) n1.dados;
        long d2 = *(long *) n2.dados;
        if (d1 == 0.0 || d2 == 0) push(stack,MAKE_DADOS_LONG(0));
        else if (d1>d2) push(stack, n1);
        else push (stack, n2);
    }
    else  {
        long d1 = *(long *) n1.dados;
        long d2 = *(long *) n2.dados;
        if (d1 == 0 || d2 == 0) push(stack,MAKE_DADOS_LONG(0));
        else if (d1>d2) push(stack, n1);
        else push (stack, n2);

    }
}


// e|
/**
 * \brief Compara se os valores inseridos são diferentes de zero
 * 
 * @param *stack que vai sofrer modificações
 * @returns o primeiro valor na stack se forem diferentes de zero e, o outro valor caso contrário
 */
void eBarra (STACK *stack){
    DADOS n1 = pop (stack);
    DADOS n2 = pop(stack);
    if (n1.tipo==DOUBLE && n2.tipo==DOUBLE){
        double d1 = *(double *) n1.dados;
        double d2 = *(double *) n2.dados;
        if (d1 != 0.0 && d2 != 0.0) push(stack,n2);
        else if (d1 == 0.0 && d2 != 0.0) push(stack,n2);
        else if (d1 != 0.0 && d2 == 0.0) push(stack,n1);
        else push (stack, MAKE_DADOS_LONG(0));
    }
    else if (n1.tipo == LONG && n2.tipo == DOUBLE) {
        long d1 = *(long *) n1.dados;
        double d2 = *(double *) n2.dados;
        if (d1 != 0 && d2 != 0.0) push(stack,n2);
        else if (d1 == 0 && d2 != 0.0) push(stack,n2);
        else if (d1 != 0 && d2 == 0.0) push(stack,n1);
        else push (stack, MAKE_DADOS_LONG(0));
    }
    else if (n1.tipo == DOUBLE && n2.tipo == LONG) {
        double d1 = *(double *) n1.dados;
        long d2 = *(long *) n2.dados;
        if (d1 != 0.0 && d2 != 0) push(stack,n2);
        else if (d1 == 0.0 && d2 != 0) push(stack,n2);
        else if (d1 != 0.0 && d2 == 0) push(stack,n1);
        else push (stack, MAKE_DADOS_LONG(0));
    }
    else  {
        long d1 = *(long *) n1.dados;
        long d2 = *(long *) n2.dados;
        if (d1 != 0 && d2 != 0) push(stack,n2);
        else if (d1 == 0 && d2 != 0) push(stack,n2);
        else if (d1 != 0 && d2 == 0) push(stack,n1);
        else push (stack, MAKE_DADOS_LONG(0));

    }
}


// e<
/**
 * \brief Compara o menor entre dois valores
 *
 * @param *stack que vai sofrer modificações
 * @returns o menor valor inserido
 */
void emenor (STACK *stack){
    DADOS n1 = pop (stack);
    DADOS n2 = pop (stack);

    if (n1.tipo==DOUBLE && n2.tipo==DOUBLE){
        double d1 = *(double *) n1.dados;
        double d2 = *(double *) n2.dados;
        if (d2 < d1) push(stack,n2);
        else push (stack, n1);
    }
    else if (n1.tipo == LONG && n2.tipo == DOUBLE) {
        long d1 = *(long *) n1.dados;
        double d2 = *(double *) n2.dados;
        if (d2 < d1) push(stack,n2);
        else push (stack, n1);
    }
    else if (n1.tipo == DOUBLE && n2.tipo == LONG) {
        double d1 = *(double *) n1.dados;
        long d2 = *(long *) n2.dados;
        if (d2 < d1) push(stack,n2);
        else push (stack, n1);
    }
    else if (n2.tipo == STRING && n1.tipo == STRING) {
        char *d1 = (char*) n1.dados;
        char *d2 = (char*) n2.dados;
        if (d2 < d1) push(stack, n1);
        else push(stack, n2);
    }
    else  {
        long d1 = *(long *) n1.dados;
        long d2 = *(long *) n2.dados;
        if (d2 < d1) push(stack,n2);
        else push (stack, n1);
    }
}


// e>
/**
 * \brief Compara o maior entre dois valores
 *
 * @param *stack que vai sofrer modificações
 * @returns o maior valor inserido
 */
void eMaior (STACK *stack){
    DADOS n1 = pop(stack);
    DADOS n2 = pop(stack);

    if (n1.tipo==DOUBLE && n2.tipo==DOUBLE){
        double d1 = *(double *) n1.dados;
        double d2 = *(double *) n2.dados;
        if (d2 > d1) push(stack,n2);
        else push (stack, n1);
    }
    else if (n1.tipo == LONG && n2.tipo == DOUBLE) {
        long d1 = *(long *) n1.dados;
        double d2 = *(double *) n2.dados;
        if (d2 > d1) push(stack,n2);
        else push (stack, n1);
    }
    else if (n1.tipo == DOUBLE && n2.tipo == LONG) {
        double d1 = *(double *) n1.dados;
        long d2 = *(long *) n2.dados;
        if (d2 > d1) push(stack,n2);
        else push (stack, n1);
    }
    else if (n2.tipo == STRING && n1.tipo == STRING) {
        char *d1 = (char*) n1.dados;
        char *d2 = (char*) n2.dados;
        if (d2 > d1) push(stack, n1);
        else push(stack, n2);
    }
    else  {
        long d1 = *(long *) n1.dados;
        long d2 = *(long *) n2.dados;
        if (d2 > d1) push(stack,n2);
        else push (stack, n1);
    }
}




// ?
/**
 * \brief Dados 3 valores verifica a condição (!=0 ou é vazio) no topo da stack
 * 
 * @param *stack que vai sofrer modificações
 */
void ptInterr (STACK *stack){
    DADOS n1= pop (stack);
    DADOS n2 = pop (stack);
    DADOS n3 = pop (stack);
    if (n3.tipo == ARRAY) {
        STACK *s = (STACK *)n3.dados;
        if (is_empty(s)) push(stack,n1);
        else push(stack,n2);
    }
    else if (n3.tipo == LONG) {
        long d3 = *(long *) n3.dados;
        if (d3 != 0) push (stack, n2);
        else push (stack,n1);
    }
    else if (n3.tipo == DOUBLE) {
        double d3 = *(double *) n3.dados;
        if (d3 != 0.0) push (stack, n2);
        else push (stack,n1);
    }
    else {
        if (n3.dados != 0) push (stack, n2);
        else push (stack,n1);
    }
}


/**\brief Verifica se o caracter introduzido é uma variável
 * 
 * @param x caracter introduzido
 * @returns o valor lógico da condição
 */
int Evariavel (char x) {
    if (x<= 'Z' && x>= 'A') return 1;
    else return 0;
}


/**
 * \brief Função de manipulação das variáveis
 * 
 * @param token correspondente às variáveis
 * @param *stack que vai sofrer modificações
 */
void handleVariable(char* token, STACK *stack){
    if (strlen (token)==1){
        if (token[0]>='A'&& token [0]<='Z'){
            if (stack->var[token[0]-'A'].t == STRING)
                push(stack, MAKE_DADOS_STRING(stack->var[token[0]-'A'].v.w));
            else if (stack->var[token[0]-'A'].t == DOUBLE)
                push(stack, MAKE_DADOS_DOUBLE(stack->var[token[0]-'A'].v.z));
            else if (stack->var[token[0]-'A'].t == CHAR)
                push(stack, MAKE_DADOS_CHAR(stack->var[token[0]-'A'].v.y));
            else
                push(stack, MAKE_DADOS_LONG(stack->var[token[0]-'A'].v.y));
        }
    }
    else if (strlen (token)==2 && token[0]== ':'){
        if (token[1]>='A'&& token [1]<='Z'){
            DADOS u= pop(stack);
            stack->var[token[1]-'A'].t= u.tipo;
            if (u.tipo == STRING) {
                char *a;
                a = strdup((char*)u.dados);
                stack->var[token[1]-'A'].v.w= (char *)a;
            }
            else if (u.tipo == DOUBLE) {
                stack->var[token[1]-'A'].v.z= *(double *)u.dados;
            }
            else if (u.tipo == CHAR) {
                stack->var[token[1]-'A'].v.y= *(char *)u.dados;
            }
            else {
                stack->var[token[1]-'A'].v.x= *(long *)u.dados;
            }
            push (stack,u);
        }
    }
}