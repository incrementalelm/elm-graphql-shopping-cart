module ProductId exposing (ProductId, linkTo, selection)

import Element exposing (Element)
import Graphql.SelectionSet as SelectionSet exposing (SelectionSet)


type ProductId
    = ProductId


selection : SelectionSet ProductId typeContext
selection =
    SelectionSet.succeed ProductId


linkTo : ProductId -> List (Element.Attribute msg) -> Element msg -> Element msg
linkTo productId attributes label =
    Element.link attributes
        { url = "/item"
        , label = label
        }
