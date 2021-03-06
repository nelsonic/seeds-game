module Scenes.Level.LineDrag exposing (LineViewModel, handleLineDrag)

import Css.Style as Style
import Css.Unit exposing (px)
import Data.Board.Move.Square exposing (hasSquareTile)
import Data.Board.Moves exposing (currentMoveTileType, lastMove)
import Data.Board.Tile as Tile
import Data.Board.Types exposing (Board, BoardDimensions)
import Data.Pointer exposing (Pointer)
import Data.Window exposing (Window)
import Helpers.Svg exposing (height_, width_, windowViewBox_)
import Html exposing (Html, span)
import Svg exposing (..)
import Svg.Attributes exposing (..)
import Views.Board.Styles exposing (..)


type alias LineViewModel =
    { window : Window
    , boardDimensions : BoardDimensions
    , board : Board
    , isDragging : Bool
    , pointer : Pointer
    }


handleLineDrag : LineViewModel -> Html msg
handleLineDrag model =
    if model.isDragging && hasSquareTile model.board |> not then
        lineDrag model

    else
        span [] []


lineDrag : LineViewModel -> Html msg
lineDrag model =
    let
        window =
            model.window

        ( oY, oX ) =
            lastMoveOrigin model

        strokeColor =
            currentMoveTileType model.board
                |> Maybe.map strokeColors
                |> Maybe.withDefault ""

        tileScale =
            Tile.scale window
    in
    svg
        [ width_ <| toFloat window.width
        , height_ <| toFloat window.height
        , windowViewBox_ window
        , class "fixed top-0 right-0 z-4 touch-disabled"
        ]
        [ line
            [ Style.svgStyle [ Style.stroke strokeColor ]
            , strokeWidth <| String.fromFloat <| 6 * tileScale
            , strokeLinecap "round"
            , x1 <| String.fromFloat oX
            , y1 <| String.fromFloat oY
            , x2 <| String.fromInt model.pointer.x
            , y2 <| String.fromInt model.pointer.y
            ]
            []
        ]


lastMoveOrigin : LineViewModel -> ( Float, Float )
lastMoveOrigin model =
    let
        window =
            model.window

        tileScale =
            Tile.scale window

        ( ( y, x ), _ ) =
            lastMove model.board

        y1 =
            toFloat y

        x1 =
            toFloat x

        sY =
            Tile.baseSizeY * tileScale

        sX =
            Tile.baseSizeX * tileScale

        tileViewModel =
            ( model.window, model.boardDimensions )

        offsetY =
            boardOffsetTop tileViewModel |> toFloat

        offsetX =
            (window.width - boardWidth tileViewModel) // 2 |> toFloat
    in
    ( ((y1 + 1) * sY) + offsetY - (sY / 2)
    , ((x1 + 1) * sX) + offsetX - (sX / 2) + 1
    )
