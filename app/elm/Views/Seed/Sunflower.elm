module Views.Seed.Sunflower exposing (..)

import Scenes.Level.Model exposing (..)
import Html exposing (Html)
import Svg exposing (..)
import Svg.Attributes exposing (..)


sunflower : Model -> Html Msg
sunflower model =
    svg
        [ x "0px"
        , y "0px"
        , width "124.5px"
        , height "193.5px"
        , viewBox "0 0 124.5 193.5"
        ]
        [ Svg.path
            [ fill "#3A2315"
            , d "M62.33,3.285c0,0-58.047,79.778-58.047,128.616c0,32.059,25.988,58.049,58.047,58.049 c0.057,0,0.113-0.004,0.17-0.004V3.519C62.388,3.365,62.33,3.285,62.33,3.285z"
            ]
            []
        , Svg.path
            [ fill "#A77B52"
            , d "M120.376,131.901c0-47.796-54.445-123.649-57.876-128.383v186.428 C94.479,189.854,120.376,163.903,120.376,131.901z"
            ]
            []
        ]
