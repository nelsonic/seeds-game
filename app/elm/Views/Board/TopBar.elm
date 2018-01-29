module Views.Board.TopBar exposing (..)

import Data.Color exposing (gold, washedYellow)
import Data.Level.Board.Tile exposing (seedBackgrounds)
import Data.Level.Score exposing (getScoreFor, scoreTileTypes, scoreToString)
import Helpers.Style exposing (..)
import Html exposing (..)
import Html.Attributes exposing (..)
import Scenes.Level.Types as Level exposing (..)
import Views.Icons.Tick exposing (tickBackground)


topBar : Level.Model -> Html msg
topBar model =
    div
        [ class "no-select w-100 flex items-center justify-center fixed top-0 z-3"
        , style
            [ heightStyle model.topBarHeight
            , color gold
            , backgroundColor washedYellow
            ]
        ]
        [ div
            [ style
                [ marginTop -16
                , ( "padding", "0 9px" )
                ]
            , class "flex justify-center"
            ]
            (List.map (renderScore model) (scoreTileTypes model.tileSettings))
        ]


renderScore : Level.Model -> TileType -> Html msg
renderScore model tileType =
    let
        scoreMargin =
            model.scoreIconSize // 2
    in
        div
            [ class "relative tc"
            , style
                [ marginRight scoreMargin
                , marginLeft scoreMargin
                ]
            ]
            [ renderScoreIcon model tileType
            , p
                [ class "ma0 absolute left-0 right-0 f6"
                , style [ ( "bottom", "-1.5em" ) ]
                ]
                [ renderScoreText model.scores tileType ]
            ]


renderScoreText : Scores -> TileType -> Html msg
renderScoreText scores tileType =
    if getScoreFor tileType scores == Just 0 then
        div [ class "relative" ]
            [ div
                [ style
                    [ topStyle 1
                    , transformStyle <| scale 0
                    , animationStyle "bulge 0.6s ease"
                    , fillForwards
                    , animationDelayStyle 800
                    ]
                , class "absolute top-0 left-0 right-0"
                ]
                [ tickBackground ]
            , div
                [ style
                    [ animationStyle "fade-out 0.5s linear"
                    , fillForwards
                    , opacityStyle 1
                    ]
                ]
                [ text <| scoreToString tileType scores ]
            ]
    else
        text <| scoreToString tileType scores


renderScoreIcon : Level.Model -> TileType -> Html msg
renderScoreIcon model tileType =
    case tileType of
        Sun ->
            scoreIcon model "img/sun.svg"

        Rain ->
            scoreIcon model "img/rain.svg"

        Seed seedType ->
            scoreIcon model <| seedBackgrounds seedType

        _ ->
            span [] []


scoreIcon : Level.Model -> String -> Html msg
scoreIcon { scoreIconSize } url =
    div
        [ class "bg-center contain"
        , style
            [ backgroundImage url
            , widthStyle scoreIconSize
            , heightStyle scoreIconSize
            ]
        ]
        []
