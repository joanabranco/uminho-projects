/**
 * @file Ficheiro com as funções principais do projeto
 */

#ifndef MAIN_H_INCLUDED
#define MAIN_H_INCLUDED

char *getstring(char *line); /**< Procura a string na linha inserida*/

char *get_token(char *line, char **rest); /**< Procura o token na linha inserida*/

void parse (char *line, STACK *stack); /**< É a função principal do programa*/

#endif //MAIN_H_INCLUDED
