{-|
Module      : Tarefa2
Description : Módulo Tarefa2 que contém funções com o objetivo de fazer jogadas.
Copyright   : Joana Branco <joanabranco.23@gmail.com>;
              Rafael Ferreira <a97642@alunos.uminho.pt>

Este é o módulo correspondente à Tarefa 2 do trabalho que, através de diversas 
funções, realiza jogadas para os jogadores do tipo Pacman.
-}

module Tarefa2 where

import Types
import FileUtils
import Tarefa1

-- | Dadas as Coords e um Maze retorna a Piece que se encontra naquela posição
--
whatPiece :: Coords -> Maze -> Piece
whatPiece (a,b) maze = ( ( maze !! a ) !! b )


-- | Função objetivo que dada uma jogada (Play) e um State altera o State de um jogador
--
play :: Play -> State -> State             -- [Pacman,Ghost,Ghost,Pacman]
play (Move id o) (State maze (x:xs) l) = State maze (y:ys) l
                                          where (y:ys) = newParameters maze (Move id o) (ordPlayers (x:xs))


-- | Dada uma lista de Player retorna a mesma lista com os Player devidamente ordenados
--
ordPlayers :: [Player] -> [Player]
ordPlayers [] = []
ordPlayers (x:xs) 
              | testIfPacGho x = ordPlayers xs ++ [x]
              | otherwise = x : ordPlayers xs


-- | Dado um Player verifica se este é do tipo Ghost
--
testIfPacGho :: Player -> Bool
testIfPacGho (Ghost (GhoState _ _ )) = True
testIfPacGho _ = False


