module Main where

import System.IO
import Parser
import Codegen
import Defaults

main :: IO ()
main = do
  f <- readFile "guildfile"
  case parseGuild f of
    Right i -> putStr $ genMakefile $ defaults ++ i
    Left _ -> putStrLn "Cannot generate makefile from incorrect parse"
