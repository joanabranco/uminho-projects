from matrix import Matriz
from collections import defaultdict
from matrix import Matriz
from arestas import Arestas
import networkx as nx
import sys #sys.maxsize reports the platform's pointer size
from heapq import heappop, heappush
from collections import deque

#Classe que guarda os Nodos da Heap
class Nodo:
    def __init__(self, vertice, peso=0):
            self.vertice = vertice
            self.peso = peso
 #função que faz a operação less-than
    def __lt__(self, other):
        return self.peso < other.peso

#classe para representar o grafo
class oGrafo:
    def __init__(self, edges, n):
            #aloca memória para a lista de adjacencias
            self.listaAdjacencias = [[] for _ in range(n)]
            #adiciona arestas ao grafo - orientadas 
            for (source, dest, peso) in edges:
                self.listaAdjacencias[source].append((dest, peso))
    
    #função auxiliar para encontrar o caminho entre um nó e outro            
    def get_caminho(self,prev, i, caminho):
            if i >= 0:
                self.get_caminho(prev, prev[i], caminho)
                caminho.append(i)

    #aplica o algoritmo de Dijktra no grafo fornecido
    def encontraCaminhoMaisCurto(self,graph, source,fins, n):
        #cria uma heap minima e faz push da origem com distância a 0
        list = []
        heappush(list, Nodo(source))
        dist = [sys.maxsize] * n # a distância inicial desde a origem até ao vertice como infinita para já
        dist[source] = 0 #a distância da origem a si mesma é 0
        #lista que permite verificar se o custo mínimo já foi alcançado
        terminou = [False] * n
        terminou[source] = True
        prev = [-1] * n #guarda o nodo antecessor
        while list: #ciclo até a heap ficar vazia
            node = heappop(list) #remove e retorna o melhor vértice
            u = node.vertice  #get do vertice    
            #para cada nodo adjacente 
            for (v, peso) in graph.listaAdjacencias[u]:
                if not terminou[v] and (dist[u] + peso) < dist[v]:
                    dist[v] = dist[u] + peso
                    prev[v] = u
                    heappush(list, Nodo(v, dist[v]))
            #o vértice foi visitado, já não vamos selecioná-lo outra vez
            terminou[u] = True
        
        caminho = []
        custo = 100
        custos=[]
    
        for i in range(n):
            if i != source and dist[i] != sys.maxsize and i in fins:
                self.get_caminho(prev, i, caminho)
                custos.append(dist[i])
                caminho.clear()
        #print (custos)
        minimum = min(custos)
        verify = custos.count(minimum)
        found = 0
        for i in range(n): #se só houver um caminho mínimo
            if i != source and dist[i] != sys.maxsize and i in fins:
                caminho.clear()
                self.get_caminho(prev, i, caminho)
                if dist[i] == min(custos) and verify== 1: #se houver apenas um caminho com o custo mínimo
                    print (verify)
                    print(f'O caminho mais curto entre {source} e {i}, com custo = {dist[i]},  é = {caminho}')
                    caminho.clear() #limpa todas as entradas de uma lista
                elif dist[i] == min(custos) and verify>1 and found == 0: # se houver mais do que um caminho com o custo mínimo
                    found = 1 #imprime o 1 caminho
                    print(f'O caminho mais curto entre {source} e {i}, com custo = {dist[i]},  é = {caminho}')
                    
       
                    
       
