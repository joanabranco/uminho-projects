{-|
Module      : Tarefa4
Description : Módulo Tarefa4 que contém funções com o objetivo de reagir à passagem do tempo.
Copyright   : Joana Branco <joanabranco.23@gmail.com>;
              Rafael Ferreira <a97642@alunos.uminho.pt>

Este é o módulo correspondente à Tarefa 4 do trabalho que, através de diversas funções,
permite determinar as consequências da passagem de um instante de tempo num estado do jogo.
-}

module Tarefa4 where

import Types
import Data.Time.Clock.POSIX
import Control.Monad.IO.Class
import UI.NCurses

{- |

= Introdução

Esta tarefa foi a qual se desenvolveu para que fosse possível "movimentar" todo o tipo de jogadores
no labirinto do jogo. Passado um instante de tempo, há uma atualização no estado do jogo mas, também,
nos requerimentos necessárias para ser possível efetuar uma jogada.
Nesta parte do projeto é inserido o contexto de uma nova biblioteca: NCurses.


= Objetivos

O principal objetivo que deve ser alcançado nesta tarefa é o de que, dado um /step/ e o estado atual do jogo, 
este sofra uma atualização. A atualização a aplicar deve ter em conta as jogadas de cada tipo de jogadores presentes.
A cada instante de tempo que passa é possível determinar a resposta a cada situação com que o jogador se depare.
A função Play, implementada da Tarefa 2, passa assim a ter mais exigências

* Abertura e fecho da boca do Pacman a cada jogada;
* Perda de tempo Mega a cada jogada (quando o modo do Pacman é Mega);
* Quando se dá o término do tempo Mega, o Pacman volta ao modo Alive;
* Se todos os Pacman estão em modo Normal então, os Fantasmas devem voltar ao modo Alive;
* Dependendo da velocidade do jogador e da paridade da repetição, estes devem progredir x jogadas.


= Discussão e Conclusão

A integração da nova biblioteca NCurses trouxe alguma complexidade ao trabalho e, de tal forma, foi possível associar todas as 
ocorrências de jogada em jogada. A estratégia que adotamos para o desenvolvimento desta tarefa passou por se recorrer à função 
Play (função relativa às jogadas de qualquer jogador) e, também, às funções updateTime, nextFrame e updateControlledPlayer 
(inseridas no Main da 2ª fase) que controlam o tempo de jogo, fazem a atualização do estado atual do mesmo e permitem a intervenção 
do jogador através de comandos (teclas com setas).
Infelizmente, não foi possível atingir o objetivo final pois o jogador do tipo Ghost não sofre qualquer alteração, ou seja, não se 
movimenta, ao contrário do Pacman.

Concluindo, não conseguimos atingir o resultado pretendido mas, através do desenvolvimento desta tarefa, tivemos a oportunidade de 
visualizar jogo praticamente completo e de uma maneira mais interativa.

-}

defaultDelayTime = 250

-- | * __Função principal da Tarefa 4__ 

-- | Dado um Inteiro (Step) e um State devolve um novo State atualizado, onde todos os joadores efeturaram uma jogada

passTime :: Int  -> State -> State
passTime st (State m lP l) 
                 | elem st l' = (State m (main1 (funApp' m lP)) l)
                 | elem st l'' = (State m (main1 (funApp'' m lP)) l)


-- | Lista que representa a numeração dos Steps pares
l' :: [Int]
l' = [0,2..]

-- | Lista que representa a numeração dos Steps ímpares

l'' :: [Int]
l'' = [1,3..]


-- | Dado um Maze e uma lista de Players devolve uma lista de Players com a função play' aplicada a cada um deles, esta função é ativada para Steps pares

funApp' :: Maze -> [Player] -> [Player]
funApp' m [] = []
funApp' m (a:t) = play' m a : funApp' m t


-- | Dado um Maze e um Player é efetuada nesse Player a função playPac ou a PlayGho, dependendo do Player, um certo número de vezes, conforme a velocity do Player

