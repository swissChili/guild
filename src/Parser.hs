module Parser where

import Text.ParserCombinators.Parsec
import Text.Parsec.Char
import Types

unpaddedIngredient :: GenParser Char st String
unpaddedIngredient = many1 $ noneOf " #=,()\n"

ingredientParser :: GenParser Char st String
ingredientParser = (char ' ' >> unpaddedIngredient) <|> unpaddedIngredient

sourceTypeParser :: GenParser Char st SourceType
sourceTypeParser = do
  ws
  char '('
  ws
  match <- many $ noneOf " \n\t()"
  ws
  char ')'
  endOfLine
  case match of
    "c"    -> return C
    "c++"  -> return CPlusPlus
    _      -> return Unknown
  where
    ws = many $ char ' '

unknownSourceType :: GenParser Char st SourceType
unknownSourceType = do
  endOfLine
  return Unknown

targetParser :: GenParser Char st Recipe
targetParser = do
  ingredient <- ingredientParser
  rest <- many $ char ',' >> ingredientParser
  many1 $ char ' '
  string "->"
  target <- ingredientParser
  sourceType <- sourceTypeParser <|> unknownSourceType
  return $ Recipe target (ingredient : rest) sourceType

varParser :: GenParser Char st Recipe
varParser = do
  var <- ingredientParser
  many $ char ' '
  char '='
  binding <- ingredientParser
  endOfLine
  return $ Variable var binding

commentParser :: GenParser Char st Recipe
commentParser = do
  char '#'
  label <- many $ noneOf "\n"
  char '\n'
  return $ Comment label

topLevel = try commentParser
        <|>try varParser
        <|>try targetParser

toplevelParser :: GenParser Char st [Recipe]
toplevelParser = many1 topLevel

parseGuild :: String -> Either ParseError [Recipe]
parseGuild i = parse toplevelParser "(unknown)" $ i ++ "\n"
