{-|
Module      : Tarefa5
Description : Módulo Tarefa5 que contém funções com o objetivo de movimentação dos fantasmas.
Copyright   : Joana Branco <joanabranco.23@gmail.com>;
              Rafael Ferreira <a97642@alunos.uminho.pt>

Este é o módulo correspondente à Tarefa 5 do trabalho que, através de diversas funções,
permite a movimentação dos fantasmas no jogo.
-}

module Tarefa5 where 

import Types
import Tarefa4


{- |

= Introdução

Nesta tarefa tinha que se desenvolver as jogadas e o comportamento dos fantasmas no jogo. 
A tarefa 2 é aqui usada diretamente como auxílio pois é a que retrata as jogadas possíveis neste projeto.


= Objetivos

São diversos os objetivos a alcançar tais que, a função principal a implementar recebe o estado do jogo e 
devolve as várias jogadas dos fantasmas ativos no jogo. Estas jogadas devem ser aplicadas de maneira a que seja
aplicada a melhor estratégia para atuar perante o seu "adversário" Pacman. 
Tem que se ter em consideração ao modo (Alive ou Dead) do fantasma pois perante isto, o mesmo deve ter respostas
diferentes, se não mesmo opostas.
Assim, as estratégias do fantasma baseiam-se em:

* (modo Alive) ir atrás do Pacman (através das suas coordenadas) e posicionar-se quatro espaços à frente do mesmo (dependendo da sua orientação);
* (modo Dead) fugir do Pacman e sempre que se encontra com uma parede move-se para a sua direita, no sentido dos ponteiros de relógio.


= Discussão e Conclusão

O procedimento usado no desenvolvimento desta tarefa passou pela integração de algumas funções que foram necessárias na tarefa 2 (da 1ª 
fase) e, com estas, incorporar o potencial comportamento dos Ghost. Para isto, era necessário o estado atual do jogo que, com as devidas
alterações, apresentar-se-ia uma lista de jogadas sendo estas a melhor alternativa. Tendo em conta o modo do Pacman (Normal ou Mega) e o 
modo do Ghost (Alive ou Dead), a função principal passava pelo planeamento da fuga do Ghost ou, então, pela corrida atrás do Pacman. 
Através do método de Manhattan consegui-se calcular a distância entre os jogadores adversários e assim, começaria o processo de perseguição.

Por fim, consideramos que demos o nosso melhor para atingir o objetivo final e, esta tarefa permitiu perceber ainda melhor todo o conceito
de circulação dos jogadores, tanto Pacman como Ghost, e o possível manipulamento no jogo.

-}


-- | * __Função principal da Tarefa 5__

-- | Dado um State devolve uma lista de jogadas a efetuar pelos Ghost
ghostPlay :: State -> [Play]
ghostPlay (State m lp l) = chaseScatter (State m lp l) (separatePlayers lp)


-- | Funçao que dado um State e um tuplo com listas de Pacman e Ghost, respetivamente, devolve uma lista de Play

chaseScatter :: State -> ([Player],[Player]) -> [Play]
chaseScatter (State m lp l) (p,(a:t)) | (ghoMode a) == Alive = chaseMode (State m lp l) (getPlayerID a) : chaseScatter (State m lp l) (p,t)
                                      | (ghoMode a) == Dead = scatterMode (State m lp l) (getPlayerID a) : chaseScatter (State m lp l) (p,t)


-- | Função que dado um State um ID devolve uma play

chaseMode :: State -> Int -> Play
chaseMode (State m lp l) id | (minDist' id (main1 ((play (Move id R) m (findById id lp)) : (removeById id lp)))) < (minDist' id lp) = (Move id R)
                            | (minDist' id (main1 ((play (Move id L) m (findById id lp)) : (removeById id lp)))) < (minDist' id lp) = (Move id L)
                            | (minDist' id (main1 ((play (Move id U) m (findById id lp)) : (removeById id lp)))) < (minDist' id lp) = (Move id U)
                            | (minDist' id (main1 ((play (Move id D) m (findById id lp)) : (removeById id lp)))) < (minDist' id lp) = (Move id D)


-- | Função que dado um State um ID devolve uma play


scatterMode :: State -> Int -> Play
scatterMode (State m lp l) id | (minDist' id (main1 ((play (Move id R) m (findById id lp)) : (removeById id lp)))) > (minDist' id lp) = (Move id R)
                              | (minDist' id (main1 ((play (Move id L) m (findById id lp)) : (removeById id lp)))) > (minDist' id lp) = (Move id L)
                              | (minDist' id (main1 ((play (Move id U) m (findById id lp)) : (removeById id lp)))) > (minDist' id lp) = (Move id U)
                              | (minDist' id (main1 ((play (Move id D) m (findById id lp)) : (removeById id lp)))) > (minDist' id lp) = (Move id D)


-- | Dados dois Players devolve o resultado de aplicar a função methoDManhattan

metC :: Player -> Player -> Int
metC p g  = methodManhattan (getC p) (getC g)


-- | Dadas duas Coords devolve um inteiro (resultado da métrica de Manhattan entre as duas Coords)

methodManhattan :: Coords -> Coords -> Int
methodManhattan (a,b) (c,d) | ((a-c) == 0 ) && ((b-d) == 0) = 0
                            | ((a-c) >= 0 ) && ((b-d) >= 0) = (a-c) + (b-d)
                            | ((a-c) <= 0 ) && ((b-d) >= 0) = ((-1) * (a-c)) + (b-d)
                            | ((a-c) >= 0 ) && ((b-d) <= 0) = (a-c) + ((-1) * (b-d))
                            | ((a-c) <= 0 ) && ((b-d) <= 0) = ((-1) * (a-c)) + ((-1) * (b-d))


