module Data.Board.Growing exposing (..)

import Data.Tiles exposing (growSeedPod, setDraggingToGrowing, setGrowingToStatic)
import Helpers.Dict exposing (mapValues)
import Model exposing (..)


handleResetGrowing : Model -> Model
handleResetGrowing model =
    { model | board = model.board |> mapValues setGrowingToStatic }


handleGrowSeedPods : Model -> Model
handleGrowSeedPods model =
    { model | board = model.board |> mapValues growSeedPod }


handleSetGrowingSeedPods : Model -> Model
handleSetGrowingSeedPods model =
    { model | board = model.board |> mapValues setDraggingToGrowing }
