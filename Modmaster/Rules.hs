module Modmaster.Rules where

import qualified  Cookbook.Essential.Continuous     as Ct
import qualified  Cookbook.Ingredients.Lists.Modify as Md
import qualified  Cookbook.Ingredients.Lists.Access as Ac
import qualified  Cookbook.Ingredients.Tupples.Look as Lk
import qualified  Cookbook.Recipes.Sanitize         as Sn

type Rules = [((String,String),[String])]

-- | Gets rid of uneccessary syntax, strips comments, turns all lines into one for newline-independant parsing.
prepare :: [String] -> String
prepare x = (flip Ct.remove) "emits" $ Sn.blacklist (((flip Ct.splice) ("(*","*)")) $ unlines x) ['\n','\t',' ']

-- | Splits a when statement into a into a module and signal.
whenSplit  :: String -> (String,String)
whenSplit x = (Md.between x ('(',')'),Md.between x (')','{'))

-- | Binds the body of a block with a parsed when.
whenBlocks :: String -> Rules
whenBlocks x = map (\y -> ((whenSplit ((Ct.before y '{')++"{")),(Md.splitOn (Ct.after y '{') ';'))) (Md.splitOn x '}')

-- | Works directly from what would be the contents of a file.
parse :: [String] -> Rules
parse = whenBlocks . prepare
