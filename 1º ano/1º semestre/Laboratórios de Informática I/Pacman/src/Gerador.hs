module Gerador where

import System.Random

type Labirinto = [Corredor]
type Corredor = [Peca]
data Peca = Comida TamanhoComida | Parede | Chao
data TamanhoComida = Grande | Pequena

instance Show Peca where
    show (Comida Grande) = "o"
    show (Comida Pequena) = "."
    show (Parede) = "#"
    show (Chao) = " "

sampleMaze :: Labirinto
sampleMaze = [
                [Parede, Parede, Parede, Parede, Parede, Parede, Parede, Parede],
                [Chao, Comida Pequena, Comida Pequena, Comida Grande, Comida Pequena, Comida Grande, Comida Pequena, Chao],
                [Parede, Parede, Parede, Parede, Parede, Parede, Parede, Parede]
            ]


-- | Given a seed returns a list of n integer randomly generated
--
geraAleatorios :: Int -> Int -> [Int]
geraAleatorios n seed = let gen = mkStdGen seed -- creates a random generator
                        in take n $ randomRs (0,9) gen -- takes the first n elements from an infinite series of random numbers between 0-9


-- Converssta list into a list of list of size n
--
subLista :: Int -> [a] -> [[a]]
subLista _ [] = []
subLista n l = take n l: subLista n (drop n l)


-- | Converts an integer number into a Peca
-- 3 <=> Comida Grande
-- 0 <= n < 7 <=> Comida Pequea
-- 7 < n <= 9 <=> Parede
--
convertePeca :: Int -> Peca
convertePeca x 
    | x == 3 = Comida Grande
    | x >= 0 && x < 7 = Comida Pequena
    | otherwise = Parede


-- | Conerts a Corredor to a string
--
printCorridor :: Corredor -> String
printCorridor [] = "\n"
printCorridor (x:xs) = show x ++ printCorridor xs





-- | Converts a Labirinto to a string
--
printMaze :: Labirinto -> String
printMaze [] = ""
printMaze (x:xs) = printCorridor x ++ printMaze xs


-- | Converts a list of integers into a Corredor
--
converteCorredor :: [Int] -> Corredor
converteCorredor [] = []
converteCorredor (x:xs) = convertePeca x :converteCorredor xs


-- | Converts a list of lists of integers into a Labirinto
--
converteLabirinto :: [[Int]] -> Labirinto
converteLabirinto [] = []
converteLabirinto (x:xs) = converteCorredor x : converteLabirinto xs


geraLabirinto :: Int -> Int -> Int -> IO ()
geraLabirinto x y s =
                 let random_nrs = geraAleatorios (x*y) s
                 in putStrLn $ printMaze $ converteLabirinto $ subLista x random_nrs

