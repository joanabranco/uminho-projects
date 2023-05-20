import queue
from matrix import Matriz

# Classe que constrói o grafo como dicionário
class Dictionary():
    def __init__(self):
        self.grafo = {}

    # escrita do grafo em string
    def __str__(self):
        out = ""
        for key in self.grafo.keys():
            out = out + "node" + str(key) + ": " + str(self.grafo[key]) + "\n"
            return out

    #lista de listas representativas do circuito
    def listaToM(self, arr):
        x = arr
        x = [list(i) for i in x]
        # remove os espaços em branco da matriz
        return [[instance for instance in sublist if not instance.isspace()] for sublist in x]

    # verifica se as posições estão dentro da pista
    def dentroDaPista(self, arr, pos):
        matriz = Matriz()
        lista = matriz.returnPositionsOfMatrix(arr)

        if list(pos) in lista:
            return True
        else:
            return False
        """""""""
        matriz=listaToM(arr)
        lista= matriz[0]# primeira linha da matriz-- precisamos dela para saber o tamanho da linha
        nrColunas=len(lista)
        nrLinhas=len(matriz)
        altura = len(lofl)  #limite da pista em altura (coluna)
        compr = len(lofl[0]) #limite da pista em comprimento (linha)
       #c = (compr//2) #número inteiro de espaços na linha
    
        return (pos[0] < compr and pos[0] >= 0 and pos[1] >= 0 and pos[1] < altura)"""

    # verifica se a posição é parede
    def eParede(self, lofl, pos):  # próxima posição é representada por pos=(x,y)
        return (lofl[pos[0]][pos[1]] == 'X')

    # calcula as próximas posições de uma dada posição tendo em consideração à velocidade do jogador
    def proxPos(self, lofl, arr, posicao, vel):
        adj = [(-1, -1), (-1, 0), (-1, 1), (0, 0),(0, 1), (0, -1), (1, 0), (1, -1), (1, 1)]
        filhos = []
        custoP = 0

        # calcula cada possibilidade de nodos adjacentes
        for a in adj:
            x = posicao[0] + a[0] + vel[0]
            y = posicao[1] + a[1] + vel[1]
            prox = (x, y)
            if (x != posicao[0] or y != posicao[1]):
                if ((self.dentroDaPista(arr, prox))):  # garante que está dentro da pista

                    if (self.eParede(lofl, prox)):  # vai contra parede
                        custoP = 25
                        # vel=(0,0)

                    else:  # é pista
                        custoP = 1

                    # acrescenta uma posição adjacente
                    filhos.append((prox, custoP))
        return filhos

    def makeGrafo(self, arr, pInicio):
        lofl = self.listaToM(arr)  # lista de listas
        naoVisitado = [(pInicio)]
        while naoVisitado != []:
            pos = naoVisitado.pop(0)

            # adiciona nodo ao grafo
            if (pos not in self.grafo.keys()):
                self.grafo[pos] = []

                # calcular filhos
                # prox devolve a posição e o custo respetivo
                prox = self.proxPos(lofl, arr, pos, (0, 0))
                for each in prox:
                    #if each[1] == 1:
                        naoVisitado.append(each[0])

                # adiciona pos como chave e filhos ao grafo
                self.grafo[pos].append(prox)

        return self.grafo
