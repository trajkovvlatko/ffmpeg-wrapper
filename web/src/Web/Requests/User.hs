module Web.Requests.User (User (User, name)) where

import Data.Aeson (FromJSON (parseJSON), Object, ToJSON (toJSON), object, withObject, (.:), (.=))
import Data.Aeson.Types (Parser)
import GHC.Generics (Generic)

data User = User
  { age :: Int,
    name :: String
  }
  deriving (Show, Generic)

instance FromJSON User where
  parseJSON = withObject "User" parseUser

instance ToJSON User where
  toJSON user =
    object
      [ "age" .= age user,
        "name" .= name user
      ]

parseUser :: Object -> Parser User
parseUser o = do
  n <- o .: "name"
  a <- o .: "age"
  return (User a n)
