module Views.Lives exposing (life, renderLivesLeft)

import Data.Transit as Transit exposing (Transit)
import Helpers.Css.Animation exposing (..)
import Helpers.Css.Style as Style exposing (..)
import Helpers.Css.Timing exposing (..)
import Helpers.Css.Transform exposing (scale)
import Html exposing (..)
import Html.Attributes exposing (class)
import Views.Icons.Heart exposing (..)


type alias Heart =
    { active : Bool
    , currentLife : Bool
    , breaking : Bool
    , lifeState : Transit Int
    }


renderLivesLeft : Transit Int -> List (Html msg)
renderLivesLeft lifeState =
    let
        lives =
            Transit.val lifeState
    in
    List.range 1 5
        |> List.map (\n -> Heart (n <= lives) (n == lives) (n == lives + 1) lifeState)
        |> List.map life


life : Heart -> Html msg
life { active, currentLife, breaking, lifeState } =
    let
        animation =
            if currentLife then
                animationWithOptionsStyle
                    { name = "heartbeat"
                    , duration = 1000
                    , iteration = Just Infinite
                    , timing = Ease
                    , delay = Nothing
                    , fill = Forwards
                    }

            else
                emptyStyle

        visibleHeart =
            if active then
                heart

            else if breaking && Transit.isTransitioning lifeState then
                breakingHeart

            else
                brokenHeart

        adjustScale =
            if active then
                emptyStyle

            else
                transform [ scale 1.11 ]
    in
    div
        [ style
            [ width 35
            , heightStyle 35
            , marginLeft 10
            , marginRight 10
            , animation
            , adjustScale
            ]
        , class "dib"
        ]
        [ visibleHeart ]