-- | Dado um Maze, uma jogada (Play) e um jogador retorna uma lista de Player com as devidas alterações
-- 
newParameters :: Maze -> Play -> [Player] -> [Player]
newParameters maze (Move id o) [] = []
newParameters maze (Move id o) ( (Pacman (PacState (idP, (x,y), v, oP, p, l) tM mouth pMode) ) : xs )
              
              | (idP == id) && (oP == o) && (oP == L ) && (y == 0) = Pacman (PacState (idP, (x,((y'sMaze maze) - 1)), v, o, p, l) tM mouth Normal) : xs
              | (idP == id) && (oP == o) && (oP == R ) && (y == ((y'sMaze maze) - 1)) = Pacman (PacState (idP, (x,0), v, o, p, l) tM mouth Normal) : xs

              | (idP == id) && (oP == o) && (oP == R ) && (whatPiece (x,y+1) maze == Empty) = Pacman (PacState (idP, (x,y+1), v, oP, p, l) tM mouth Normal) : xs
              | (idP == id) && (oP == o) && (oP == L ) && (whatPiece (x,y-1) maze == Empty) = Pacman (PacState (idP, (x,y-1), v, oP, p, l) tM mouth Normal) : xs
              | (idP == id) && (oP == o) && (oP == U ) && (whatPiece (x-1,y) maze == Empty) = Pacman (PacState (idP, (x-1,y), v, oP, p, l) tM mouth Normal) : xs
              | (idP == id) && (oP == o) && (oP == D ) && (whatPiece (x+1,y) maze == Empty) = Pacman (PacState (idP, (x+1,y), v, oP, p, l) tM mouth Normal) : xs      

              | (idP == id) && (oP /= o) = ( Pacman (PacState (idP, (x,y), v, o, p, l) tM mouth Normal) : xs )

              | (idP == id) && (oP == o) && (oP == R ) && (whatPiece (x,y+1) maze == Wall) = Pacman (PacState (idP, (x,y), v, oP, p, l) tM mouth Normal) : xs
              | (idP == id) && (oP == o) && (oP == L ) && (whatPiece (x,y-1) maze == Wall) = Pacman (PacState (idP, (x,y), v, oP, p, l) tM mouth Normal) : xs
              | (idP == id) && (oP == o) && (oP == U ) && (whatPiece (x-1,y) maze == Wall) = Pacman (PacState (idP, (x,y), v, oP, p, l) tM mouth Normal) : xs
              | (idP == id) && (oP == o) && (oP == D ) && (whatPiece (x+1,y) maze == Wall) = Pacman (PacState (idP, (x,y), v, oP, p, l) tM mouth Normal) : xs

              | (idP == id) && (oP == o) && (oP == R ) && (whatPiece (x,y+1) maze == Food Little) = Pacman (PacState (idP, (x,y+1), v, oP, (p+1), l) tM mouth Normal) : xs
              | (idP == id) && (oP == o) && (oP == L ) && (whatPiece (x,y-1) maze == Food Little) = Pacman (PacState (idP, (x,y-1), v, oP, (p+1), l) tM mouth Normal) : xs
              | (idP == id) && (oP == o) && (oP == U ) && (whatPiece (x-1,y) maze == Food Little) = Pacman (PacState (idP, (x-1,y), v, oP, (p+1), l) tM mouth Normal) : xs
              | (idP == id) && (oP == o) && (oP == D ) && (whatPiece (x+1,y) maze == Food Little) = Pacman (PacState (idP, (x+1,y), v, oP, (p+1), l) tM mouth Normal) : xs 

              | (idP == id) && (oP == o) && (oP == R ) && (whatPiece (x,y+1) maze == Food Big) = Pacman (PacState (idP, (x,y+1), v, oP, (p+5), l) tM mouth Mega) : (killGhost xs)
              | (idP == id) && (oP == o) && (oP == L ) && (whatPiece (x,y-1) maze == Food Big) = Pacman (PacState (idP, (x,y-1), v, oP, (p+5), l) tM mouth Mega) : (killGhost xs)
              | (idP == id) && (oP == o) && (oP == U ) && (whatPiece (x-1,y) maze == Food Big) = Pacman (PacState (idP, (x-1,y), v, oP, (p+5), l) tM mouth Mega) : (killGhost xs)
              | (idP == id) && (oP == o) && (oP == D ) && (whatPiece (x+1,y) maze == Food Big) = Pacman (PacState (idP, (x+1,y), v, oP, (p+5), l) tM mouth Mega) : (killGhost xs)

              | (idP == id) && (oP == o) && (oP == R ) && (whatPiece (x,y+1) maze == badGhost (x,y+1) xs) = loseLives (Pacman (PacState (idP, (x,y), v, oP, p, l) tM mouth Normal) )  : xs
              | (idP == id) && (oP == o) && (oP == L ) && (whatPiece (x,y-1) maze == badGhost (x,y-1) xs) = loseLives (Pacman (PacState (idP, (x,y), v, oP, p, l) tM mouth Normal) )  : xs
              | (idP == id) && (oP == o) && (oP == U ) && (whatPiece (x-1,y) maze == badGhost (x-1,y) xs) = loseLives (Pacman (PacState (idP, (x,y), v, oP, p, l) tM mouth Normal) )  : xs
              | (idP == id) && (oP == o) && (oP == D ) && (whatPiece (x+1,y) maze == badGhost (x+1,y) xs) = loseLives (Pacman (PacState (idP, (x,y), v, oP, p, l) tM mouth Normal) )  : xs

              | (idP == id) && (oP == o) && (oP == R ) && (whatPiece (x,y+1) maze == deliciousGhost (x,y+1) xs) = Pacman (PacState (idP, (x,y+1), v, oP, (p+10), l) tM mouth Mega) : takeGhost maze (x,y+1) xs
              | (idP == id) && (oP == o) && (oP == L ) && (whatPiece (x,y-1) maze == deliciousGhost (x,y-1) xs) = Pacman (PacState (idP, (x,y-1), v, oP, (p+10), l) tM mouth Mega) : takeGhost maze (x,y-1) xs
              | (idP == id) && (oP == o) && (oP == U ) && (whatPiece (x-1,y) maze == deliciousGhost (x-1,y) xs) = Pacman (PacState (idP, (x-1,y), v, oP, (p+10), l) tM mouth Mega) : takeGhost maze (x-1,y) xs
              | (idP == id) && (oP == o) && (oP == D ) && (whatPiece (x+1,y) maze == deliciousGhost (x+1,y) xs) = Pacman (PacState (idP, (x+1,y), v, oP, (p+10), l) tM mouth Mega) : takeGhost maze (x+1,y) xs
              
              | (idP /= id) = newParameters maze (Move id o) xs



-- | Dado um Player do tipo Pacman retorna o mesmo com menos uma vida e altera o seu modo
--
loseLives :: Player -> Player
loseLives (Pacman (PacState (idP, (x,y), v, oP, p, l) tM mouth Normal))
                            | l>1 = (Pacman (PacState (idP, (x,y), v, oP, p, (l-1)) tM mouth Normal))
                            | l==1 = (Pacman (PacState (idP, (x,y), v, oP, p, 0) tM mouth Normal))
                            | l==0 = (Pacman (PacState (idP, (x,y), v, oP, p, 0) tM mouth Dying))


-- | Dado um Maze, Coords e uma lista de Player do tipo Ghost retorna esta última com as alterações no seu modo enviando-o para a parte central do Maze
--
takeGhost :: Maze -> Coords -> [Player] -> [Player]
takeGhost maze (a,b) [] = []
takeGhost maze (a,b) (Ghost (GhoState (idG, (x1,y1), v, oG, pt, lv) gMode) : xs)
                | (x1 == a) && (y1 == b) && (gMode == Dead) = Ghost (GhoState (idG, (centerTunnel maze), v, oG, pt, lv) Alive) : takeGhost maze (a,b) xs
                | (x1 /= a) && (y1 /= b) = Ghost (GhoState (idG, (x1,y1), v, oG, pt, lv) gMode) : takeGhost maze (a,b) xs       


-- | Converte um Maze em Coords relativas ao centro do túnel
--
centerTunnel :: Maze -> Coords
centerTunnel maze = ( ( (lMaze maze) `div` 2 ), ( (y'sMaze maze) `div` 2) )


-- | Dada uma lista de Player do tipo Ghost retorna o mesmo com o seu modo Dead
--
killGhost :: [Player] -> [Player]
killGhost [] = []
killGhost (Ghost (GhoState a Alive) : xs) = Ghost (GhoState a Dead) : killGhost xs


-- | Dadas Coords e uma lista de Players do tipo Ghost retorna um Piece que vai prejudicar o Pacman
--
badGhost :: Coords -> [Player] -> Piece
badGhost (x,y) (Ghost (GhoState (idG, (x1,y1), v, oG, pt, lv) gM) : xs) 
                       | (x == x1) && (y == y1) && (gM == Alive) = PacPlayer (Ghost (GhoState (idG, (x1,y1), v, oG, pt, lv) Alive))
                       | otherwise = badGhost (x,y) xs


-- | Dadas Coords e uma lista de Players do tipo Ghost retorna um Piece que vai favorecer o Pacman
--
deliciousGhost :: Coords -> [Player] -> Piece
deliciousGhost (x,y) (Ghost (GhoState (idG, (x1,y1), v, oG, pt, lv) gM) : xs) 
                       | (x==x1) && (y==y1) && (gM == Dead) = PacPlayer (Ghost (GhoState (idG, (x1,y1), v, oG, pt, lv) Dead))
                       | otherwise = deliciousGhost (x,y) xs


-- | Converte um Maze num inteiro sendo este último a largura do Maze
-- 
y'sMaze :: Maze -> Int
y'sMaze [] = 0
y'sMaze maze = length (head maze)


-- | Converte um Maze num inteiro sendo este último a altura do Maze
--
lMaze :: Maze -> Int
lMaze [] = 0
lMaze maze = length maze


--
lab = displayMaze(generateMaze 15 10 108298298)

p1 = (Pacman (PacState (1, (8,3), 1.5, R, 2, 0) 0 Open Normal))
p2 = (Pacman (PacState (2, (0,12), 1.5, D, 0, 0) 0 Open Mega))
p3 = (Pacman (PacState (3, (9,9), 1, L, 0, 0) 0 Open Normal))
g1 = (Ghost (GhoState (4, (10,4), 1, R, 0, 1) Alive))
g2 = (Ghost (GhoState (5, (14,5), 1, U, 0, 1) Dead))
g3 = (Ghost (GhoState (6, (7,2), 1, D, 0, 1) Alive))

l1 = [p1,g2,p3]
l2 = [p2,g1]