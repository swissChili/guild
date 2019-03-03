module Parser where

import Text.ParserCombinators.Parsec
import Types

unpaddedIngredient :: GenParser Char st String
unpaddedIngredient = many1 $ noneOf " ,->\n"

ingredientParser :: GenParser Char st String
ingredientParser = (char ' ' >> unpaddedIngredient) <|> unpaddedIngredient

targetParser :: GenParser Char st Recipe
targetParser = do
  ingredient <- ingredientParser
  rest <- many $ char ',' >> ingredientParser
  -- Forgot what the string parser thing is so im using chars.
  many $ char ' '
  char '-'
  char '>'
  target <- ingredientParser
  char '\n'
  return $ Recipe target $ ingredient : rest

toplevelParser :: GenParser Char st [Recipe]
toplevelParser = do
  targets <- many1 targetParser
  return targets

parseGuild :: String -> Either ParseError [Recipe]
parseGuild i = parse toplevelParser "(unknown)" $ i ++ "\n"