-- | Dado um ID e a lista de Players esta função devolve a distância do jogador que se encontra mais próximo do Bot

minDist' :: Int -> [Player] -> Int
minDist' i l = funAux i (separatePlayers l)


-- | Função que dado um inteiro e um tuplo com listas de Pacman e Ghost, respetivamente, devolve um inteiro

funAux :: Int -> ([Player],[Player]) -> Int
funAux id (lp,lg) = minimum (map (metC (findById id lg)) lp)


-- | Dado um ID e uma lista de Players devolve o Player com esse ID

findById :: Int -> [Player] -> Player
findById pid (a:b) 
             | getPlayerID a == pid = a
             | otherwise = findById pid b


-- | Dado um ID e uma lista de Players devolve a lista sem o Player com o ID correspondente ao dado

removeById :: Int -> [Player] -> [Player]
removeById pid (a:b) 
             | getPlayerID a == pid = b
             | otherwise = a : (removeById pid b)


-- | Dado um Play, um Maze e um Player, se a orientação do Player coincide com a do Play efetua uma jogada, caso contrário, muda a orientação para a do Play

play :: Play -> Maze -> Player -> Player
play (Move id o) m a  | (o == (orientation' a)) && ((ghoMode a) == Alive) = goAlive m a
                      | (o == (orientation' a)) && ((ghoMode a) == Dead) = goDead m a
                      | otherwise = changeOrientation o a


-- | Dado um Maze e um Player devolve o Player atualizado

goDead :: Maze -> Player -> Player
goDead m a 
                        |(getPlayerOrientation a == L ) && (sndC a == 0) = changeSnd ((y'sMaze m) - 1) a
                        |(getPlayerOrientation a == R ) && (sndC a == ((y'sMaze m) - 1)) = changeSnd 0 a

                        |(getPlayerOrientation a == R ) && ((rightPiece m a) == Empty) = moveTo (0,1) a
                        |(getPlayerOrientation a == L ) && ((leftPiece m a) == Empty) = moveTo (0,-1) a
                        |(getPlayerOrientation a == U ) && ((underPiece m a) == Empty) = moveTo (-1,0) a
                        |(getPlayerOrientation a == D ) && ((downPiece m a) == Empty) = moveTo (1,0) a

 
                        |(getPlayerOrientation a == R ) && ((rightPiece m a) == Wall) = moveTo (1,0) a
                        |(getPlayerOrientation a == L ) && ((leftPiece m a) == Wall) = moveTo (-1,0) a
                        |(getPlayerOrientation a == U ) && ((underPiece m a) == Wall) = moveTo (0,1) a
                        |(getPlayerOrientation a == D ) && ((downPiece m a) == Wall) = moveTo (0,-1) a

                        | otherwise = playOtherwise' m a


-- | Função que dado um Maze e um player devolve esse Player atualizado

goAlive :: Maze -> Player -> Player
goAlive m a 
                        |(getPlayerOrientation a == L ) && (sndC a == 0) = changeSnd ((y'sMaze m) - 1) a
                        |(getPlayerOrientation a == R ) && (sndC a == ((y'sMaze m) - 1)) = changeSnd 0 a

                        |(getPlayerOrientation a == R ) && ((rightPiece m a) == Empty) = moveTo (0,1) a
                        |(getPlayerOrientation a == L ) && ((leftPiece m a) == Empty) = moveTo (0,-1) a
                        |(getPlayerOrientation a == U ) && ((underPiece m a) == Empty) = moveTo (-1,0) a
                        |(getPlayerOrientation a == D ) && ((downPiece m a) == Empty) = moveTo (1,0) a

 
                        |(getPlayerOrientation a == R ) && ((rightPiece m a) == Wall) = a
                        |(getPlayerOrientation a == L ) && ((leftPiece m a) == Wall) = a
                        |(getPlayerOrientation a == U ) && ((underPiece m a) == Wall) = a
                        |(getPlayerOrientation a == D ) && ((downPiece m a) == Wall) = a

                        | otherwise = playOtherwise' m a


-- | Dado um Maze e um Player devolve o Player já movido

playOtherwise' :: Maze -> Player -> Player
playOtherwise' m a 
                        |(getPlayerOrientation a == R ) = moveTo (0,1) a
                        |(getPlayerOrientation a == L ) = moveTo (0,-1) a
                        |(getPlayerOrientation a == U ) = moveTo (-1,0) a
                        |(getPlayerOrientation a == D ) = moveTo (1,0) a


-- | Dada uma lista de Players devolve uma lista de Players que resulta da aplicação de funções à lista inicial

main2 :: [Player] -> [Player]
main2 l   | testMega (fst (separatePlayers l)) = loseTmega ((fst (separatePlayers l)) ++ (map turnGhost (killGhost (snd (separatePlayers l)))))
          | otherwise = ifGhoAlive (separatePlayers (ifGhoDead (separatePlayers l)))


-- | Dado um Player é devolvido o Player com a direção oposta à inicial

turnGhost :: Player -> Player
turnGhost g | (getPlayerOrientation g) == R = changeOrientation L g
            | (getPlayerOrientation g) == L = changeOrientation R g
            | (getPlayerOrientation g) == U = changeOrientation D g
            | (getPlayerOrientation g) == D = changeOrientation U g


-- | Dado um Player dá a sua Orientação

orientation' :: Player -> Orientation
orientation' (Pacman (PacState (x,y,z,t,h,l) q c d )) = t


-- | Dado uma Orientation e um Player dá ao Player a nova Orientation

changeOrientation :: Orientation -> Player -> Player
changeOrientation o (Pacman (PacState (x,y,z,t,h,l) q c d )) = (Pacman (PacState (x,y,z,o,h,l) q c d ))