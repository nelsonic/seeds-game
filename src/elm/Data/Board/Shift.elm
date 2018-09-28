module Data.Board.Shift exposing
    ( groupBoardByColumn
    , shiftBoard
    , yCoord
    )

import Data.Board.Block as Block
import Data.Board.Types exposing (..)
import Dict
import List.Extra


shiftBoard : Board -> Board
shiftBoard board =
    board
        |> groupBoardByColumn
        |> List.concatMap shiftRow
        |> Dict.fromList


groupBoardByColumn : Board -> List (List Move)
groupBoardByColumn board =
    board
        |> Dict.toList
        |> List.sortBy xCoord
        |> List.Extra.groupWhile sameColumn
        -- WARNING quick fix need to check!
        |> List.map Tuple.second


shiftRow : List Move -> List Move
shiftRow row =
    row
        |> List.sortBy yCoord
        |> shiftRemainingTiles


shiftRemainingTiles : List Move -> List Move
shiftRemainingTiles row =
    row
        |> sortByLeaving
        |> List.indexedMap (\i ( _, block ) -> ( ( i, getXfromRow row ), block ))


sortByLeaving : List Move -> List Move
sortByLeaving row =
    let
        walls =
            List.filter (\( _, block ) -> Block.isWall block) row
    in
    row
        |> List.filter (\( _, block ) -> not (Block.isWall block))
        |> List.partition (\( coord, block ) -> Block.isLeaving block)
        |> (\( a, b ) -> a ++ b)
        |> reAddWalls walls


reAddWalls : List Move -> List Move -> List Move
reAddWalls walls row =
    List.foldl addWall row walls


addWall : Move -> List Move -> List Move
addWall (( ( y, x ), w ) as wall) row =
    row
        |> List.Extra.splitAt y
        |> (\( a, b ) -> a ++ [ wall ] ++ b)


getXfromRow : List Move -> Int
getXfromRow coords =
    coords
        |> List.head
        |> Maybe.map Tuple.first
        |> Maybe.map Tuple.second
        |> Maybe.withDefault 0


sameColumn : Move -> Move -> Bool
sameColumn ( ( _, x1 ), _ ) ( ( _, x2 ), _ ) =
    x1 == x2


yCoord : ( Coord, Block ) -> Int
yCoord ( ( y, _ ), _ ) =
    y


xCoord : ( Coord, Block ) -> Int
xCoord ( ( _, x ), _ ) =
    x
