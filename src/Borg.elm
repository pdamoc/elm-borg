module Borg exposing (..)

import Native.CssHelper
import Html exposing (Html)


withStyle : String -> Html msg -> Html msg
withStyle =
    Native.CssHelper.withStyle
