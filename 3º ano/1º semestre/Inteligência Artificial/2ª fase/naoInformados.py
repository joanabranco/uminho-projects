import sys
from collections import deque
import math
from queue import Queue
from  arestas import Arestas
from matrix import Matriz

class NaoInformados():
    def __init__(self, arr):
        arestas =Arestas()
        self.m_graph = arestas.arestinhasParaGrafo(arr) 

    def get_arc_cost(self, node1, node2):
        custoT = math.inf
        a = self.m_graph[node1]  # lista de arestas para aquele nodo
        for (nodo, custo) in a:
            if nodo == node2:
                custoT = custo
        return custoT

    def calcula_custo(self, caminho):
        teste = caminho
        custo = 0
        i = 0
        while i + 1 < len(teste):
            custo = custo + self.get_arc_cost(teste[i], teste[i + 1])
            i = i + 1
        return custo
    
    def verificaDFSfins(self, start, end, path, visited):
        path.append(start)
        visited.add(start)
        if start == end:
            custoT = self.calcula_custo(path)
            return (end, custoT)
        for (adjacente, peso) in self.m_graph[start]:
                if (peso == 25 and adjacente not in visited): #parede - tem de voltar para trás
                        visited.add(adjacente) #adiciona na mesma à lista de visitados
                        continue
                if adjacente not in visited:
                        resultado = self.verificaDFSfins(adjacente,end, path, visited)
                        if resultado is not None:
                            return resultado
        path.pop() 
        return None
    
    ##############
    #    DFS     #
    ##############
    def procura_DFS(self, start, end, path, visited):
        path.append(start)
        visited.add(start)
        if start == end:
            custoT = self.calcula_custo(path)
            print ("A procura DFS entre a posição inicial e final é:",path,"com o custo",custoT)
            print(" ")
            print ("Sendo que o caminho percorrido foi:", visited)
            #visited=set()
            return (path, custoT)
        for (adjacente, peso) in self.m_graph[start]:
                if (peso == 25 and adjacente not in visited): #parede - tem de voltar para trás
                        visited.add(adjacente) #adiciona na mesma à lista de visitados
                        continue
                if adjacente not in visited:
                        resultado = self.procura_DFS(adjacente,end, path, visited)
                        if resultado is not None:
                            return resultado
        path.pop() 
        return None
    
    def verificaBFSfins(self, start, end):
        nodofinal = end
        # definir nodos visitados para evitar ciclos
        visited = set()
        fila = Queue()
        # adicionar o nodo inicial à fila e aos visitados
        fila.put(start)
        visited.add(start)
        # garantir que o start node nao tem pais...
        parent = dict()
        parent[start] = None
        path_found = False
        while not fila.empty() and path_found == False:
            nodo_atual = fila.get()
            if nodo_atual == end:
                path_found = True
            else:
                for (adjacente, peso) in self.m_graph[nodo_atual]:
                    if (peso == 25 and adjacente not in visited): #parede - tem de voltar para trás
                            visited.add(adjacente) #adiciona na mesma à lista de visitados
                            continue
                    if adjacente not in visited:
                        fila.put(adjacente)
                        parent[adjacente] = nodo_atual
                        visited.add(adjacente)
        path = []
        if path_found:
            path.append(end)
            while parent[end] is not None:
                path.append(parent[end])
                end = parent[end]
            path.reverse()
            custo = self.calcula_custo(path)
        return (nodofinal,custo)

    ##############
    #     BFS    #
    ##############
    def procura_BFS(self, start, end):
        # definir nodos visitados para evitar ciclos
        visited = set()
        fila = Queue()
        # adicionar o nodo inicial à fila e aos visitados
        fila.put(start)
        visited.add(start)
        # garantir que o start node nao tem pais...
        parent = dict()
        parent[start] = None
        path_found = False
        while not fila.empty() and path_found == False:
            nodo_atual = fila.get()
            if nodo_atual == end:
                path_found = True
            else:
                for (adjacente, peso) in self.m_graph[nodo_atual]:
                    if (peso == 25 and adjacente not in visited): #parede - tem de voltar para trás
                            visited.add(adjacente) #adiciona na mesma à lista de visitados
                            continue
                    if adjacente not in visited:
                        fila.put(adjacente)
                        parent[adjacente] = nodo_atual
                        visited.add(adjacente)
        path = []
        if path_found:
            path.append(end)
            while parent[end] is not None:
                path.append(parent[end])
                end = parent[end]
            path.reverse()
            custo = self.calcula_custo(path)
        print ("A procura BFS entre a posição inicial e final é:",path,"com custo",custo)
        print(" ")
        print ("Sendo que o caminho percorrido foi:", visited)
        return (path, custo)
