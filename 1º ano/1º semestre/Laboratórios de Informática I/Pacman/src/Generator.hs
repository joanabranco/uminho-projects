{-|
Module      : Generator
Description : Módulo Generator que contém os construtores que vão ser usados na Tarefa1, Tarefa2 e Tarefa3
Copyright   : Joana Branco <joanabranco.23@gmail.com>;
              Rafael Ferreira <a97642@alunos.uminho.pt>


Este módulo contém os construtores que vão ser usados posteriormente neste projeto
para que se possa apresentar uma amostra do jogo "Pacman".
-}

module Generator where

import System.Random

type Maze = [Corridor]
type Corridor = [Piece]
data Piece = Food FoodType | Wall | Empty
data FoodType = Big | Little

instance Show Piece where
    show (Food Big) = "o"
    show (Food Little) = "."
    show (Wall) = "#"
    show (Empty) = " "