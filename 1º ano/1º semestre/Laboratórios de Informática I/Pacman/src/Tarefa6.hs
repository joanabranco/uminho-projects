{-|
Module      : Tarefa6
Description : Módulo Tarefa6 que contém funções com o objetivo de implementar um robô no jogo.
Copyright   : Joana Branco <joanabranco.23@gmail.com>;
              Rafael Ferreira <a97642@alunos.uminho.pt>

Este é o módulo correspondente à Tarefa 6 do trabalho que, através de diversas funções,
é possível recorrer a um robô que jogue de uma maneira automática.
-}

module Tarefa6 where 

import Types
import Tarefa4
import Tarefa5

{- |

= Introdução

Esta Tarefa 6 consistiu na criação de um robô que, com os devidos requisitos, seja possível executar uma jogada.
Também se dá uso à Tarefa 2 para se obter as diferentes jogadas, dadas pelo bot.


= Objetivos

Com a passagem do tempo, é conhecido o estado do jogo pelo bot e este é que averigua se dá uso à função Play ou não, ou seja,
pode escolher efetuar uma jogada ou não.
A estratégia de decisão está de acordo com o State de um jogo válido e possível e o identificador do jogador.


= Discussão e Conclusão

A ideia de um robô a fazer tudo sozinho parecia, inicialmente, complicado. Para se atingir o objetivo final, tomou-se como abordagem
a realização de uma jogada para quando é possível calcular a distância entre o Pacman e o Ghost. Este cálculo baseia-se no método
simples de Manhattan e podem ser interpretados jogadores de qualquer tipo. Para a concretização da jogada avalia-se a distância
entre os adversários (como anteriormente dito), o modo do Pacman e, consequentemente, o modo do Ghost.

Em suma, acreditamos que fizemos tudo ao nosso alcance para chegar ao melhor resultado possível em que, o robô tenha o melhor desempenho
esperado.

-}

-- | * __Função principal da Tarefa 6__

-- | Dado o id de um jogador e o estado do jogo é devolvido uma possível jogada
bot :: Int -> State -> Maybe Play
bot i (State m pl l) | mR > dmi = Just (Move i R)
                     | mL > dmi = Just (Move i L)
                     | mU > dmi = Just (Move i U)
                     | mD > dmi = Just (Move i D)
                     | (mR == dmi) && (testMega (final (Move i R) m pl)) = Just (Move i R)
                     | (mL == dmi) && (testMega (final (Move i L) m pl)) = Just (Move i L)
                     | (mU == dmi) && (testMega (final (Move i U) m pl)) = Just (Move i U)
                     | (mD == dmi) && (testMega (final (Move i D) m pl)) = Just (Move i D)
                     | otherwise = Nothing
                         where dmi = minDist i pl
                               mR = minDist i (final (Move i R) m pl)
                               mL = minDist i (final (Move i L) m pl)
                               mU = minDist i (final (Move i U) m pl)
                               mD = minDist i (final (Move i D) m pl)


-- | Dado um ID e a lista de Players esta função devolve a distância do jogador que se encontra mais próximo do Bot

minDist :: Int -> [Player] -> Int
minDist i l = metC ( fst (findBot i l) ) ( head (lminDist (fst (findBot i l)) (snd (findBot i l))) )


-- | Dado um ID e a lista de Players esta função devolve a distância do jogador que se encontra mais próximo do Bot

lminDist :: Player -> [Player] -> [Player]
lminDist p (a:b:t)    | ((isPac a) == False) && ((isPac b) == False) && ( metC p a ) > ( metC p b ) = lminDist p (b:t)
                      | ((isPac a) == False) && ((isPac b) == False) && ( metC p a ) < ( metC p b ) = lminDist p (a:t)
                      | ((isPac a))  && ((isPac b) == False) = lminDist p (b:t)
                      | (((isPac a)) == False) && (isPac b) = lminDist p (a:t)
                      | otherwise = lminDist p t
lminDist p (x:[])     = [x]

