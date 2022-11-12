{-|
Module      : Tarefa1
Description : Módulo Tarefa1 que contém funções com o objetivo de gerar labirintos.
Copyright   : Joana Branco <joanabranco.23@gmail.com>;
              Rafael Ferreira <a97642@alunos.uminho.pt>

Este é o módulo correspondente à Tarefa 1 do trabalho que, através de diversas
 funções, desenvolve um mecanismo para gerar labirintos, a base do jogo.
-}

module Tarefa1 where

import System.Random
import Generator

-- | Dada uma semente retorna a lista the números inteiros gerados aleatoriamente
--
generateRandoms :: Int -> Int -> [Int]
generateRandoms n seed = let gen = mkStdGen seed -- cria um gerador aleatório
                    in take n $ randomRs (0,99) gen -- pega nos primeiros n elementos de uma série infinita de números aleatórios entre 0 e 99


-- | Dada uma semente retorna um inteiro gerado aleatoriamente
--
randomNumbers :: Int -> Int
randomNumbers seed = head $ generateRandoms 1 seed


-- | Converte uma lista numa lista de lista de tamanho n
--
subList :: Int -> [Int] -> [[Int]]
subList _ [] = []
subList n l = take n l: subList n (drop n l)


-- | Converte um número inteiro numa Piece
-- 3 <=> Food Big
-- 0 <= n < 70 <=> Food Little
-- 70 < n <= 99 <=> Wall
--
convertsPiece :: Int -> Piece
convertsPiece n 
  | n == 3 = Food Big 
  | n >= 0 && n < 70 = Food Little
  | n >= 70  && n <= 99 = Wall


-- | Converte um Corridor numa string
--
printCorridor :: Corridor -> String
printCorridor [] = "\n" 
printCorridor (p:ps) = show p ++ printCorridor ps


-- | Converte uma lista de inteiros num Corridor
--
convertsCorridor :: [Int] -> Corridor
convertsCorridor [] = [] 
convertsCorridor (p:ps) = convertsPiece p : convertsCorridor ps


-- | Converte uma lista de listas de inteiros num Maze
--
convertsMaze :: [[Int]] -> Maze
convertsMaze [] = []
convertsMaze (x:xs) = ( [Wall] ++ (convertsCorridor x) ++ [Wall]) : convertsMaze xs


-- | Dados três números inteiros devolve um Maze com a parte interior do Maze inicial
--
innerZone :: Int -> Int -> Int -> Maze
innerZone l h seed = convertsMaze (subList l (generateRandoms (l*h) seed))


-- | Converte um número inteiro numa lista de Piece Wall
--
allWalls :: Int -> [Piece]
allWalls 0 = []
allWalls a = Wall : allWalls (a-1)


-- | Converte um Maze num inteiro sendo este último a altura do Maze
--
middleHeight :: Maze -> Int
middleHeight maze = div (length maze) 2


-- | Converte um Maze numa lista de Corridor sendo estes a parte central do Maze
--
middleCorridors :: Maze -> [Corridor]
middleCorridors maze | even (length maze) = take 2 (drop ((middleHeight maze) - 1) maze)
                     | otherwise = take 1 (drop (middleHeight maze) maze)


-- | Dada uma lista de Corridors devolve outra mesma lista sem as Wall do início e fim de cada Corridor
--
breakWall :: [Corridor] -> [Corridor]
breakWall [] = []
breakWall (c:cs) = (Empty : (init (tail c)) ++ [Empty]) : breakWall cs


-- | Converte um Maze num outro Maze com um túnel central
--
openTunnel :: Maze -> Maze
openTunnel maze | even (length maze) = (take (midH - 1) maze) ++ tunnel ++ (drop (midH + 1) maze)
                | otherwise = (take midH maze) ++ tunnel ++ drop (midH +1) maze
                where midH = middleHeight maze
                      tunnel = breakWall (middleCorridors maze)


-- | Converte uma lista de Corridor num Maze com a casa dos fantasmas já implementada no centro do mesmo
--
mazeWithHome :: [Corridor] -> Maze
mazeWithHome maze
                | even (length maze) = (take (((length maze) - 5) `div` 2) maze) ++ (buildHome (take 5 (drop (((length maze) `div` 2) - 3) maze)) ) ++ (drop ((((length maze)-5) `div` 2) + 5) maze)
                | otherwise = take (((length maze) - 5) `div` 2) maze ++ buildHome (take 5 (drop (((length maze) `div` 2) - 2) maze)) ++ (drop ((((length maze)-5) `div` 2) + 5) maze)