play' :: Maze ->  Player -> Player
play' m p 
         | (isPac p) && ((getVel p)==0.5) = p
         | (isPac p) && ((getVel p)==1) = playPac m p
         | (isPac p) && ((getVel p)==1.5) = playPac m (playPac m p)
         | (isPac p) && ((getVel p)==2) = playPac m (playPac m p)
         | ((isPac p)==False) && ((getVel p)==0.5) = p
         | ((isPac p)==False) && ((getVel p)==1) = playGho m p
         | ((isPac p)==False) && ((getVel p)==1.5) = playGho m (playGho m p)
         | ((isPac p)==False) && ((getVel p)==2) = playGho m (playGho m p)
         | otherwise = p


-- | Dado um Maze e uma lista de Players devolve uma lista de Players com a função play'' aplicada a cada um deles, esta função é ativada para Steps ímpares

funApp'' :: Maze -> [Player] -> [Player]
funApp'' m [] = []
funApp'' m (a:t) = play'' m a : funApp'' m t


-- | Dado um Maze e um Player é efetuada nesse Player a função playPac ou a PlayGho, dependendo do Player, um certo número de vezes, conforme a velocity do Player


play'' :: Maze ->  Player -> Player
play'' m p 
         | (isPac p) && ((getVel p)==0.5) = playPac m p
         | (isPac p) && ((getVel p)==1) = playPac m p
         | (isPac p) && ((getVel p)==1.5) = playPac m p
         | (isPac p) && ((getVel p)==2) = playPac m (playPac m p)
         | ((isPac p)==False) && ((getVel p)==0.5) = playGho m p
         | ((isPac p)==False) && ((getVel p)==1) = playGho m p
         | ((isPac p)==False) && ((getVel p)==1.5) = playGho m p
         | ((isPac p)==False) && ((getVel p)==2) = playGho m (playGho m p)
         | otherwise = p


-- | Dado um Maze e um Player (Pacman) efetua uma jogada nesse Player

playPac :: Maze -> Player -> Player
playPac m a
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

                        | otherwise = playPacOtherwise m a

-- | Dado um Maze e um Player (Pacman) efetua uma jogada nesse Player

playPacOtherwise :: Maze -> Player -> Player
playPacOtherwise m a 
                        |(getPlayerOrientation a == R ) = closedMouth (moveTo (0,1) a)
                        |(getPlayerOrientation a == L ) = closedMouth (moveTo (0,-1) a)
                        |(getPlayerOrientation a == U ) = closedMouth (moveTo (-1,0) a)
                        |(getPlayerOrientation a == D ) = closedMouth (moveTo (1,0) a)


-- | Dado um Maze e um Player (Ghost) efetua uma jogada nesse Player

playGho :: Maze -> Player -> Player
playGho m a
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


-- | Dado um Maze e um Player devolve a peça à direita do Player

rightPiece :: Maze -> Player -> Piece
rightPiece m (Pacman (PacState (x,(a,b),z,t,h,l) o c d)) = whatPiece (a,b+1) m
rightPiece m (Ghost (GhoState (idG,(a,b),vG,oG,pG,l) gM)) = whatPiece (a,b+1) m


-- | Dado um Maze e um Player devolve a peça à esquerda do Player

leftPiece :: Maze -> Player -> Piece
leftPiece m (Pacman (PacState (x,(a,b),z,t,h,l) o c d)) = whatPiece (a,b-1) m
leftPiece m (Ghost (GhoState (idG,(a,b),vG,oG,pG,l) gM)) = whatPiece (a,b-1) m


-- | Dado um Maze e um Player devolve a peça abaixo do Player

underPiece :: Maze -> Player -> Piece
underPiece m (Pacman (PacState (x,(a,b),z,t,h,l) o c d)) = whatPiece (a-1,b) m
underPiece m (Ghost (GhoState (idG,(a,b),vG,oG,pG,l) gM)) = whatPiece (a-1,b) m


-- | Dado um Maze e um Player devolve a peça acima do Player

