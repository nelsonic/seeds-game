module Helpers.Dict exposing
    ( filterValues
    , find
    , findValue
    , indexedDictFrom
    , insertWith
    , mapValues
    )

import Dict exposing (Dict)


mapValues : (a -> b) -> Dict comparable a -> Dict comparable b
mapValues f =
    Dict.map <| always f


filterValues : (b -> Bool) -> Dict comparable b -> Dict comparable b
filterValues f =
    Dict.filter <| always f


insertWith : (a -> a -> a) -> comparable -> a -> Dict comparable a -> Dict comparable a
insertWith f k v dict =
    if Dict.member k dict then
        Dict.update k (Maybe.map (\x -> f v x)) dict

    else
        Dict.insert k v dict


indexedDictFrom : Int -> List a -> Dict Int a
indexedDictFrom n xs =
    xs
        |> List.indexedMap (\i x -> ( i + n, x ))
        |> Dict.fromList


findValue : (a -> Bool) -> Dict comparable a -> Maybe ( comparable, a )
findValue f =
    find <| always f


find : (comparable -> a -> Bool) -> Dict comparable a -> Maybe ( comparable, a )
find predicate =
    let
        findItem_ predicate_ k v acc =
            case acc of
                Just _ ->
                    acc

                Nothing ->
                    if predicate_ k v then
                        Just ( k, v )

                    else
                        Nothing
    in
    Dict.foldl (findItem_ predicate) Nothing
