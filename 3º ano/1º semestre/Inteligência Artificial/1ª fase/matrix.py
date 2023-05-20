import queue
class Matriz():
    
    #função que imprime o circuito no terminal
    def imprimeCircuito(self,arr):
        for i  in range(0, len(arr)):
            print (arr[i])

    #função que converte a lista lida do .txt numa matrix
    def listaToMatriz(self,arr):
        x=arr
        x = [list (i) for i in x]
        #print (x)
        return [[instance for instance in sublist if not instance.isspace()] for sublist in x] #remove os espaços em branco da matriz

    #função que retorna os indices da matriz
    def returnPositionsOfMatrix(self,arr):
        matriz=self.listaToMatriz(arr)
        lista= matriz[0]# primeira linha da matriz-- precisamos dela para saber o tamanho da linha
        #print (lista)
        finais =[]
        for i in range (len(matriz)): #colunas
            for j in range (len(lista)): #linhas
                finais.append([i,j])
        return finais
    
    #funcao que retorna as coordenadas da posicao inicial
    def encontraPosicaoInicial(self,arr):
        inicio =()
        matriz=self.listaToMatriz(arr)
        lista= matriz[0]
        for i in range (len(matriz)): #colunas
            for j in range (len(lista)): #linhas
                if (matriz[i][j] == 'P'): inicio=(i,j)
        return inicio

    #funcao que retorna as coordenadas das possíveis metas
    def encontraPosicoesFinais (self,arr):
        matriz=self.listaToMatriz(arr)
        lista= matriz[0]# primeira linha da matriz-- precisamos dela para saber o tamanho da linha
        #print (lista)
        finais =[]
        for i in range (len(matriz)): #colunas
            for j in range (len(lista)): #linhas
                if (matriz[i][j] == 'F'): finais.append((i,j))
        return finais
        
    #array 2d que guarda o custo de cada posição
    def custoPos(self,arr):
        matriz=self.listaToMatriz(arr)
        lista = matriz[0]
        custos =[]
        for i in range (len(matriz)):
            custo=[]
            for j in range (len(lista)):
                if (matriz[i][j] != 'X'): 
                    custo.append(1)
                else:  
                    custo.append(25)
            custos.append(custo)
        return(custos)
    
    #devolve o custo de uma dada posição
    def returnCustoOfaPos(self,arr,v):
        x= int(v[0])
        y= int(v[1])
        list=self.custoPos(arr)
        return(list[x][y])
 
    #numa dada posição, desde que seja válido, podemos: 
    #avançar para a esquerda(y-1), para a direita(y+1)
    #avançar para cima (x-1), para baixo (x+1)
    #avançar esquerda e cima em simultaneo(y-1 e x-1) - diagonal
    #avançar direita e cima em simultaneo(y+1 e x-1) - diagonal
    #avançar esquerda e baixo em simultaneo(y-1 e x+1) - diagonal
    #avançar direita e baixo em simultaneo(y+1 e x+1) - diagonal
    def adjentOfPos(self,arr,x_atual,y_atual):
        list=[]
        if ([x_atual-1,y_atual]) in self.returnPositionsOfMatrix(arr): list.append((x_atual-1,y_atual))
        if ([x_atual+1,y_atual]) in self.returnPositionsOfMatrix(arr): list.append((x_atual+1,y_atual))
        if ([x_atual,y_atual-1]) in self.returnPositionsOfMatrix(arr):list.append((x_atual,y_atual-1))
        if ([x_atual,y_atual+1]) in self.returnPositionsOfMatrix(arr):list.append((x_atual,y_atual+1))
        if ([x_atual-1,y_atual-1]) in self.returnPositionsOfMatrix(arr):list.append((x_atual-1,y_atual-1))
        if ([x_atual+1,y_atual-1]) in self.returnPositionsOfMatrix(arr):list.append((x_atual+1,y_atual-1))
        if ([x_atual-1,y_atual+1]) in self.returnPositionsOfMatrix(arr):list.append((x_atual-1,y_atual+1))
        if ([x_atual+1,y_atual+1]) in self.returnPositionsOfMatrix(arr):list.append((x_atual+1,y_atual+1))
        #retorna a lista das posições adjacentes a uma dada cordenada
        return(list)
              
    #retorna um tuplo em que o 1 elem é uma dada posição e o 2 elem é a lista de posicoes válidas adjacentes a essa posição
    def getListofAdjencencies(self,arr):
        matriz=self.listaToMatriz(arr)
        lista = matriz[0]
        newAdjs=[]
        for i in range (len(matriz)): #colunas
            for j in range (len(lista)): #linhas
                #if (matriz[i][j]!= 'X'):
                    newAdjs.append([(i,j),self.adjentOfPos(arr,i,j)])
        return(dict(newAdjs))
    
    # transforma uma lista de posições em forma de tuplo em inteiros : [(2,9),(3,9),(4,9)] => [29,39,49]
    def finalsPositionsIntoIntegers(self,arr):
        newIntegersPositions = []
        list = self.encontraPosicoesFinais(arr)
        length = len(list)
        for i in range(length):
                fim=list[i]
                fl=str(fim[0])
                fc=str(fim[1])
                newf=fl+fc
                newIntegersPositions.append(int(newf))
        return newIntegersPositions
            
            
        
        
