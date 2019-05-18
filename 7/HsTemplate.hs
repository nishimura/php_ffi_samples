module HsTemplate where

import Control.Monad.IO.Class
import Text.ParserCombinators.Parsec hiding(try)
import Text.Parsec.Prim

type Callback = String -> String -> IO String
type HtmlParser a = ParsecT [Char] Callback IO a


parse :: String -> (String -> String -> IO String) -> IO String
parse a f = do
  ret <- runParserT document f "" a
  case ret of
    Right ok -> return ok
    Left err -> return $ show err

io :: IO String
io = return "a"

document :: HtmlParser String
document = do
  ret <- many body
  eof
  return $ concat ret

body :: HtmlParser String
body = try(variable) <|> text

variable :: HtmlParser String
variable = do
  v <- between (string "{$") (char '}') runVar
  return v

runVar :: HtmlParser String
runVar = do
  v <- varName
  f <- getState
  let a :: IO String
      a = (f "var" v)
  liftIO a

varName :: HtmlParser String
varName = many1 (alphaNum <|> oneOf "_." <?> "varName")


text :: HtmlParser String
text = do
  c <- anyChar
  return [c]
