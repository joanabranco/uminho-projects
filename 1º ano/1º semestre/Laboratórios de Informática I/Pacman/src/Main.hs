module Main where

import Data.Time.Clock.POSIX
import Control.Monad.IO.Class
import UI.NCurses
import Types
import FileUtils
import Tarefa4
import Tarefa5
import Tarefa6


data Manager = Manager 
    {   
        state   :: State
    ,    pid    :: Int
    ,    step   :: Int
    ,    before :: Integer
    ,    delta  :: Integer
    ,    delay  :: Integer
    } 


loadManager :: Manager
loadManager = ( Manager (loadMaze "maps/1.txt") 0 0 0 0 defaultDelayTime )

updateControlledPlayer :: Key -> Manager -> Manager
updateControlledPlayer k (Manager (State m lP l) pid step b d dt)
 | k == KeyLeftArrow  = (Manager (State m ( (putL (findById pid lP)) : (removeById pid lP) ) l) pid step b d dt)
 | k == KeyRightArrow = (Manager (State m ( (putR (findById pid lP)) : (removeById pid lP) ) l) pid step b d dt)
 | k == KeyUpArrow    = (Manager (State m ( (putU (findById pid lP)) : (removeById pid lP) ) l) pid step b d dt)
 | k == KeyDownArrow  = (Manager (State m ( (putD (findById pid lP)) : (removeById pid lP) ) l) pid step b d dt)


putL :: Player -> Player
putL (Ghost (GhoState (idG,cG,vG,oG,pG,l) gM)) = (Ghost (GhoState (idG,cG,vG,L,pG,l) gM))
putL (Pacman (PacState (id,c,v,oP,p,l) tM m pM)) = (Pacman (PacState (id,c,v,L,p,l) tM m pM))

putR :: Player -> Player
putR (Ghost (GhoState (idG,cG,vG,oG,pG,l) gM)) = (Ghost (GhoState (idG,cG,vG,R,pG,l) gM))
putR (Pacman (PacState (id,c,v,oP,p,l) tM m pM)) = (Pacman (PacState (id,c,v,R,p,l) tM m pM))

putU :: Player -> Player
putU (Ghost (GhoState (idG,cG,vG,oG,pG,l) gM)) = (Ghost (GhoState (idG,cG,vG,U,pG,l) gM))
putU (Pacman (PacState (id,c,v,oP,p,l) tM m pM)) = (Pacman (PacState (id,c,v,U,p,l) tM m pM))

putD :: Player -> Player
putD (Ghost (GhoState (idG,cG,vG,oG,pG,l) gM)) = (Ghost (GhoState (idG,cG,vG,D,pG,l) gM))
putD (Pacman (PacState (id,c,v,oP,p,l) tM m pM)) = (Pacman (PacState (id,c,v,D,p,l) tM m pM))



updateScreen :: Window  -> ColorID -> Manager -> Curses ()
updateScreen w a man =
                  do
                    updateWindow w $ do
                      clear
                      setColor a
                      moveCursor 0 0 
                      drawString $ show (state man)
                    render
     
currentTime :: IO Integer
currentTime = fmap ( round . (* 1000) ) getPOSIXTime


updateTime :: Integer -> Manager -> Manager
updateTime n (Manager s pid step b d dt)
              | d < 250  = (Manager s pid step n (d+(n-b)) dt)
              | otherwise = resetTimer n (Manager s pid step b d dt)


resetTimer :: Integer -> Manager -> Manager
resetTimer n (Manager s pid step b d dt) = (Manager s pid step n 0 dt)
-----

nextFrame :: Integer -> Manager -> Manager
nextFrame n (Manager (State m lP l) pid step b d dt)
               | d >= 250 = resetTimer n (Manager (passTime step (State m lP l)) pid (step+1) b d dt)


loop :: Window -> Manager -> Curses ()
loop w man@(Manager s pid step bf delt del ) = do 
  color_schema <- newColorID ColorBlue ColorWhite  10
  now <- liftIO  currentTime
  updateScreen w  color_schema man
  if ( delt > del )
    then loop w $ nextFrame now man
    else do
          ev <- getEvent w $ Just 0
          case ev of
                Nothing -> loop w (updateTime now man)
                Just (EventSpecialKey arrow ) -> loop w $ updateControlledPlayer arrow (updateTime now man)
                Just ev' ->
                  if (ev' == EventCharacter 'q')
                    then return ()
                    else loop w (updateTime now man)

main :: IO ()
main =
  runCurses $ do
    setEcho False
    setCursorMode CursorInvisible
    w <- defaultWindow
    loop w loadManager