downPiece :: Maze -> Player -> Piece
downPiece m (Pacman (PacState (x,(a,b),z,t,h,l) o c d)) = whatPiece (a+1,b) m
downPiece m (Ghost (GhoState (idG,(a,b),vG,oG,pG,l) gM)) = whatPiece (a+1,b) m


-- | Dado um Player diz-nos se é Pacman quando é True

isPac :: Player -> Bool
isPac (Pacman (PacState (x,y,z,t,h,l) q c d )) = True
isPac _ = False


-- | Dado um Player devolve-nos a sua Velocity

getVel :: Player -> Double
getVel (Pacman (PacState (x,y,z,t,h,l) b c d )) = z
getVel (Ghost (GhoState (x,y,z,t,h,l) b )) = z


-- | Dadas umas Coords e um Maze devolve-nos a Piece com essas Coords no Maze

whatPiece :: Coords -> Maze -> Piece
whatPiece (a,b) maze = ( ( maze !! a ) !! b )


-- | Dadas umas Coords e um Player devolve o Player com novas Coords

nCoords :: Coords -> Player -> Player
nCoords (x,y) (Pacman (PacState (id,(a,b),v,oP,p,l) tM m pM)) = Pacman (PacState (id,(x,y),v,oP,p,l) tM m pM)
nCoords (x,y) (Ghost (GhoState (idG,(a,b),vG,oG,pG,l) gM)) = Ghost (GhoState (idG,(x,y),vG,oG,pG,l) gM)


-- | Dado um inteiro e um Player devolver o Player com novos Points resultantes da soma dos anteriores com o inteiro

addP :: Int -> Player -> Player
addP n (Pacman (PacState (id,(a,b),v,oP,p,l) tM m pM)) = Pacman (PacState (id,(a,b),v,oP,(p+n),l) tM m pM)
addP n (Ghost (GhoState (idG,(a,b),vG,oG,pG,l) gM)) = Ghost (GhoState (idG,(a,b),vG,oG,(pG+n),l) gM)


-- | Dada uma lista de Players devolve uma lista de Players que resulta da aplicação de funções à lista inicial

main1 :: [Player] -> [Player]
main1 l   | testMega (fst (separatePlayers l)) = (loseTmega ((fst (separatePlayers l)))) ++ (killGhost (snd (separatePlayers l)))
          | otherwise = ifGhoAlive (separatePlayers (ifGhoDead (separatePlayers l)))


-- | Dada uma lista de Players devolve uma nova lista que resulta de aplicar uma função aos Pacmans da lista inicial atualizando-lhes o Tempo e o Modo em Mega

loseTmega :: [Player] -> [Player]
loseTmega [] = []
loseTmega (a:t) | (isPac a) && (sayIfMega a) = takeTmega a : loseTmega t
                | otherwise = a : loseTmega t


-- | Dado um Player devolve o mesmo Player com menos Tempo Mega, se o Tempo Mega é Zero o Player passa ao Modo Normal

takeTmega :: Player -> Player
takeTmega (Pacman (PacState (id,(a,b),v,oP,p,l) tM m Mega))
            | tM <= 250 = Pacman (PacState (id,(a,b),v,oP,p,l) 0 m Normal)
            | tM > 250 =  Pacman (PacState (id,(a,b),v,oP,p,l) (tM-250) m Mega)


-- | Dada uma lista de Players devolver um tuplo cuja primeira lista contém Pacmans e a segunda Ghosts

separatePlayers :: [Player] -> ([Player],[Player])
separatePlayers [] = ([],[])
separatePlayers (a:b) | isPac a = (a:x,y)
                      | otherwise = (x,a:y) 
                        where (x,y) = separatePlayers b


-- | Dada uma lista de Players devolve True se a lista contém Pacmans em Modo Mega, caso contrário, False

testMega :: [Player] -> Bool
testMega [] = False
testMega (a:t)
            | isPac a = if sayIfMega a then True
                        else testMega t
            | isPac a == False = testMega t


