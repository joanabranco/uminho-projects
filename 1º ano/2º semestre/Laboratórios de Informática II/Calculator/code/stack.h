/**
 * @file Ficheiro que contém as funções executadas para a stack
 */

#ifndef STACK_H_INCLUDED
#define STACK_H_INCLUDED

/**
 * \enum tipo
 * \brief Diferentes tipos para as variáveis
 */
typedef enum tipo{
    LONG, /**< tipo long*/
    DOUBLE, /**< tipo double*/
    CHAR, /**< tipo char*/
    STRING,/**< tipo string*/
    ARRAY/**< tipo array*/
} TIPO; /**< representa os tipos*/

/**
 * \union dados
 * \brief Diferentes tipos para os valores
 */
typedef union dados{
    long x;   /**< valores x são do tipo long*/
    char y;   /**< valores y são do tipo char*/
    double z; /**< valores z são do tipo double*/
    char *w;  /**< valores w são do tipo string*/
} VALOR;      /**< representa os valores*/

/**
 * \struct variaveis
 * \brief É a estrutura que vai ser usada para as variáveis
 */
typedef struct variaveis{
    TIPO t;  /**< tipos das variáveis*/
    VALOR v; /**< valores das variáveis*/
} VAR;       /**< representa as variáveis*/

/**
 * \struct inicial
 * \brief É a estrutura inicial
 */
typedef struct inicial{
    TIPO tipo;   /**< todos os tipos*/
    void *dados; /**< todos os dados*/
} DADOS;         /**< representa os dados*/

/**
 * \struct stack
 * \brief É a estrutura que forma a stack
 */
typedef struct stack{
    DADOS *stack; /**< dados na stack*/
    int size;     /**< tamanho da stack*/
    int top;      /**< topo da stack*/
    VAR *var;  /**< array das variáveis*/
} STACK;          /**< representa a stack*/

STACK *create_stack();

void push(STACK *s, DADOS elem); /**< Adiciona um elemento dado ao topo da stack*/

void print_stack(STACK *s); /**< Imprime a stack*/

void print_array(STACK *s); /**< Imprime o array*/

DADOS pop(STACK *s); /**< Retira elemento da stack*/

DADOS top(STACK *s); /**< Indica qual o próximo elemento a ser retirado da stack*/

int is_empty(STACK *s); /**< Verifica se a stack está vazia*/

DADOS MAKE_DADOS_LONG(long v); /**< Produz dados do tipo long*/

DADOS MAKE_DADOS_DOUBLE(double v); /**< Produz dados do tipo double*/

DADOS MAKE_DADOS_CHAR(char v); /**< Produz dados do tipo char*/

DADOS MAKE_DADOS_STRING(char *s); /**< Produz dados do tipo string*/

DADOS MAKE_DADOS_ARRAY(STACK *s); /**< Produz dados do tipo array*/

#endif //MAIN_C_STACK_H