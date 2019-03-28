module Discount exposing (Discount, selection)

import Api.Union
import Api.Union.DiscountedProductInfoOrError
import Graphql.SelectionSet as SelectionSet


type Discount
    = Discount


selection : SelectionSet.SelectionSet Discount Api.Union.DiscountedProductInfoOrError
selection =
    SelectionSet.succeed Discount
