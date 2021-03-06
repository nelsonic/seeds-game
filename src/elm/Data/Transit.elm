module Data.Transit exposing (Transit(..), isTransitioning, map, toStatic, toTransitioning, val)

-- Simple wrapper type to represent a value that will be transitioned (usually via CSS)


type Transit a
    = Static a
    | Transitioning a


map : (a -> b) -> Transit a -> Transit b
map f transit =
    case transit of
        Static a ->
            Static <| f a

        Transitioning a ->
            Transitioning <| f a


val : Transit a -> a
val transit =
    case transit of
        Static a ->
            a

        Transitioning a ->
            a


toStatic : Transit a -> Transit a
toStatic transit =
    case transit of
        Static a ->
            Static a

        Transitioning a ->
            Static a


toTransitioning : Transit a -> Transit a
toTransitioning transit =
    case transit of
        Static a ->
            Transitioning a

        Transitioning a ->
            Transitioning a


isTransitioning : Transit a -> Bool
isTransitioning transit =
    case transit of
        Transitioning _ ->
            True

        _ ->
            False
