{-|
Module      : Tarefa3
Description : Módulo Tarefa3 que contém funções com as intruções para gerar um labirinto.
Copyright   : Joana Branco <joanabranco.23@gmail.com>;
              Rafael Ferreira <a97642@alunos.uminho.pt>

Este é o módulo correspondente à Tarefa 3 do trabalho que, dado um labirinto válido,
converte-o numa sequência de instruções de tornando-o mais compacto.
-}

module Tarefa3 where

import Types


-- | Dado um Maze retorna Instructions que representam o Maze de uma forma mais compacta
--
compactMaze :: Maze -> Instructions
compactMaze [] = []
compactMaze (x:xs) = auxMain (x:xs)

-- | Converte uma lista de Corridor numa lista de Instruction
--
auxMain :: [Corridor] -> [Instruction]
auxMain [] = []
auxMain (a:r) = subaux (joinInstruction a : auxMain r)


-- | Converte uma lista de Instruction numa mesma em que se há Corridor iguais aparecerá Repeat x (sendo x a posição do Corridor inicial)
-- 
subaux :: [Instruction] -> [Instruction]
subaux [] = []
subaux (a:b)
         | sameInstruction a (head b) = a : Repeat (instructPosition a (a:b)) : subaux (a:(tail b))
         | otherwise = a : subaux b


-- | Dado um Corridor retorna a sua Instruction correspondente
--
joinInstruction :: Corridor -> Instruction
joinInstruction [] = Instruct []
joinInstruction (x:xs) = Instruct (acumulatePiece (givesCorridor (x:xs)))


-- | Converte um Corridor numa lista de pares de (Int,Piece)
--
givesCorridor :: Corridor -> [(Int,Piece)]
givesCorridor [] = []
givesCorridor (p:ps) = (1,p) : givesCorridor ps


-- | Dada uma lista de (Int,Piece) retorna uma semelhante em que, se as Piece consecutivas forem iguais vai-se acumulando o número das mesmas
--
acumulatePiece :: [(Int,Piece)] -> [(Int,Piece)]
acumulatePiece [] = []
acumulatePiece [(x,y)] = [(x,y)]
acumulatePiece ((n,p) : (n1,p1) : t)
                         | samePiece p p1 = (acumulatePiece (((n+n1),p1) : t))
                         | otherwise = (n,p) : (acumulatePiece ((n1,p1) : t))


-- | Dadas duas Piece verifica se estas são iguais
--
samePiece :: Piece -> Piece -> Bool
samePiece (Wall) (Wall) = True
samePiece (Empty) (Empty) = True
samePiece (Food Big) (Food Big) = True
samePiece (Food Little) (Food Little) = True
samePiece _ _ = False


-- | Compara se uma Instruction é igual à cabeça das Instructions e assim, devolve a posição dessa Instruction inicial
--
instructPosition :: Instruction -> Instructions  -> Int
instructPosition i (m:ms)
              | i == m = 0
              | otherwise = 1 + instructPosition i ms


-- | Dadas duas Instruction verifica se estas são iguais
--
sameInstruction :: Instruction -> Instruction -> Bool
sameInstruction (Instruct []) (Instruct []) = True
sameInstruction (Instruct []) _ = False
sameInstruction _ (Instruct []) = False
sameInstruction (Instruct ((n,p) : t)) (Instruct ((n1,p1) : t1))
                            | (n == n1) && (samePiece p p1) = sameInstruction (Instruct t) (Instruct t1)
                            | otherwise = False


-- | Testa o nível de compactação da função
--
sizeInstructions :: Instructions -> Int
sizeInstructions l = length l



-- Dimensões do Labirinto: 17x12
teste1 = [
         [Wall,Wall,Wall,Wall,Wall,Wall,Wall,Wall,Wall,Wall,Wall,Wall,Wall,Wall,Wall,Wall,Wall],
         [Wall,Food Little,Food Little,Food Little,Food Little,Wall,Wall,Food Little,Food Little,Wall,Wall,Food Little,Food Little,Wall,Wall,Food Little,Wall],
         [Wall,Food Little,Food Little,Wall,Wall,Food Little,Food Little,Food Little,Food Little,Wall,Food Little,Food Little,Wall,Food Little,Wall,Wall,Wall],
         [Wall,Wall,Food Little,Empty,Empty,Empty,Empty,Empty,Empty,Empty,Empty,Empty,Empty,Empty,Food Little,Food Little,Wall],
         [Wall,Wall,Food Little,Empty,Wall,Wall,Wall,Empty,Empty,Empty,Wall,Wall,Wall,Empty,Wall,Food Little,Wall],
         [Empty,Wall,Food Little,Empty,Wall,Empty,Empty,Empty,Empty,Empty,Empty,Empty,Wall,Empty,Food Little,Food Little,Empty],
         [Empty,Wall,Food Little,Empty,Wall,Wall,Wall,Wall,Wall,Wall,Wall,Wall,Wall,Empty,Food Little,Food Little,Empty],
         [Wall,Food Little,Food Little,Empty,Empty,Empty,Empty,Empty,Empty,Empty,Empty,Empty,Empty,Empty,Wall,Food Little,Wall],
         [Wall,Food Little,Food Little,Wall,Food Little,Wall,Food Little,Food Little,Wall,Food Little,Food Little,Wall,Food Little,Food Little,Food Little,Food Little,Wall],
         [Wall,Food Little,Food Little,Food Little,Food Little,Food Little,Wall,Food Little,Wall,Food Little,Food Little,Food Little,Food Little,Wall,Food Big,Food Little,Wall],
         [Wall,Food Little,Food Little,Food Little,Food Little,Food Little,Food Little,Food Little,Food Little,Wall,Food Little,Food Little,Wall,Food Little,Food Little,Food Little,Wall],
         [Wall,Wall,Wall,Wall,Wall,Wall,Wall,Wall,Wall,Wall,Wall,Wall,Wall,Wall,Wall,Wall,Wall]
         ]