-- | Dado um play, um Maze e uma lista de jogadores devolve a lista de jogadores com o Bot já atualizado

final :: Play -> Maze -> [Player] -> [Player]
final (Move id o) m l = main1 ( (playB (Move id o) m (fst (findBot id l))) : (snd (findBot id l)) )


-- | Dado um ID e uma lista de Players devolve um tuplo com o Player que é o Bot e com a restante lista dos players

findBot :: Int -> [Player] -> (Player,[Player])
findBot id l = ((findById id l),(removeById id l))


-- | Dado um Play, um Maze e um Player, se a orientação do Player coincide com a do Play efetua uma jogada, caso contrário, muda a orientação para a do Play

playB :: Play -> Maze -> Player -> Player
playB (Move id o) m a | o == (orientation' a) = goahead m a
                     | otherwise = changeOrientation o a


-- | Dado um Maze e um Player devolve o Player já movido

goahead :: Maze -> Player -> Player
goahead m a 
                        |(getPlayerOrientation a == L ) && (sndC a == 0) = closedMouth (changeSnd ((y'sMaze m) - 1) a)
                        |(getPlayerOrientation a == R ) && (sndC a == ((y'sMaze m) - 1)) = closedMouth (changeSnd 0 a)

                        |(getPlayerOrientation a == R ) && ((rightPiece m a) == Empty) = closedMouth (moveTo (0,1) a)
                        |(getPlayerOrientation a == L ) && ((leftPiece m a) == Empty) = closedMouth (moveTo (0,-1) a)
                        |(getPlayerOrientation a == U ) && ((underPiece m a) == Empty) = closedMouth (moveTo (-1,0) a)
                        |(getPlayerOrientation a == D ) && ((downPiece m a) == Empty) = closedMouth (moveTo (1,0) a)

 
                        |(getPlayerOrientation a == R ) && ((rightPiece m a) == Wall) = closedMouth a
                        |(getPlayerOrientation a == L ) && ((leftPiece m a) == Wall) = closedMouth a
                        |(getPlayerOrientation a == U ) && ((underPiece m a) == Wall) = closedMouth a
                        |(getPlayerOrientation a == D ) && ((downPiece m a) == Wall) = closedMouth a


                        |(getPlayerOrientation a == R ) && ((rightPiece m a) == Food Little) = closedMouth (addP 1 (moveTo (0,1) a))
                        |(getPlayerOrientation a == L ) && ((leftPiece m a) == Food Little) = closedMouth (addP 1 (moveTo (0,-1) a))
                        |(getPlayerOrientation a == U ) && ((underPiece m a) == Food Little) = closedMouth (addP 1 (moveTo (-1,0) a))
                        |(getPlayerOrientation a == D ) && ((downPiece m a) == Food Little) = closedMouth (addP 1 (moveTo (1,0) a))


                        |(getPlayerOrientation a == R ) && ((rightPiece m a) == Food Big) = closedMouth (pMega (addP 5 (moveTo (0,1) a)))
                        |(getPlayerOrientation a == L ) && ((leftPiece m a) == Food Big) = closedMouth (pMega (addP 5 (moveTo (0,-1) a)))
                        |(getPlayerOrientation a == U ) && ((underPiece m a) == Food Big) = closedMouth (pMega (addP 5 (moveTo (-1,0) a)))
                        |(getPlayerOrientation a == D ) && ((downPiece m a) == Food Big) = closedMouth (pMega (addP 5 (moveTo (1,0) a)))

                        | otherwise = playOtherwise m a


-- | Dado um Maze e um Player devolve o Player já movido

playOtherwise :: Maze -> Player -> Player
playOtherwise m a 
                        |(getPlayerOrientation a == R ) = closedMouth (moveTo (0,1) a)
                        |(getPlayerOrientation a == L ) = closedMouth (moveTo (0,-1) a)
                        |(getPlayerOrientation a == U ) = closedMouth (moveTo (-1,0) a)
                        |(getPlayerOrientation a == D ) = closedMouth (moveTo (1,0) a)