module Redis (saveCommand, publishTask, RedisError (..)) where

import Control.Monad.IO.Class (MonadIO (liftIO))
import Data.String (IsString (fromString))
import Database.Redis (Redis, Reply, checkedConnect, defaultConnectInfo, get, lrange, publish, rpush, runRedis, set)

data RedisError
  = CannotSaveCommand
  | CannotConnectToRedis
  deriving (Show)

saveCommand :: String -> String -> IO (Either Reply Integer)
saveCommand id command = do
  conn <- checkedConnect defaultConnectInfo
  runRedis conn $ do
    set (fromString id) (fromString command)
    rpush "tasks_list" [fromString id]

publishTask :: String -> IO (Either Reply Integer)
publishTask id = do
  conn <- checkedConnect defaultConnectInfo
  runRedis conn $ publish "register_task" (fromString id)
