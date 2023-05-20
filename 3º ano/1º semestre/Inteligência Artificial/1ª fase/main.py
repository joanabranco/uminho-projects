from matrix import Matriz
from arestas import Arestas
from newgrafo import Nodo
from newgrafo import oGrafo


        
def main():
    #leitura e representação do circuito do ficheiro txt
    file = open ('circuito.txt', 'r')
    leitura = file.readlines()
    arr=[]
    for line in leitura:
        arr.append(line.strip()) # para remover o \n
        
    saida = -1
    matriz = Matriz()
    arestas = Arestas()

    
    while saida != 0:
        print("1 -> Gerar Circuito ")
        print("2 -> Representar pista em forma de grafo")
        print("3 -> Obter o menor caminho - Problema de Custo Uniforme")
        saida = int(input("Introduza a sua opção-> "))
        if saida == 1:
            matriz.imprimeCircuito(arr)
        if saida == 2:
            l= arestas.getEdges(arr)
            [print(i) for i in l]
        if saida == 3:
            n= matriz.returnPositionsOfMatrix(arr)
            tamanho = len(n)
            edges= arestas.turnTupleintoNumber(arr)
            grafito = oGrafo(edges,tamanho)
            inicio = matriz.encontraPosicaoInicial(arr) 
            fins = matriz.finalsPositionsIntoIntegers(arr)
            il=str(inicio[0])
            ic=str(inicio[1])
            newi=il+ic
            grafito=oGrafo(edges,tamanho)
            grafito.encontraCaminhoMaisCurto(grafito,int(newi),fins,tamanho)
      
   
if __name__ == "__main__":
    main() 
    