-- | Dada uma lista de Corridor devolve outra lista de Corridor que representa apenas a casa dos fantasmas
--
buildHome :: [Corridor] -> [Corridor]
buildHome maze       
         | odd (corridorsLarge  maze) = [ (take (((corridorsLarge  maze) - 11) `div` 2) (head maze)) ++ oddBuildHome1 ++ (drop ((corridorsLarge  maze) - (((corridorsLarge  maze) - 11) `div` 2)) (head maze)) ,
                                           (take (((corridorsLarge  maze) - 11) `div` 2) (head (drop 1 maze))) ++ oddBuildHome2 ++ (drop ((corridorsLarge  maze) - (((corridorsLarge  maze) - 11) `div` 2)) (head (drop 1 maze))) ,
                                           (take (((corridorsLarge  maze) - 11) `div` 2) (head (drop 2 maze))) ++ oddBuildHome3 ++ (drop ((corridorsLarge  maze) - (((corridorsLarge  maze) - 11) `div` 2)) (head (drop 2 maze))) ,
                                           (take (((corridorsLarge  maze) - 11) `div` 2) (head (drop 3 maze))) ++ oddBuildHome4 ++ (drop ((corridorsLarge  maze) - (((corridorsLarge  maze) - 11) `div` 2)) (head (drop 3 maze))) ,
                                           (take (((corridorsLarge  maze) - 11) `div` 2) (head (drop 4 maze))) ++ oddBuildHome5 ++ (drop ((corridorsLarge  maze) - (((corridorsLarge  maze) - 11) `div` 2)) (head (drop 4 maze)))
                                         ]
         | otherwise =                 [  (take (((corridorsLarge  maze) - 10) `div` 2) (head maze)) ++ evenBuildHome1 ++ (drop ((corridorsLarge maze) - (((corridorsLarge maze) - 10) `div` 2)) (head maze)) ,
                                           (take (((corridorsLarge  maze) - 10) `div` 2) (head (drop 1 maze))) ++ evenBuildHome2 ++ (drop ((corridorsLarge maze) - (((corridorsLarge maze) - 10) `div` 2)) (head (drop 1 maze))) ,
                                           (take (((corridorsLarge  maze) - 10) `div` 2) (head (drop 2 maze))) ++ evenBuildHome3 ++ (drop ((corridorsLarge maze) - (((corridorsLarge maze) - 10) `div` 2)) (head (drop 2 maze))) ,
                                           (take (((corridorsLarge maze) - 10) `div` 2) (head (drop 3 maze))) ++ evenBuildHome4 ++ (drop ((corridorsLarge maze) - (((corridorsLarge maze) - 10) `div` 2)) (head (drop 3 maze))) ,
                                           (take (((corridorsLarge maze) - 10) `div` 2) (head (drop 4 maze))) ++ evenBuildHome5 ++ (drop ((corridorsLarge maze) - (((corridorsLarge maze) - 10) `div` 2)) (head (drop 4 maze)))                                        
                                         ]


-- | Converte um Maze num inteiro sendo este último a largura do Maze
--
corridorsLarge :: Maze -> Int
corridorsLarge maze = length (head maze)


-- | Funções auxiliares para a construção de cada Corridor da casa dos fantasmas sendo a largura par
--
evenBuildHome1 = [Empty,Empty,Empty,Empty,Empty,Empty,Empty,Empty,Empty,Empty]

evenBuildHome2 = [Empty,Wall,Wall,Wall,Empty,Empty,Wall,Wall,Wall,Empty]
          
evenBuildHome3 = [Empty,Wall,Empty,Empty,Empty,Empty,Empty,Empty,Wall,Empty]
                
evenBuildHome4 = [Empty,Wall,Wall,Wall,Wall,Wall,Wall,Wall,Wall,Empty]

evenBuildHome5 = [Empty,Empty,Empty,Empty,Empty,Empty,Empty,Empty,Empty,Empty]


-- | Funções auxiliares para a construção de cada Corridor da casa dos fantasmas sendo a largura ímpar
--
oddBuildHome1 = [Empty,Empty,Empty,Empty,Empty,Empty,Empty,Empty,Empty,Empty,Empty]
                
oddBuildHome2 = [Empty,Wall,Wall,Wall,Empty,Empty,Empty,Wall,Wall,Wall,Empty]
                
oddBuildHome3 = [Empty,Wall,Empty,Empty,Empty,Empty,Empty,Empty,Empty,Wall,Empty]

oddBuildHome4 = [Empty,Wall,Wall,Wall,Wall,Wall,Wall, Wall,Wall,Wall,Empty]

oddBuildHome5 = [Empty,Empty,Empty,Empty,Empty,Empty,Empty,Empty,Empty,Empty,Empty]



-- | Dados dois inteiros e uma semente retorna um Maze com a devida estrutura
--
generateMaze :: Int -> Int -> Int -> Maze
generateMaze l h seed = mazeWithHome (openTunnel (allWalls l : (innerZone (l-2) (h-2) seed) ++ [allWalls l]))


-- | Converte um Maze numa String
--
printMaze :: Maze -> String
printMaze [] = "\n"
printMaze (c:cs) = printCorridor c ++ printMaze cs


-- | Apresenta o Maze com a sua devida estrutura
--
displayMaze :: Maze -> IO()
displayMaze m = putStr $ printMaze m



-- 

teste1 = generateMaze 15 10 108298298
teste2 = generateMaze 17 12 190192039
teste3 = generateMaze 22 15 187817698
