# Python program for 
# validation of a graph
  
# import dictionary for graph
from matrix import Matriz
from collections import defaultdict
import networkx as nx


class Arestas():
    
    # adiciona uma aresta ao grafo
    l = defaultdict(list)
    weights = {} 
    
    def addEdge(self,arr,l,u,v):
        matriz = Matriz()
        custo = matriz.returnCustoOfaPos(arr,v)
        nodeCost = v,custo
        l[u].append(nodeCost)
         
    #gera arestas
    def generate_edges(self,graph):
        edges = []
        for node in graph:
            for neighbour in graph[node]:
                (edges.append((node, neighbour)))
        return edges
    
    # declarar o dicionário como grafo
    def dictToGraph(self,arr):
        matriz = Matriz()
        dict = matriz.getListofAdjencencies(arr)
        l =[]
        for key, values in dict.items():
            chave =key
            if(isinstance(values, list)):
                for value in values:
                    (self.addEdge(arr,self.l,chave,value)) 
            else:  (self.addEdge(arr,self.l,chave,value))
        return (self.generate_edges(self.l))
      
    #função usada para representar a pista como grafo    
    def getEdges(self, arr):
        l=self.dictToGraph(arr)
        newlist = []
        for i in l:
            inicio = i[0]
            tuplo = i[1]
            fim = tuplo[0]
            custo = tuplo [1]
            edge = (inicio,fim,custo)
            newlist.append(edge)
        return (newlist)
 
    # função que converte uma posição num vértice do grafo
    def turnTupleintoNumber (self,arr):
        l=self.getEdges(arr)
        newlist=[]
        for i in l:
            inicio = i[0]
            fim = i[1]
            custo= i[2]
            il=str(inicio[0])
            ic=str(inicio[1])
            fl=str(fim[0])
            fc=str(fim[1])
            newi=il+ic
            newf=fl+fc
            add=(int(newi),int(newf),custo)
            newlist.append(add)
        return newlist 

    def adjcenciasEcusto(self,arr,x_atual,y_atual):
        matriz = Matriz()
        list=[]
        if ([x_atual-1,y_atual]) in matriz.returnPositionsOfMatrix(arr): 
            anex = ((x_atual-1,y_atual),matriz.returnCustoOfaPos(arr,(x_atual-1,y_atual)))
            list.append(anex)
        if ([x_atual+1,y_atual]) in matriz.returnPositionsOfMatrix(arr):
            anex = ((x_atual+1,y_atual),matriz.returnCustoOfaPos(arr,(x_atual+1,y_atual)))
            list.append(anex)
        if ([x_atual,y_atual-1]) in matriz.returnPositionsOfMatrix(arr):
            anex= (x_atual,y_atual-1),matriz.returnCustoOfaPos(arr,(x_atual,y_atual-1))
            list.append(anex)
        if ([x_atual,y_atual+1]) in matriz.returnPositionsOfMatrix(arr):
            anex= (x_atual,y_atual+1),matriz.returnCustoOfaPos(arr,(x_atual,y_atual+1))
            list.append(anex)
        if ([x_atual-1,y_atual-1]) in matriz.returnPositionsOfMatrix(arr):
            anex = (x_atual-1,y_atual-1),matriz.returnCustoOfaPos(arr,(x_atual-1,y_atual-1))
            list.append(anex)
        if ([x_atual+1,y_atual-1]) in matriz.returnPositionsOfMatrix(arr):
            anex = (x_atual+1,y_atual-1),matriz.returnCustoOfaPos(arr,(x_atual+1,y_atual-1))
            list.append(anex)
        if ([x_atual-1,y_atual+1]) in matriz.returnPositionsOfMatrix(arr):
            anex = (x_atual-1,y_atual+1),matriz.returnCustoOfaPos(arr,(x_atual-1,y_atual+1))
            list.append(anex)
        if ([x_atual+1,y_atual+1]) in matriz.returnPositionsOfMatrix(arr):
            anex = (x_atual+1,y_atual+1),matriz.returnCustoOfaPos(arr,(x_atual+1,y_atual+1))
            list.append(anex)
        #retorna a lista das posições adjacentes a uma dada cordenada
        return(list)
    
    def arestinhasParaGrafo(self,arr):
        matriz = Matriz()
        m=matriz.listaToMatriz(arr)
        lista = m[0]
        newAdjs=[]
        for i in range (len(m)): #colunas
            for j in range (len(lista)): #linhas
                #if (matriz[i][j]!= 'X'):
                    newAdjs.append([(i,j),self.adjcenciasEcusto(arr,i,j)])
        return(dict(newAdjs))