/**
 * @file Ficheiro com as funções principais do projeto
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <assert.h>
#include "stack.h"
#include "guiao1.h"
#include "guiao2.h"
#include "guiao3.h"
#include "guiao4.h"
#include "guiao5.h"

/**
 * \brief Procura a string na linha inserida  
 * 
 * @param line a linha inserida
 * @returns a string inserida
 */
char *getstring(char *line) {
    line++;
    int i;
    char *result = strdup(line);
    for (i = 0; line[i] != '"'; i++) ;
    result[i] = '\0';
    return result;
}

/**
 * \brief Procura o token na linha inserida
 * 
 * @param line a linha inserida
 * @param **rest parte restante da linha inserida
 * @returns o token
 */
char *get_token(char *line, char **rest) {
    int i;
    char*token = strdup(line);
    if (token[0] == '"') {
        for(i = 0;token[i] != '\0' && token[i+1] != '"'; i++);
        token[i+2] = '\0';
        *rest = strdup(2 + line + i);
    }
    else if (token[0] == '{') {
        for(i = 0;token[i]!='\0' && token[i] != '}'; i++);
        token[i+1] = '\0';
        *rest = strdup(line + i + 1);
    }
    else {
        for(i = 0;token[i]; i++){
            if(token[i] == ' ' || token[i] == '\n' || token[i] == '\t') break;
        }
        token[i] = '\0';
        *rest = strdup(1 + line + i);
    }

    return token;
}

/**
 * \brief Procura na linha do input o array
 * 
 * @param *line a linha inserida
 * @param **resto parte restante da linha inserida
 * @param *seps os separadores
 * @returns o array caso exista
 */
char *delim(char *line,char**resto,char* seps) {
    if(strcmp(seps,"[]")==0) {
        int i;
        char* array = strdup(line);
        for (i = 0; array[i] != '\0'; ++i) {
            if (array[i] == ']') {

                break;
            }
        }
        array[i] = '\0';
        *resto = strdup(line + i + 2);
        return array;
    }
    else return NULL;
}

/**
 * \brief Esta é a função principal do programa
 * 
 * @param line a linha lida e à qual vai ser aplicada o parse
 * @param *stack que vai sofrer modificações
 */
