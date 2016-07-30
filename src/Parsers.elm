module Parsers exposing (..)

import Native.Parsers
import Json.Decode as JD exposing (Decoder, Value, succeed, list, string, (:=))
import Json.Decode.Extra exposing (lazy, (|:))


type NodeInfo
    = NodeInfo
        { name : String
        , attributes : List AttributeInfo
        , children : List NodeInfo
        }


emptyNode : NodeInfo
emptyNode =
    NodeInfo { name = "error", attributes = [], children = [] }


type alias AttributeInfo =
    { name : String
    , value : String
    }


attributeDecoder : Decoder AttributeInfo
attributeDecoder =
    succeed AttributeInfo
        |: ("name" := string)
        |: ("value" := string)


nodeDecoder : Decoder NodeInfo
nodeDecoder =
    succeed (\n a c -> NodeInfo { name = n, attributes = a, children = c })
        |: ("name" := string)
        |: ("attributes" := list attributeDecoder)
        |: ("children" := list (lazy (\_ -> nodeDecoder)))


parseHtml : String -> NodeInfo
parseHtml str =
    Native.Parsers.parseHtml str
        |> JD.decodeValue nodeDecoder
        |> Result.withDefault emptyNode


parseSvg : String -> NodeInfo
parseSvg str =
    Native.Parsers.parseSvg str
        |> JD.decodeValue nodeDecoder
        |> Result.withDefault emptyNode



-- CSS


type alias Declaration =
    ( String, String )


type alias Rule =
    { selectors : List String
    , declarations : List Declaration
    }


type RuleOrMedia
    = R Rule
    | M String (List Rule)


type alias CssInfo =
    List RuleOrMedia


declarationDecoder : Decoder ( String, String )
declarationDecoder =
    JD.object2 (,)
        ("property" := string)
        ("value" := string)


ruleDecoder : Decoder Rule
ruleDecoder =
    JD.object2 Rule
        ("selectors" := list string)
        ("declarations" := list declarationDecoder)


mediaDecoder : Decoder RuleOrMedia
mediaDecoder =
    JD.object2 (\m rls -> M m rls)
        ("media" := string)
        ("rules" := list ruleDecoder)


ruleOrMediaDecoder : Decoder RuleOrMedia
ruleOrMediaDecoder =
    ("type" := string)
        `JD.andThen`
            (\t ->
                if t == "rule" then
                    JD.map (\r -> R r) ruleDecoder
                else
                    mediaDecoder
            )


cssDecoder : Decoder (List RuleOrMedia)
cssDecoder =
    JD.at [ "stylesheet", "rules" ] (list ruleOrMediaDecoder)


parseCss : String -> List RuleOrMedia
parseCss str =
    Native.Parsers.parseCss str
        |> JD.decodeValue cssDecoder
        |> Result.withDefault []
