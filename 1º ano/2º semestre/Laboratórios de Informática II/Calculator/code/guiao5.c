/**
 * @file Ficheiro que contém as funções relativas ao guião 5
 */

#include <string.h>
#include <stdio.h>
#include <stdlib.h>
#include "guiao5.h"

/**
 * \brief Cria um bloco
 * 
 * @param *line a linha inserida
 * @param **resto a parte restante da linha inserida
 * @returns a linha
 */ 
char* get_bloco (char* line, char**resto) {
    int i;
    for (i = 0; i < (int)strlen(line); ++i) {
        if (line [i] == '}') break;
    }
    *resto = line;
    line [i+1] = '\0';
    return line;
}