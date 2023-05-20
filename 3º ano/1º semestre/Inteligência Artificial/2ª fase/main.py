from matrix import Matriz
from arestas import Arestas
from dictionary import Dictionary
from naoInformados import NaoInformados
from informados import Informados


def strike(text):
    return ''.join([u'\u0336{}'.format(c) for c in text])


def main():
    # leitura e representação do circuito do ficheiro txt
    file1 = open('./circuitos/circuito.txt', 'r')
    file2 = open('./circuitos/circuito1.txt', 'r')
    file3 = open('./circuitos/circuito2.txt', 'r')
    file4 = open('./circuitos/circuito3.txt', 'r')
    leitura = file1.readlines()
    leitura1 = file2.readlines()
    leitura2 = file3.readlines()
    leitura3 = file4.readlines()

    arr = []
    for line in leitura:
        arr.append(line.strip())  # para remover o \n

    arr1 = []
    for line in leitura1:
        arr1.append(line.strip())  # para remover o \n

    arr2 = []
    for line in leitura2:
        arr2.append(line.strip())  # para remover o \n

    arr3 = []
    for line in leitura3:
        arr3.append(line.strip())  # para remover o \n

    c = -1
    matriz = Matriz()
    arestas = Arestas()
    dict = Dictionary()

    circuitos = [arr, arr1, arr2, arr3]

    while c != 0:
        print("########## BEM VINDO AO VECTOR RACE  ##########")
        print("  ")
        print("########## MENU CIRCUITOS ##########")
        print("1 -> Circuito 1 ")
        print("2 -> Circuito 2")
        print("3 -> Circuito 3 ")
        print("4 -> Circuito 4 ")
        print("0 -> Sair")
        print("#####################################")
        c = int(input("Indique a opção pretendida-> "))
        if c != 0:
            saida2 = -1
            opcao = -1

            while saida2 != 0 and opcao != 0:
                print("    ")
                print("###### MENU CIRCUITO ", c, " ######")
                print("1 -> Gerar o Circuito ")
                print("2 -> Representar a pista em forma de grafo")
                print("3 -> Ambiente Competitivo")
                print("0 -> Voltar atrás")
                print("#####################################")
                opcao = int(input("Indique a opção pretendida-> "))

                if opcao == 1:
                    matriz.imprimeCircuito(circuitos[c-1])
                if opcao == 2:
                    l = arestas.getEdges(circuitos[c-1])
                    [print(i) for i in l]

                njog = 0
                j = 1

                if opcao == 3:
                    njog = int(
                        input("Indique o número de jogadores (entre 1 e 4)-> "))

                printDFS = 0
                printBFS = 0
                printGreedy = 0
                printA = 0

                while j <= njog and njog <= 4:
                    print("   ")
                    print("###### MENU JOGADOR ", j, " ######")
                    print("###### Selecione entre os algoritmos disponíveis ######")
                    if (printDFS == 0): print("1 -> Pesquisa DFS")
                    else: print(strike("1 -> Pesquisa DFS"))
                    if (printBFS == 0): print("2 -> Pesquisa BFS")
                    else: print(strike("2 -> Pesquisa BFS"))
                    if (printGreedy == 0): print("3 -> Pesquisa Greedy")
                    else: print(strike("3 -> Pesquisa Greedy"))
                    if (printA == 0): print("4 -> Pesquisa A*")
                    else: print(strike("4 -> Pesquisa A*"))
                    print("0 -> Reiniciar")
                    print("##############################################")
                    saida2 = int(input("Introduza a sua opção-> "))

                    print("    ")
                    if saida2 == 0: break

                    if saida2 == 1 and printDFS == 0:
                        inicio = matriz.encontraPosicaoInicial(circuitos[c-1])
                        fins = matriz.encontraPosicoesFinais(circuitos[c-1])
                        grafo = NaoInformados(circuitos[c-1])
                        path = []
                        visited = set()
                        mylist = []
                        for i in fins:
                            path2 = []
                            visited2 = set()
                            f = grafo.verificaDFSfins(inicio, i, path2, visited2)
                            mylist.append(f)
                        menor = 10000
                        dest = (0, 0)
                        for i in mylist:
                            if (i[1] < menor):
                                dest = i[0]
                                menor = i[1]
                        caminho = grafo.procura_DFS(inicio, dest, path, visited)
                        
                        input("Enter para continuar...")
                        matriz.playPath(dict.listaToM(circuitos[c-1]),caminho[0][0], caminho[0])
                        printDFS = 1

                    if saida2 == 2 and printBFS == 0:
                        inicio = matriz.encontraPosicaoInicial(circuitos[c-1])
                        fins = matriz.encontraPosicoesFinais(circuitos[c-1])
                        grafo = NaoInformados(circuitos[c-1])
                        mylist = []
                        for i in fins:
                            f = grafo.verificaBFSfins(inicio, i)
                            mylist.append(f)
                        menor = 10000
                        dest = (0, 0)
                        for i in mylist:
                            if (i[1] < menor):
                                dest = i[0]
                                menor = i[1]
                        caminho = grafo.procura_BFS(inicio, dest)
                        input("Enter para continuar...")
                        matriz.playPath(dict.listaToM(circuitos[c-1]),caminho[0][0], caminho[0])
                        
                        printBFS = 1

                    if saida2 == 3 and printGreedy == 0:
                        inicio = matriz.encontraPosicaoInicial(circuitos[c-1])
                        grafo = dict.makeGrafo(circuitos[c-1], inicio)
                        fins = matriz.encontraPosicoesFinais(circuitos[c-1])
                        inf = Informados()

                        greedy = inf.mGreedy(dict, grafo, circuitos[c-1], inicio, fins)
                        input("Enter para continuar...")
                        matriz.playPath(dict.listaToM(circuitos[c-1]),greedy[0][0], greedy[0])
                        
                        printGreedy = 1
                    
                    if saida2 == 4 and printA == 0:
                        inicio = matriz.encontraPosicaoInicial(circuitos[c-1])
                        grafo = dict.makeGrafo(circuitos[c-1], inicio)
                        fins = matriz.encontraPosicoesFinais(circuitos[c-1])
                        inf = Informados()

                        aStar = inf.mAStar(dict, grafo, circuitos[c-1], inicio, fins)
                        input("Enter para continuar...")
                        matriz.playPath(dict.listaToM(circuitos[c-1]),aStar[0][0], aStar[0])
                        
                        printA = 1
                    j = j+1

            saida2 = -1
            c = -1
        print("A sair ...")


if __name__ == "__main__":
    main()