-- | Dado um Player devolve True se o Modo for Mega, caso contrário, False

sayIfMega :: Player -> Bool
sayIfMega a | pacMode a == Mega = True
            | otherwise = False


-- | Dada uma lista de Players Ghost devolve uma lista com todos esses Ghosts em Modo Dead

killGhost :: [Player] -> [Player]
killGhost [] = []
killGhost (Ghost (GhoState a Alive) : xs) = Ghost (GhoState a Dead) : killGhost xs
killGhost (Ghost (GhoState a Dead) : xs) = Ghost (GhoState a Dead) : killGhost xs


-- | Dado um Player qualquer que seja o Modo devolve o Player no Modo Mega

pMega :: Player -> Player
pMega (Pacman (PacState (x,y,z,t,h,l) b d c)) = Pacman (PacState (x,y,z,t,h,l) b d Mega)


-- | Dada um tuplo, cujas componentes sao listas de Players devolve uma lista de Players

ifGhoDead :: ([Player],[Player]) -> [Player]
ifGhoDead (p,g) | testGhoDeadList g = eatGho (p,g)
                | otherwise = p ++ g


-- | Dada uma lista de Ghosts devolve True, se há algum em Modo Dead, caso contrário, devolve False

testGhoDeadList :: [Player] -> Bool
testGhoDeadList [] = False
testGhoDeadList (a:t) | ghoMode a == Dead = True
                      | otherwise = testGhoDeadList t


-- | Dado um tuplo com listas de Players devolve uma lista de Players

eatGho :: ([Player],[Player]) -> [Player]
eatGho (l,[]) = l
eatGho ([],l) = l
eatGho ((a:x),g) = ((findGhoDead a g) : eatGho (x,g)) ++ g


-- | Dado um Player e uma lista de Ghosts acrescenta dez Points ao Player se as Coords coincidem com as de um Ghost Dead

findGhoDead :: Player -> [Player] -> Player
findGhoDead p [] = p
findGhoDead p (a:t) | compareC p a = addP 10 p
                    | otherwise = findGhoDead p t


--  | Dados dois Players devolve True se as suas Coords são iguais, caso contrário, False

compareC :: Player -> Player -> Bool
compareC p g | (getC p) == (getC g) = True
             | otherwise = False


-- | Dada um tuplo, cujas componentes sao listas de Players devolve uma lista de Players

ifGhoAlive :: ([Player],[Player]) -> [Player]
ifGhoAlive ([],l) = l
ifGhoAlive (l,[]) = l
ifGhoAlive (p,g) | testGhoAliveList g = losePoints (p,g)
                 | otherwise = p ++ g


-- | Dada uma lista de Ghosts devolve True, se há algum em Modo Alive, caso contrário, devolve False

testGhoAliveList :: [Player] -> Bool
testGhoAliveList [] = False
testGhoAliveList (a:t) | ghoMode a == Alive = True
                       | otherwise = testGhoAliveList t


-- | Dado um tuplo com duas lista de Players devolve uma lista de Players que resulta de concatenar ambas após aplicar funções à primeira

losePoints :: ([Player],[Player]) -> [Player]
losePoints ([],l) = l
losePoints (l,[]) = l
losePoints ((a:x),g) = ((findGhoAlive a g) : losePoints (x,g)) ++ g


-- | Dado um Player e uma lista de Ghosts remove Lives ao Player se as Coords coincidem com as de um Ghost Alive

findGhoAlive :: Player -> [Player] -> Player
findGhoAlive p [] = p
findGhoAlive p (a:t) | compareC p a = loseLives p
                     | otherwise = findGhoAlive p t


-- | Dado um Maze e um Player (Ghost) leva esse Player para o centro do Maze

takeGhost :: Maze -> Player -> Player
takeGhost m a = nCoords (centerTunnel m) a


-- | Dado um Pacman retira-lhe uma Live sempre que este tem até zero vidas, quando este já tem zero muda-lhe o Modo para Dying

