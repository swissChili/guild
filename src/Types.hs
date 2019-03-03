module Types where

data Recipe = Recipe String [String] SourceType
              deriving (Show)

data SourceType = C
                | CPlusPlus
                | Unknown
                  deriving (Show)
