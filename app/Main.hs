module Main where

import System.IO
import Parser
import Codegen

main :: IO ()
main = do
  f <- readFile "guildfile"
  case parseGuild f of
    Right i -> putStr $ genMakefile i
    Left _ -> putStrLn "Cannot generate makefile from incorrect parse"
