module Views.Intro.RollingHills exposing (..)

import Data.Visibility exposing (..)
import Helpers.Css.Style exposing (widthStyle)
import Html exposing (Html, div)
import Html.Attributes
import Svg exposing (Attribute, Svg)
import Svg.Attributes exposing (..)
import Views.Flowers.Sunflower exposing (sunflower)


rollingHills : Visibility -> Html msg
rollingHills vis =
    div []
        [ div [ class "relative z-5 center", Html.Attributes.style [ widthStyle 200 ] ] [ sunflower 0 ]
        , div [ class "fixed w-100 bottom-0 left-0 z-1" ] [ hills vis ]
        ]


hills : Visibility -> Svg msg
hills vis =
    Svg.svg [ viewBox "0 0 1000 800", width "100%", class "absolute bottom-0", hillsStyle vis ]
        [ Svg.g [ fill "none", fillRule "evenodd", style "transform: translate(-500px)" ]
            [ Svg.g [ style "transform: translate(0px, 300px)", class "hill" ]
                [ Svg.circle [ cx "1325", cy "650", fill "#325448", r "650" ] []
                , Svg.circle [ cx "650", cy "650", fill "#1F7D5C", r "650" ] []
                ]
            , Svg.g [ style "transform: translate(0px, 400px)", class "hill" ]
                [ Svg.circle [ cx "650", cy "650", fill "#5BCA78", r "650" ] []
                , Svg.circle [ cx "1325", cy "650", fill "#40914E", r "650" ] []
                ]
            , Svg.g [ style "transform: translate(0px, 500px)", class "hill" ]
                [ Svg.circle [ cx "1325", cy "650", fill "#288868", r "650" ] []
                , Svg.circle [ cx "650", cy "650", fill "#3A5E52", r "650" ] []
                , renderFlowers 600 vis
                ]
            , Svg.g [ style "transform: translate(0px, 600px)", class "hill" ]
                [ Svg.circle [ cx "650", cy "650", fill "#56B466", r "650" ] []
                , Svg.circle [ cx "1325", cy "650", fill "#62DE83", r "650" ] []
                , renderFlowers 300 vis
                ]
            , Svg.g [ style "transform: translate(0px, 700px)", class "hill" ]
                [ Svg.circle [ cx "1325", cy "650", fill "#268135", r "650" ] []
                , Svg.circle [ cx "650", cy "650", fill "#15674D", r "650" ] []
                , renderFlowers 0 vis
                ]
            ]
        ]


hillsStyle : Visibility -> Attribute msg
hillsStyle vis =
    case vis of
        Hidden ->
            style "opacity: 0"

        Leaving ->
            style "opacity: 0"

        Entering ->
            style "opacity: 1"

        Visible ->
            style "opacity: 1"


renderFlowers : Float -> Visibility -> Svg msg
renderFlowers delay vis =
    case vis of
        Visible ->
            flowers delay

        _ ->
            Svg.g [] []


flowers : Float -> Svg msg
flowers delay =
    Svg.g [] [ flowersLeft delay, flowersRight delay ]


flowersRight : Float -> Svg msg
flowersRight delay =
    Svg.g []
        [ Svg.g [ style "transform-origin: center; transform: translate(600px, -360px) scale(0.08)" ] [ sunflower <| delay + 300 ]
        , Svg.g [ style "transform-origin: center; transform: translate(700px, -390px) scale(0.06)" ] [ sunflower <| delay + 450 ]
        , Svg.g [ style "transform-origin: center; transform: translate(800px, -400px) scale(0.05)" ] [ sunflower <| delay + 650 ]
        ]


flowersLeft : Float -> Svg msg
flowersLeft delay =
    Svg.g []
        [ Svg.g [ style "transform-origin: center; transform: translate(400px, -350px) scale(0.08)" ] [ sunflower <| delay + 0 ]
        , Svg.g [ style "transform-origin: center; transform: translate(300px, -380px) scale(0.06)" ] [ sunflower <| delay + 250 ]
        , Svg.g [ style "transform-origin: center; transform: translate(200px, -400px) scale(0.05)" ] [ sunflower <| delay + 600 ]
        ]
