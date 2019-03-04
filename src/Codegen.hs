module Codegen where

import Types
import Data.List

rev = foldl l [] where l = \acc x -> x : acc

prefix :: Eq a => [a] -> [a] -> Bool
prefix [] _ = True
prefix (_:_) [] = False
prefix (x:xs) (y:ys) = x == y && prefix xs ys

suffix x y = prefix (rev x) (rev y)
varsEq (Variable k1 _) (Variable k2 _) = k1 == k2
varsEq _ _ = False
filterVars = nubBy varsEq

genCompileCommands t C
  | suffix ".o" t = "$(CC) -c -o $@ $^ $(CFLAGS)"
  | suffix ".a" t = "$(AR) rcs $@ $^ $(ARFLAGS)"
  | otherwise     = "$(CC) -o $@ $^ $(CFLAGS)"
genCompileCommands t CPlusPlus
  | suffix ".o" t = "$(CPPC) -c -o $@ $^ $(CPPFLAGS)"
  | suffix ".a" t = "$(AR) rcs $@ $^ $(ARFLAGS)"
  | otherwise     = "$(CPPC) -o $@ $^ $(CPPFLAGS)"
genCompileCommands t Unknown
  | suffix ".o" t = "echo could not figure out how to build $@ from $^"
  | suffix ".a" t = "$(AR) rcs $@ $^"
  | otherwise     = "echo idk"

genMakefileRec :: [Recipe] -> String -> String
genMakefileRec [] c = c
genMakefileRec ((Variable name binding):xs) c = genMakefileRec xs gen
  where
    gen = c ++ name ++ " = " ++ binding ++ "\n"
genMakefileRec ((Recipe target source sourceType):xs) c = genMakefileRec xs gen
  where
    gen = c ++ target ++ " : " ++ sp ++ "\n\t" ++ commands ++ "\n"
    commands = genCompileCommands target sourceType
    sp = intercalate " " source
genMakefileRec ((Comment label):xs) c = genMakefileRec xs gen
  where gen = c ++ "#" ++ label ++ "\n"
genMakefileRec ((Ignore):xs) c = genMakefileRec xs c

genMakefile i = genMakefileRec f ""
  where f = rev $ filterVars $ rev i
