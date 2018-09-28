module Views.Hub.World exposing
    ( currentLevelPointer
    , handleStartLevel
    , offsetStyles
    , renderIcon
    , renderLevel
    , renderNumber
    , renderWorld
    , renderWorlds
    , showInfo
    )

import Config.Levels exposing (allLevels)
import Data.Board.Types exposing (..)
import Data.InfoWindow as InfoWindow
import Data.Level.Progress exposing (completedLevel, getLevelNumber, reachedLevel)
import Data.Level.Types exposing (..)
import Dict
import Helpers.Css.Animation exposing (FillMode(..), IterationCount(..), animationWithOptionsStyle)
import Helpers.Css.Style exposing (..)
import Helpers.Css.Timing exposing (TimingFunction(..))
import Helpers.Html exposing (emptyProperty)
import Helpers.Wave exposing (wave)
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick)
import Scenes.Hub.Types as Hub exposing (..)
import Scenes.Tutorial.Types exposing (TutorialConfig)
import Types exposing (Msg(..))
import Views.Icons.Triangle exposing (triangle)
import Views.Seed.All exposing (renderSeed)


renderWorlds : HubModel model -> List (Html Msg)
renderWorlds model =
    allLevels
        |> Dict.toList
        |> List.reverse
        |> List.map (renderWorld model)


renderWorld : HubModel model -> ( WorldNumber, WorldData TutorialConfig ) -> Html Msg
renderWorld model (( _, worldData ) as world) =
    div [ styleAttr (backgroundColor worldData.background), class "pa5 flex" ]
        [ div
            [ styleAttr (widthStyle 300), class "center" ]
            (worldData.levels
                |> Dict.toList
                |> List.reverse
                |> List.map (renderLevel model world)
            )
        ]


renderLevel :
    HubModel model
    -> ( WorldNumber, WorldData TutorialConfig )
    -> ( LevelNumber, LevelData TutorialConfig )
    -> Html Msg
renderLevel model ( world, worldData ) ( level, levelData ) =
    let
        levelNumber =
            getLevelNumber ( world, level ) allLevels

        hasReachedLevel =
            reachedLevel allLevels ( world, level ) model.progress

        isCurrentLevel =
            ( world, level ) == model.progress
    in
    div
        (batchStyles
            [ [ widthStyle 35
              , marginTop 50
              , marginBottom 50
              , color worldData.textColor
              ]
            , offsetStyles level
            ]
            [ showInfo ( world, level ) model
            , class "tc pointer relative"
            , id <| "level-" ++ String.fromInt levelNumber
            ]
        )
        [ currentLevelPointer isCurrentLevel
        , renderIcon ( world, level ) worldData.seedType model
        , renderNumber levelNumber hasReachedLevel worldData
        ]


currentLevelPointer : Bool -> Html msg
currentLevelPointer isCurrentLevel =
    if isCurrentLevel then
        div
            [ class "absolute left-0 right-0"
            , styleAttr (topStyle -30)
            , styleAttr
                (animationWithOptionsStyle
                    { name = "hover"
                    , timing = Ease
                    , fill = Forwards
                    , duration = 1500
                    , iteration = Just Infinite
                    , delay = Nothing
                    }
                )
            ]
            [ triangle ]

    else
        span [] []


offsetStyles : Int -> List Style
offsetStyles levelNumber =
    wave
        { center = [ ( "margin-left", "auto" ), ( "margin-right", "auto" ) ]
        , right = [ ( "margin-left", "auto" ) ]
        , left = []
        }
        (levelNumber - 1)


renderNumber : Int -> Bool -> WorldData TutorialConfig -> Html Msg
renderNumber visibleLevelNumber hasReachedLevel worldData =
    if hasReachedLevel then
        div
            [ class "br-100 center flex justify-center items-center"
            , styleAttr (backgroundColor worldData.textBackgroundColor)
            , styleAttr (marginTop 10)
            , styleAttr (widthStyle 25)
            , styleAttr (heightStyle 25)
            ]
            [ p [ styleAttr (color worldData.textCompleteColor), class "f6" ] [ text <| String.fromInt visibleLevelNumber ] ]

    else
        p [ styleAttr (color worldData.textColor) ] [ text <| String.fromInt visibleLevelNumber ]


showInfo : Progress -> HubModel model -> Attribute Msg
showInfo currentLevel model =
    if reachedLevel allLevels currentLevel model.progress && InfoWindow.isHidden model.hubInfoWindow then
        onClick <| HubMsg <| ShowLevelInfo currentLevel

    else
        emptyProperty


handleStartLevel : Progress -> HubModel model -> Attribute Msg
handleStartLevel currentLevel model =
    if reachedLevel allLevels currentLevel model.progress then
        onClick <| StartLevel currentLevel

    else
        emptyProperty


renderIcon : ( WorldNumber, LevelNumber ) -> SeedType -> HubModel model -> Html msg
renderIcon currentLevel seedType model =
    if completedLevel allLevels currentLevel model.progress then
        renderSeed seedType

    else
        renderSeed GreyedOut
