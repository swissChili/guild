module Codegen where

import Types
import Data.List

rev :: [a] -> [a]  
rev = foldl l [] where l = \acc x -> x : acc

prefix :: String -> String -> Bool
prefix [] _ = True
prefix (_:_) [] = False
prefix (x:xs) (y:ys) = x == y && prefix xs ys

suffix x y = prefix (rev x) (rev y)

genCompileCommands :: String -> [String] -> SourceType -> String
genCompileCommands t s C
  | suffix ".o" t = "$(CC) -c -o $@ $^ $(CFLAGS)"
  | suffix ".a" t = "$(AR) rcs $@ $^ $(ARFLAGS)"
  | otherwise     = "$(CC) -o $@ $^ $(CFLAGS)"
genCompileCommands t s CPlusPlus
  | suffix ".o" t = "$(CPPC) -c -o $@ $^ $(CPPFLAGS)"
  | suffix ".a" t = "$(AR) rcs $@ $^ $(ARFLAGS)"
  | otherwise     = "$(CPPC) -o $@ $^ $(CPPFLAGS)"
genCompileCommands t s Unknown
  | suffix ".o" t = "echo could not figure out how to build $@ from $^"
  | suffix ".a" t = "$(AR) rcs $@ $^"
  | otherwise     = "echo idk"

genMakefileRec :: [Recipe] -> String -> String
genMakefileRec [] c = c
genMakefileRec ((Recipe target source sourceType):xs) c = genMakefileRec xs gen
  where
    gen = c ++ target ++ " : " ++ sp ++ "\n\t" ++ commands ++ "\n"
    commands = genCompileCommands target source sourceType
    sp = intercalate " " source

genMakefile i = genMakefileRec i ""
