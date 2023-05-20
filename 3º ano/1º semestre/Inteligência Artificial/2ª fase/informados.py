from matrix import Matriz
from collections import defaultdict
from arestas import Arestas
import networkx as nx
from heapq import heappop, heappush
from collections import deque
import math
from dictionary import Dictionary

class Informados():
    def __init__(self):
        dict = Dictionary()

    # cálculo da distância em linha reta da posição atual à posição final
    def distanciaEuclidiana(self, pAt, pFi):
        dist = abs(pAt[0] - pFi[0]) + abs(pAt[1] - pFi[1])
        return dist

    # dado um caminho calcula o custo total do mesmo
    def calculaCusto(self, lofl, caminho):
        custoT = 0

        # percorre o caminho resultado do algoritmo
        for n in caminho:
            #verifica se é parede
            if (lofl[n[0]][n[1]]) == "X":
                custoT += 25
            else:
                #ou pista
                custoT += 1

        return custoT
    
    # calcula a distância em linha reta de qualquer ponto da matriz até à posição final
    def makeHeuristicas(self, matrix, fim):
        h = {}
        lista = matrix[0]
        finais = []
        for i in range(len(matrix)):  # colunas
            for j in range(len(lista)):  # linhas
                h[(i,j)] = self.distanciaEuclidiana((i,j),fim)
        return h

    # verifica se o salto entre duas posições é possível, se tiver paredes pelo meio dá uma alternativa
    def validaSalto (self,grafo,pI,pF,vel):
        div = max(abs(vel[0]), abs(vel[1]))
        
        inc = (float(vel[0]//div),float(vel[1]//div))
        pos = pI
        
        i = 0
        while i < div:
            newpos = (float(pos[0] + inc[0]),float(pos[1] + inc[1]))

            newposint = (int(newpos[0]),int(newpos[1]))

            graphadjs = grafo[pos][0]
            
            #print("pos=",pos)
            #print("newposint=",newposint)
            #print(graphadjs)
            
            for (v,cost) in graphadjs:
                if newposint == v and cost == 25:
                    return pos
                if newposint == v and cost == 1:
                    pos = newposint
            #print("nextiterpos=", pos)
            #print(" ")
            i = i+1
        return pos
        
        """#validar o caminho entre pI e pF
        #posição inicial
        parent = pI
        currposx = 0
        currposy = 0
        
        print("pI=",pI)
        print("pf=",pF)
        
        if vel[0] > 0: x = -1
        elif vel[0] < 0: x = 1
        else: x = 0
        
        if vel[1] > 0: y = -1
        elif vel[1] < 0: y = 1
        else: y = 0
        
        velx = vel[0]
        vely = vel[1]
        
        #ajuda a avançar (x,y) até à posição válida 


        while parent != pF and (velx,vely) != (0,0):
        #procurar próximo nodo consoante a velocidade
            if velx != 0:
                currposx = parent[0] - x
                velx = velx + x
            if vely != 0:
                currposy = parent[1] - y
                vely = vely + y
            currpos = (currposx,currposy)
            print("currpos = ",currpos)
            currset = grafo[parent]
            print(currset)
            
            if (currpos, 1) in currset:
                parent = currpos
            elif (currpos, 25) in currset:
                return parent
            for setvalue in currset:
                #setvalue representado por (posição, custo)
                if setvalue[0] == currpos and setvalue[1] == 25:
                    return parent
                if setvalue[0] == currpos and setvalue[1] == 1:
                    parent = currpos
        #retornar a posição válida
        return pF
            """
    # calcular o algoritmo Greedy para as diferentes posições finais
    def mGreedy (self,dict,grafo,arr,inicio,fins):
        #fins é a lista de posições finais
        m = 200
        cam=[]
        lP=[]

        for fim in fins: 
            res = self.greedy(dict,grafo,arr,inicio,fim)
            # se o custo do caminho atual for menor que o custo calculado até agora
            if res != None:
                if res[1] < m:
                    cam = res[0]
                    m = res[1]
                    lP = res[2]
                    

        print("A procura Greedy entre a posição inicial e final é:", cam, "com custo", m)
        print(" ")
        print ("Sendo que os nodos percorridos foram ", lP)
        
        return (cam,m,lP)
        
    ##############
    #   Greedy   #
    ##############
    def greedy(self, dict, grafo, arr, inicio, fim):
        # lista de nodos visitados, mas com vizinhos que ainda não foram todos visitados, começa com o  inicio
        open_list = set([inicio])
        # lista de nodos visitados mas vizinhos também já foram visitados
        closed_list = set([])

        # parents é um dicionário que mantém o antecessor(parent) de um nodo
        parents = {}
        parents[inicio] = inicio

        # velocidade inicial
        vel = (0, 0)

        #lista de listas que representam o circuito como uma matriz
        lofl = dict.listaToM(arr)
        listPercorrido = []
        
        heuristicas = self.makeHeuristicas(lofl,fim)

        while len(open_list) > 0:
            n = None
            menor = 1000.0

            for i in open_list:
                # encontrar nodo com a menor heuristica
                if heuristicas[i] <= menor:
                    menor = heuristicas[i]
                    n = i

            if n == None:
                print('Caminho não existe!')
                return None 
            
            # se o nodo corrente é o destino
            if n == fim:  # if n in fim
                
                reconstCam = []
                #parents[n] = parent
                while parents[n] != n:
                    #reconstruir caminho até ao nodo inicial
                    reconstCam.append(n)
                    #marcar o antecessor do nodo para a próxima iteração
                    n = parents[n]

                reconstCam.append(inicio)
                reconstCam.reverse()



                # retorna caminho, custo
                return (reconstCam, self.calculaCusto(lofl, reconstCam),listPercorrido)


            #se o nodo em questão não for filho do parent
            if (n,1) not in dict.proxPos(lofl, arr, parents[n], vel) and (n,25) not in dict.proxPos(lofl, arr, parents[n], vel):
                vel = (0,0)
            else:
                vel = (n[0]-parents[n][0],n[1]-parents[n][1]) #atribuir velocidade ao jogador
            

            # todas as posições seguintes possíveis do nodo atual
            for (m,cost) in dict.proxPos(lofl, arr, n, vel):                
                newvel = (m[0]-n[0],m[1]-n[1])
                newpos = self.validaSalto(grafo,n,m,newvel)
                # Se o nodo corrente nao esta na open nem na closed list e marcar o antecessor
                if newpos not in closed_list and newpos not in open_list:
                    #print(newpos)
                    open_list.add(newpos)
                    listPercorrido.append(newpos)
                    parents[newpos] = n
            
            # adicionar à closed_list todos os seus vizinhos foram inspecionados
            open_list.remove(n)
            closed_list.add(n)

        print('Caminho não existe!')
        return None
    
    # calcula o nodo com menor heurística
    def calcula_estima(self, estima):
        l = list(estima.keys())
        min_estima = estima[l[0]]
        node = l[0]
        for k, v in estima.items():
            if v < min_estima:
                min_estima = v
                node = k
        return node

    # calcular o algoritmo A* para as diferentes posições finais
    def mAStar (self,dict,grafo,arr,inicio,fins):
        #fins é a lista de posições finais
        m = 200
        cam=[]
        lP=[]
        for fim in fins: 
            res = self.aStar(dict,grafo,arr,inicio,fim)
            if res != None:
                # se o custo do caminho atual for menor que o custo calculado até agora
                if res[1] < m:
                    cam = res[0]
                    m = res[1]
                    lP = res[2]

        print("A procura A* entre a posição inicial e final é:", cam, "com custo", m)
        print(" ")
        print ("Sendo que os nodos percorridos foram ", lP)
        
        return (cam,m,lP)

    ##############
    #     A*     #
    ##############
    def aStar(self, dict, grafo, arr, inicio, fim):
        
        open_list = {inicio}
        closed_list = set([])

        # guarda o custo entre a posição inicial e a posição atual
        g = {}  

        g[inicio] = 0

        # parents é um dicionário que mantém o antecessor(parent) de um nodo
        parents = {}
        parents[inicio] = inicio

        # velocidade inicial
        vel = (0, 0)

        #lista de listas que representam o circuito como uma matriz
        lofl = dict.listaToM(arr)
        listPercorrido = []
        
        heuristicas = self.makeHeuristicas(lofl,fim)
        
        n = None
        while len(open_list) > 0:
            # procurar o nodo com menor valor
            calc_heurist = {}
            flag = 0
            for v in open_list:
                if n == None:
                    n = v
                else:
                    flag = 1
                    #calcular a heurística ( = custo acumulado  valor de heurísticas calculado)
                    calc_heurist[v] = g[v] + heuristicas[v]
            
            if flag == 1: #se o nodo já foi visitado e já foi calculada a sua heurística
                #atualizar com o nodo com menor valor de heurística
                min_estima = self.calcula_estima(calc_heurist)
                n = min_estima
            if n == None:
                print('Caminho não existe!')
                return None

            # se o nodo atual já foi o nodo final, reconstruir caminho
            if n == fim:
                reconstCam = []

                while parents[n] != n:
                    reconstCam.append(n)
                    n = parents[n]

                reconstCam.append(inicio)

                reconstCam.reverse()
                
                #print('Path found: {}'.format(reconstCam))
                return (reconstCam, self.calculaCusto(lofl, reconstCam), listPercorrido)


            # se o nodo (pista ou parede) em questão não for filho do parent
            if (n,1) not in dict.proxPos(lofl, arr, parents[n], vel) and (n,25) not in dict.proxPos(lofl, arr, parents[n], vel):
                vel = (0,0)
            else:
                vel = (n[0]-parents[n][0],n[1]-parents[n][1]) #atribuir velocidade ao jogador
            
            # para todos os seus nodos vizinhos
            for (m,cost) in dict.proxPos(lofl, arr, n, vel):  
                # se não estiver nem na open e closed, adicionar à open e n é parent de m
                if m not in open_list and m not in closed_list:
                    open_list.add(m)
                    parents[m] = n
                    g[m] = g[n] + cost
                    listPercorrido.append(m)

                else:
                    # verificar se é mais rápido visitar n e só depois m
                    if g[m] > g[n] + cost:
                        g[m] = g[n] + cost #atualizar dicionário g
                        parents[m] = n #atualizar lista de parents

                        if m in closed_list:
                            closed_list.remove(m)
                            open_list.add(m)

            # remover da open e adicionar à closed porque todos os nodos adjacentes foram visitados
            open_list.remove(n)
            closed_list.add(n)

        print('Caminho não existe!')
        return None
