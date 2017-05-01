module Data.Board.Shift exposing (..)

import Model exposing (..)
import List.Extra exposing (groupWhile)
import Dict


handleShiftBoard : Model -> Model
handleShiftBoard model =
    let
        newBoard =
            model.board
                |> removeTiles model.currentMove
                |> shiftBoard
    in
        { model | board = newBoard }


shiftBoard : Board -> Board
shiftBoard board =
    board
        |> Dict.toList
        |> List.sortBy xCoord
        |> groupWhile sameColumn
        |> List.concatMap shiftRow
        |> Dict.fromList


shiftRow : List Move -> List Move
shiftRow row =
    row
        |> List.sortBy yCoord
        |> List.unzip
        |> shiftTiles


sameColumn : Move -> Move -> Bool
sameColumn ( ( _, x1 ), _ ) ( ( _, x2 ), _ ) =
    x1 == x2


yCoord : ( Coord, Tile ) -> Int
yCoord ( ( y, _ ), _ ) =
    y


xCoord : ( Coord, Tile ) -> Int
xCoord ( ( _, x ), _ ) =
    x


shiftTiles : ( List Coord, List Tile ) -> List Move
shiftTiles ( coords, tiles ) =
    let
        sorted =
            tiles
                |> List.partition ((==) Blank)
                |> (\( a, b ) -> a ++ b)

        x =
            List.head coords
                |> Maybe.map Tuple.second
                |> Maybe.withDefault 0
    in
        List.indexedMap (\i tile -> ( ( i, x ), tile )) sorted


removeTiles : List Move -> Board -> Board
removeTiles moves board =
    board
        |> Dict.map (convertToBlank moves)


convertToBlank : List Move -> Coord -> Tile -> Tile
convertToBlank moves coordToCheck tile =
    if List.member coordToCheck (coordsList moves) then
        Blank
    else
        tile


coordsList : List Move -> List Coord
coordsList moves =
    moves |> List.map Tuple.first
