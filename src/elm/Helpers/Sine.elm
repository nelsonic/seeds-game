module Helpers.Sine exposing
    ( Wave
    , wave
    )


type alias Wave a =
    { left : a
    , center : a
    , right : a
    }



{- increasing n+1 integers produces a sine wave like pattern from elements in the given config

   List.map (wave { left : "X", center : "Y", right: "Z" }) [0,1,2,3,4,5,6,7]
   -- ["Y", "Z", "Y", "X", "Y", "Z", "Y", "X"]
-}


wave : Wave a -> Int -> a
wave { left, center, right } n =
    let
        offsetSin =
            toFloat n
                |> (*) 90
                |> degrees
                |> sin
                |> round
    in
    if offsetSin == 0 then
        center

    else if offsetSin == 1 then
        right

    else
        left
