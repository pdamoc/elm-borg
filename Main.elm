module Main exposing (..)

import Html exposing (..)
import Parsers exposing (..)
import String exposing (join)


css : String
css =
    """body {
    background-color: lightblue;
}

h1 {
    color: white;
    text-align: center;
}

p {
    font-family: verdana;
    font-size: 20px;
}
@media only screen and (max-width: 500px) {
    body {
        background-color: lightblue;
    }
}
"""


html : String
html =
    """<!DOCTYPE html>
<html>
<head>
<title>Page Title</title>
</head>
<body>

<h1 id="head">This is a Heading</h1>
<p>This is a paragraph.</p>

</body>
</html>"""


html2 : String
html2 =
    """<h1 id="head">This is a Heading</h1>
<p>This is a paragraph.</p>"""


svg : String
svg =
    """<svg width="100" height="100">
  <circle cx="50" cy="50" r="40" stroke="green" stroke-width="4" fill="yellow" />
</svg>"""


renderRule : Rule -> List (Html a)
renderRule rule =
    List.concat
        [ [ text ((join " " rule.selectors) ++ " {")
          , br [] []
          ]
        , (List.concat <| List.map (\( p, v ) -> [ text (join ":" [ p, v ]), br [] [] ]) rule.declarations)
        , [ text "}"
          , br [] []
          ]
        ]


renderCssRule : RuleOrMedia -> List (Html a)
renderCssRule info =
    case info of
        R rule ->
            renderRule rule

        M media rules ->
            List.concat
                [ [ text ("@media " ++ media ++ " {")
                  , br [] []
                  ]
                , (List.concat <| List.map renderRule rules)
                , [ text "}"
                  , br [] []
                  ]
                ]


main : Html a
main =
    div []
        ([ h2 [] [ text "HTML test" ]
         , text <| toString (parseHtml html2)
         , hr [] []
         , h2 [] [ text "SVG test" ]
         , text <| toString (parseSvg svg)
         , hr [] []
         , h2 [] [ text "CSS test" ]
         ]
            ++ List.concat (List.map renderCssRule (parseCss css))
        )
