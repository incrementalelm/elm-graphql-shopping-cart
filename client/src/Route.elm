module Route exposing (Route(..))

import ProductId exposing (ProductId)
import Url.Parser as Parser


type Route
    = Home
    | Product
