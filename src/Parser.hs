module Parser where

import Text.ParserCombinators.Parsec
import Text.Parsec.Char
import Types

unpaddedIngredient :: GenParser Char st String
unpaddedIngredient = many1 $ noneOf " ,()\n"

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

toplevelParser :: GenParser Char st [Recipe]
toplevelParser = do
  targets <- many1 targetParser
  return targets

parseGuild :: String -> Either ParseError [Recipe]
parseGuild i = parse toplevelParser "(unknown)" $ i ++ "\n"
