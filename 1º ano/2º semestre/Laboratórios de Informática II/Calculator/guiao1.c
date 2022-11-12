/**
 * @file Ficheiro que contém as funções relativas ao guião 1
 */

#include <math.h>
#include "guiao1.h"

/**
 * \brief Efetua a soma entre os dados inseridos, dependendo do seu tipo
 * 
 * @param x 1º valor recebido para realizar a operação de adição
 * @param y 2º valor recebido para realizar a operação de adição
 * @returns o resultado da operação no seu respetivo tipo
 */
DADOS SOMAR_DADOS(DADOS x, DADOS y) {
    DADOS r;
    if (x.tipo == DOUBLE && y.tipo == DOUBLE) {
        double a = *(double *) x.dados;
        double b = *(double *) y.dados;
        r = MAKE_DADOS_DOUBLE(a+b);
    } else if (x.tipo == LONG && y.tipo == DOUBLE) {
        long a = *(long *) x.dados;
        double b = *(double *) y.dados;
        r = MAKE_DADOS_DOUBLE(a+b);
    } else if (x.tipo == DOUBLE && y.tipo == LONG) {
        double a = *(double *) x.dados;
        long b = *(long *) y.dados;
        r = MAKE_DADOS_DOUBLE(a+b);
    } else {
        long a = *(long *) x.dados;
        long b = *(long *) y.dados;
        r = MAKE_DADOS_LONG(a+b);
    }
    return r;
}

/**
 * \brief Efetua a multiplicação entre os dados inseridos, dependendo do seu tipo
 * 
 * @param x 1º valor recebido para realizar a operação de multiplicação
 * @param y 2º valor recebido para realizar a operação de multiplicação
 * @returns o resultado da operação no seu respetivo tipo
 */
DADOS MULTIPLICAR_DADOS (DADOS x, DADOS y){
    DADOS r;
    if (x.tipo==DOUBLE && y.tipo==DOUBLE){
        double a= *(double *) x.dados;
        double b= *(double *) y.dados;
        r = MAKE_DADOS_DOUBLE (a*b);
    }
    else if (x.tipo == LONG && y.tipo == DOUBLE) {
        long a = *(long *) x.dados;
        double b = *(double *) y.dados;
        r = MAKE_DADOS_DOUBLE(a*b);
    }
    else if (x.tipo == DOUBLE && y.tipo == LONG) {
        double a = *(double *) x.dados;
        long b = *(long *) y.dados;
        r = MAKE_DADOS_DOUBLE(a*b);
    }
    else {
        long a = *(long *) x.dados;
        long b = *(long *) y.dados;
        r = MAKE_DADOS_LONG(a*b);
    }
    return r;
}

/**
 * \brief Efetua a subtração entre os dados inseridos, dependendo do seu tipo
 * 
 * @param x 1º valor recebido para realizar a operação de subtração
 * @param y 2º valor recebido para realizar a operação de subtração
 * @returns o resultado da operação no seu respetivo tipo
 */
DADOS SUBTRAIR_DADOS (DADOS x, DADOS y){
    DADOS r;
    if (x.tipo==DOUBLE && y.tipo==DOUBLE){
        double a= *(double *) x.dados;
        double b= *(double *) y.dados;
        r = MAKE_DADOS_DOUBLE (a-b);
    }
    else if (x.tipo == LONG && y.tipo == DOUBLE) {
        long a = *(long *) x.dados;
        double b = *(double *) y.dados;
        r = MAKE_DADOS_DOUBLE(a-b);
    }
    else if (x.tipo == DOUBLE && y.tipo == LONG) {
        double a = *(double *) x.dados;
        long b = *(long *) y.dados;
        r = MAKE_DADOS_DOUBLE(a-b);
    }
    else {
        long a = *(long *) x.dados;
        long b = *(long *) y.dados;
        r = MAKE_DADOS_LONG(a-b);
    }
    return r;
}

/**
 * \brief Efetua a divisão entre os dados inseridos, dependendo do seu tipo
 * 
 * @param x 1º valor recebido para realizar a operação de divisão
 * @param y 2º valor recebido para realizar a operação de divisão
 * @returns o resultado da operação no seu respetivo tipo
 */
DADOS DIVIDIR_DADOS (DADOS x, DADOS y){
    DADOS r;
    if (x.tipo==DOUBLE && y.tipo==DOUBLE){
        double a= *(double *) x.dados;
        double b= *(double *) y.dados;
        r = MAKE_DADOS_DOUBLE (a/b);
    }
    else if (x.tipo == LONG && y.tipo == DOUBLE) {
        long a = *(long *) x.dados;
        double b = *(double *) y.dados;
        r = MAKE_DADOS_DOUBLE(a/b);
    }
    else if (x.tipo == DOUBLE && y.tipo == LONG) {
        double a = *(double *) x.dados;
        long b = *(long *) y.dados;
        r = MAKE_DADOS_DOUBLE(a/b);
    }
    else {
        long a = *(long *) x.dados;
        long b = *(long *) y.dados;
        r = MAKE_DADOS_LONG(a/b);
    }
    return r;
}

/**
 * \brief Efetua a incrementação do dado inserido, dependendo do seu tipo
 * 
 * @param x 1º valor recebido para realizar a operação de incrementação
 * @param y 2º valor recebido para realizar a operação de incrementação
 * @returns o resultado da operação no seu respetivo tipo
 */