void parse (char *line, STACK *stack) {
    char *resto;
    for (char*token= get_token(line,&resto);line[0] != '\0'; token = get_token(line, &resto)){
        line = strdup(resto);
        char *sobra1;
        char *sobra2;
        long val_i = strtol(token, &sobra1, 10);
        double val_d = strtod(token,&sobra2);
        if (token[0] == '\0');
        else if(strlen(sobra1) == 0) {
            push(stack, MAKE_DADOS_LONG(val_i));
        }else if (strlen(sobra2) == 0) {
            push(stack,MAKE_DADOS_DOUBLE(val_d));
        }else if (strlen(token) == 1) {
            DADOS Y;
            DADOS X;
            if (token[0]=='l') {
                char *a;
                char reader[1024];
                assert(fgets(reader, 1024, stdin) != NULL);
                a = (char *)malloc(strlen(reader));
                strcpy(a, reader);
                push(stack, MAKE_DADOS_STRING(a));
                free(a);
            } else {
                STACK *s2 = (STACK *) malloc(sizeof (STACK));
                s2->top = 0;
                s2->size= 100;
                s2->stack = (DADOS *) calloc(s2->size, sizeof (DADOS));
                s2->var = stack->var;
                switch (Evariavel(token[0])) {
                    case 1:
                        handleVariable(token, stack);
                        break;
                    case 0:
                        switch (token[0]) {
                            case '{':
                                push(stack, MAKE_DADOS_STRING(get_token(token,&resto)));
                                break;
                            case ' ':
                                break;
                            case '[':
                                parse(delim(line,&resto,"[]"),s2);
                                line = strdup(resto);
                                push(stack, MAKE_DADOS_ARRAY(s2));
                                break;
                            case '+':
                                Y = pop(stack);
                                X = pop(stack);
                                if (Y.tipo == STRING || X.tipo == STRING || Y.tipo == ARRAY || X.tipo == ARRAY) push(stack,Concatea(X,Y));
                                else push(stack, SOMAR_DADOS(X,Y));
                                break;

                            case '*':
                                Y = pop(stack);
                                X = pop(stack);
                                if (X.tipo == STRING || X.tipo == ARRAY ) ConcateaMULT(stack,X,Y);
                                else push(stack, MULTIPLICAR_DADOS(X,Y));
                                break;

                            case ',':
                                X = pop(stack);
                                if (X.tipo == STRING || X.tipo == ARRAY ) push(stack, TAMANHO(X));
                                else RANGE(X,stack);
                                break;

                            case '-':
                                Y = pop(stack);
                                X = pop(stack);
                                push(stack, SUBTRAIR_DADOS(X,Y));
                                break;

                            case '/':
                                Y = pop(stack);
                                X = pop(stack);
                                if ( Y.tipo == STRING && X.tipo == STRING) {
                                    push(stack,X);
                                    splitString((char*)Y.dados,stack) ;
                                }
                                else {
                                    push(stack, DIVIDIR_DADOS(X,Y));
                                }
                                break;

                            case ')':
                                X = pop(stack);
                                if (X.tipo == STRING || X.tipo == ARRAY) REMULT(X,stack);
                                else push (stack, INCREMENTAR_DADOS (X));
                                break;

                            case '(':
                                X = pop(stack);
                                if (X.tipo == STRING || X.tipo == ARRAY) REMPRIM(X,stack);
                                else push (stack, DECREMENTAR_DADOS (X));
                                break;

                            case '%':
                                Y = pop(stack);
                                X = pop(stack);
                                push(stack, MODULO_DADOS(X,Y));
                                break;

                            case'#':
                                Y = pop(stack);
                                X = pop(stack);
                                if (X.tipo == STRING && Y.tipo == STRING)
                                    PROCURA(Y,X,stack);
                                else push(stack, ELEVADO_DADOS(X,Y));
                                break;

                            case '&':
                                Y = pop(stack);
                                X = pop(stack);
                                push(stack, CONJUNCAO_DADOS(X,Y));
                                break;

                            case '|':
                                Y = pop(stack);
                                X = pop(stack);
                                push(stack, DISJUNCAO_DADOS(X,Y));
                                break;

                            case '^':
                                Y = pop(stack);
                                X = pop(stack);
                                push(stack, XOR_DADOS(X,Y));
                                break;

                            case '~':
                                X = pop(stack);
                                if (X.tipo == ARRAY) {
                                    transfer(stack, (STACK *)X.dados);
                                }
                                else push(stack,NOT_DADOS (X));
                                break;

                            case '_':
                                DUPLICAR (stack);
                                break;

                            case '\\' :
                                RODAR_DOIS_ELEMENTOS(stack);
                                break;

                            case '@':
                                RODAR_TRES_ELEMENTOS(stack);
                                break;
                            case ';':
                                pop(stack);
                                break;
                            case '$':
                                COPIAR_N_ELEMENTO (stack);
                                break;

                            case 'i':
                                INT_CONVERTE(stack);
                                break;

                            case 'f':
                                DOUBLE_CONVERTE(stack);
                                break;

                            case 'c':
                                CHAR_CONVERTE(stack);
                                break;
                            case 't':
                                READLINE(stack);
                                break;

                            case '=':
                                igual(stack);
                                break;

                            case '<':
                                menor(stack);
                                break;

                            case '>':
                                maior(stack);
                                break;

                            case '!':
                                negacao(stack);
                                break;

                            case '?':
                                ptInterr(stack);
                                break;
                            default:
                                push(stack, MAKE_DADOS_CHAR(token[0]));
                        }
                        break;

                }

            }
        } else {
            switch (token[0]) {
                case 'e':
                    switch (token[1]) {
                        case '&':
                            eComercial(stack);
                            break;
                        case '|':
                            eBarra(stack);
                            break;
                        case '<':
                            emenor(stack);
                            break;
                        case '>':
                            eMaior(stack);
                            break;
                    }
                    break;
                case ':':
                    handleVariable(token, stack);
                    break;
                case '"':
                    push(stack,MAKE_DADOS_STRING(getstring(token)));
                    break;
                case 'S':
                    if (token[1] == '/') splitString(" ",stack);
                    break;
                case 'N':
                    if (token[1] == '/') splitString("\n",stack);
                    break;

                default:
                    push(stack,MAKE_DADOS_STRING(token));
            }
        }
    }
}


/**
 * \brief Esta é a função principal do programa
 * 
 * @returns o valor zero
 */
int main() {

    char line [10240];
    assert ( fgets(line,10240,stdin) !=NULL);
    assert ( line [strlen(line)-1]== '\n'  );
    STACK *s = create_stack();
    parse(line, s);
    print_stack(s);



    return 0;
}
