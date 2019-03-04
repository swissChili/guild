module Types where

data Recipe = Recipe String [String] SourceType
            | Variable String String
            | Comment String
            | Ignore
              deriving (Show)

data SourceType = C
                | CPlusPlus
                | Unknown
                  deriving (Show)