loseLives :: Player -> Player
loseLives (Pacman (PacState (idP, (x,y), v, oP, p, l) tM mouth Normal))
                            | l>1 = (Pacman (PacState (idP, (x,y), v, oP, p, (l-1)) tM mouth Normal))
                            | l==1 = (Pacman (PacState (idP, (x,y), v, oP, p, 0) tM mouth Normal))
                            | l==0 = (Pacman (PacState (idP, (x,y), v, oP, p, 0) tM mouth Dying))


-- | Dado um maze devolve as Coords do centro do Maze

centerTunnel :: Maze -> Coords
centerTunnel maze = ( ( (lMaze maze) `div` 2 ), ( (y'sMaze maze) `div` 2) )


-- | Dado um Player do tipo Pacman devolve o seu Modo

pacMode :: Player -> PacMode
pacMode (Pacman (PacState (id,(a,b),v,oP,p,l) tM m pM)) = pM


-- | Dado um Player do tipo Ghost devolve o seu Modo

ghoMode :: Player -> GhostMode
ghoMode (Ghost (GhoState (idG,(a,b),vG,oG,pG,l) Alive)) = Alive
ghoMode (Ghost (GhoState (idG,(a,b),vG,oG,pG,l) Dead)) = Dead


-- | Dado um Player devolve as suas Coords

getC :: Player -> Coords
getC (Ghost (GhoState (idG,(a,b),vG,oG,pG,l) gM)) = (a,b)
getC (Pacman (PacState (id,(a,b),v,oP,p,l) tM m pM)) = (a,b)


-- | Dado um Player devolve o Estado da Mouth

getMouth :: Player -> Mouth
getMouth (Pacman (PacState (id,c,v,oP,p,l) tM m pM)) = m


-- | Dado um Player muda-lhe o Estado da Mouth para Open se estiver Closed e vice-versa

closedMouth :: Player -> Player
closedMouth (Pacman (PacState (id,c,v,oP,p,l) tM Open m)) = Pacman (PacState (id,c,v,oP,p,l) tM Closed m)
closedMouth (Pacman (PacState (id,c,v,oP,p,l) tM Closed m)) = Pacman (PacState (id,c,v,oP,p,l) tM Open m)


-- | Dado um par de inteiros e um Player devolve-nos as novas Coords do Player que resulta de adicionar às iniciais as componentes do par

moveTo :: (Int,Int) -> Player -> Player
moveTo (n,t) (Pacman (PacState (id,(a,b),v,oP,p,l) tM m pM)) = Pacman (PacState (id,(a+n,b+t),v,oP,p,l) tM m pM)
moveTo (n,t) (Ghost (GhoState (idG,(a,b),vG,oG,pG,l) gM)) = Ghost (GhoState (idG,(a+n,b+t),vG,oG,pG,l) gM)


-- | Dado um Player devolve a segunda componente das Coords desse Player

sndC :: Player -> Int
sndC (Pacman (PacState (id,(a,b),v,oP,p,l) tM m pM)) = b
sndC (Ghost (GhoState (idG,(a,b),vG,oG,pG,l) gM)) = b


-- | Dado um Maze de devolve o comprimento dos corredores do Maze

y'sMaze :: Maze -> Int
y'sMaze [] = 0
y'sMaze maze = length (head maze)


-- | Dado um Maze devolve a altura do Maze

lMaze :: Maze -> Int
lMaze [] = 0
lMaze maze = length maze


-- | Dado um inteiro e um Player é devolvido o mesmo Player agora com a segunda componente da sua Coord correspondente ao inteiro dado

changeSnd :: Int -> Player -> Player
changeSnd c (Pacman (PacState (id,(a,b),v,oP,p,l) tM m pM)) = Pacman (PacState (id,(a,c),v,oP,p,l) tM m pM)
changeSnd c (Ghost (GhoState (idG,(a,b),vG,oG,pG,l) gM)) = Ghost (GhoState (idG,(a,c),vG,oG,pG,l) gM)
