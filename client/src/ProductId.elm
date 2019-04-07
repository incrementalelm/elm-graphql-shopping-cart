module ProductId exposing (ProductId, selection)

import Graphql.SelectionSet as SelectionSet exposing (SelectionSet)


type ProductId
    = ProductId


selection : SelectionSet ProductId typeContext
selection =
    SelectionSet.succeed ProductId
