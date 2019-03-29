module Request exposing (query)

import Graphql.Document as Document
import Graphql.Http
import Graphql.Operation exposing (RootQuery)
import Graphql.SelectionSet as SelectionSet exposing (SelectionSet)
import RemoteData exposing (RemoteData)


query :
    (RemoteData (Graphql.Http.Error decodesTo) decodesTo -> msg)
    -> SelectionSet decodesTo RootQuery
    -> Cmd msg
query msgConstructor querySelection =
    querySelection
        |> Graphql.Http.queryRequest "http://localhost:4000/"
        |> Graphql.Http.send (\result -> result |> RemoteData.fromResult |> msgConstructor)
