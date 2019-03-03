module Codegen where

import Types
import Data.List

rev :: [a] -> [a]  
rev = foldl (\acc x -> x : acc) [] 

prefix :: String -> String -> Bool
prefix [] _ = True
prefix (_:_) [] = False
prefix (x:xs) (y:ys) = x == y && prefix xs ys

suffix x y = prefix (rev x) (rev y)

genCompileCommands :: String -> [String] -> String
genCompileCommands t s
  | suffix ".o" t = "gcc -c -o $@ $^"
  | suffix ".a" t = "ar rcs $@ $^"
  | otherwise = "gcc -o $@ $^"

genMakefileRec :: [Recipe] -> String -> String
genMakefileRec [] c = c
genMakefileRec ((Recipe t s):xs) c = genMakefileRec xs gen
  where
    gen = c ++ t ++ ":" ++ sp ++ "\n\t" ++ genCompileCommands t s ++ "\n"
    sp = intercalate " " s

genMakefile i = genMakefileRec i ""