DADOS INCREMENTAR_DADOS (DADOS x){
    DADOS r;
    if (x.tipo==DOUBLE){
        double a= *(double *) x.dados;
        r = MAKE_DADOS_DOUBLE (a+1);
    }
    else if (x.tipo==LONG) {
        long a= *(long *) x.dados;
        r = MAKE_DADOS_LONG (a+1);
    } else {
        char a = *(char *) x.dados;
        r = MAKE_DADOS_CHAR(a+1);
    }
    return r;
}

/**
 * \brief Efetua a decrementação do dado inserido, dependendo do seu tipo
 * 
 * @param x 1º valor recebido para realizar a operação de decrementação
 * @param y 2º valor recebido para realizar a operação de decrementação
 * @returns o resultado da operação no seu respetivo tipo
 */
DADOS DECREMENTAR_DADOS (DADOS x){
    DADOS r;
    if (x.tipo==DOUBLE){
        double a= *(double *) x.dados;
        r = MAKE_DADOS_DOUBLE (a-1);
    }
    else if (x.tipo==LONG) {
        long a= *(long *) x.dados;
        r = MAKE_DADOS_LONG (a-1);
    } else {
        char a = *(char *) x.dados;
        r = MAKE_DADOS_CHAR(a-1);
    }
    return r;
}

/**
 * \brief Efetua o módulo do dado inserido, dependendo do seu tipo
 * 
 * @param x 1º valor recebido para realizar a operação do módulo
 * @param y 2º valor recebido para realizar a operação do módulo
 * @returns o resultado da operação no seu respetivo tipo
 */
DADOS MODULO_DADOS (DADOS x, DADOS y){
    DADOS r;
    if (x.tipo==DOUBLE && y.tipo==DOUBLE){
        double a= *(double *) x.dados;
        double b= *(double *) y.dados;
        r = MAKE_DADOS_DOUBLE (remainder(a,b));
    }
    else if (x.tipo == LONG && y.tipo == DOUBLE) {
        long a = *(long *) x.dados;
        double b = *(double *) y.dados;
        r = MAKE_DADOS_DOUBLE (remainder(a,b));
    }
    else if (x.tipo == DOUBLE && y.tipo == LONG) {
        double a = *(double *) x.dados;
        long b = *(long *) y.dados;
        r = MAKE_DADOS_DOUBLE (remainder(a,b));
    }
    else {
        long a = *(long *) x.dados;
        long b = *(long *) y.dados;
        r = MAKE_DADOS_LONG(a%b);
    }
    return r;
}

/**
 * \brief Efetua a exponenciação do dado inserido, dependendo do seu tipo
 * 
 * @param x 1º valor recebido para realizar a operação de exponenciação
 * @param y 2º valor recebido para realizar a operação de exponenciação
 * @returns o resultado da operação no seu respetivo tipo
 */
DADOS ELEVADO_DADOS (DADOS x, DADOS y){
    DADOS r;
    if (x.tipo==DOUBLE && y.tipo==DOUBLE){
        double a= *(double *) x.dados;
        double b= *(double *) y.dados;
        r = MAKE_DADOS_DOUBLE (pow(a,b));
    }
    else if (x.tipo == LONG && y.tipo == DOUBLE) {
        long a = *(long *) x.dados;
        double b = *(double *) y.dados;
        r = MAKE_DADOS_DOUBLE (pow(a,b));
    }
    else if (x.tipo == DOUBLE && y.tipo == LONG) {
        double a = *(double *) x.dados;
        long b = *(long *) y.dados;
        r = MAKE_DADOS_DOUBLE (pow(a,b));
    }
    else  {
        long a = *(long *) x.dados;
        long b = *(long *) y.dados;
        r = MAKE_DADOS_DOUBLE(pow(a,b));
    }
    return r;
}

/**
 * \brief Efetua a conjunção dos dados inseridos
 * 
 * @param x 1º valor recebido para realizar a operação de conjunção
 * @param y 2º valor recebido para realizar a operação de conjunção
 * @returns o resultado da operação no tipo long
 */
DADOS CONJUNCAO_DADOS (DADOS x, DADOS y){
    long a = *(long *) x.dados;
    long b = *(long *) y.dados;
    return MAKE_DADOS_LONG (a&b);
}

/**
 * \brief Efetua a disjunção dos dados inseridos
 * 
 * @param x 1º valor recebido para realizar a operação de disjunção
 * @param y 2º valor recebido para realizar a operação de disjunção
 * @returns o resultado da operação no tipo long
 */
DADOS DISJUNCAO_DADOS (DADOS x, DADOS y){
    long a = *(long *) x.dados;
    long b = *(long *) y.dados;
    return MAKE_DADOS_LONG(a|b);
}

/**
 * \brief Efetua a disjunção exclusiva dos dados inseridos
 * 
 * @param x 1º valor recebido para realizar a operação de ou-exclusivo
 * @param y 2º valor recebido para realizar a operação de ou-exclusivo
 * @returns o resultado da operação no tipo long
 */
DADOS XOR_DADOS(DADOS x, DADOS y) {
    long a = *(long *) x.dados;
    long b = *(long *) y.dados;
    return MAKE_DADOS_LONG(a^b);
}

/**
 * \brief Efetua a negação dos dados inseridos
 * 
 * @param x valor recebido para realizar a operação de negação
 * @returns o resultado da operação no tipo long
 */
DADOS NOT_DADOS (DADOS x){
    long a= *(long *) x.dados;
    return MAKE_DADOS_LONG (~a);
}