module Main exposing (Model, Msg(..), init, main, subscriptions, update, view)

import Browser
import Element exposing (..)
import Element.Background as Background
import Element.Border as Border
import Element.Font as Font
import Element.Input as Input
import Element.Region as Region
import HistogramChart as HistogramChart
import Html exposing (Html, div)
import Random
import Stat as Stat
import StatRandom as StatRandom
import SyntaxHighlight exposing (elm, gitHub, toInlineHtml, useTheme)



-- MAIN


main =
    Browser.element
        { init = init
        , update = update
        , subscriptions = subscriptions
        , view = view
        }



-- MODEL


type alias Model =
    { normalList : List Float
    , uniformList : List Float
    , exponentialList : List Float
    , betaList : List Float
    , bernoulliList : List Bool
    , binomialList : List Int
    , poissonList : List Int
    , geometricList : List Int
    }


init : () -> ( Model, Cmd Msg )
init _ =
    ( { normalList = []
      , uniformList = []
      , exponentialList = []
      , betaList = []
      , bernoulliList = []
      , binomialList = []
      , poissonList = []
      , geometricList = []
      }
    , Cmd.none
    )



-- UPDATE


type Msg
    = GenerateNormalList
    | GenerateUniformList
    | GenerateExponentialList
    | GenerateBetaList
    | GenerateBenroulliBoolList
    | GenerateBinomialList
    | GeneratePoissonList
    | GenerateGeometricList
    | NormalList (List Float)
    | UniformList (List Float)
    | ExponentialList (List Float)
    | BetaList (List Float)
    | BernoulliList (List Bool)
    | BinomialList (List Int)
    | PoissonList (List Int)
    | GeometricList (List Int)


update : Msg -> Model -> ( Model, Cmd Msg )
update msg model =
    case msg of
        GenerateNormalList ->
            ( model
            , Random.generate NormalList (StatRandom.generateList 1000 (StatRandom.normal 2 0.5))
            )

        NormalList list ->
            ( { model | normalList = list }
            , Cmd.none
            )

        GenerateUniformList ->
            ( model
            , Random.generate UniformList (StatRandom.generateList 500 (Random.float 0 4))
            )

        UniformList list ->
            ( { model | uniformList = list }
            , Cmd.none
            )

        GenerateExponentialList ->
            ( model
            , Random.generate ExponentialList (StatRandom.generateList 1000 (StatRandom.exponential 1.5))
            )

        ExponentialList list ->
            ( { model | exponentialList = list }
            , Cmd.none
            )

        GenerateBetaList ->
            ( model
            , Random.generate BetaList (StatRandom.generateList 1000 (StatRandom.beta 0.5 0.5))
            )

        BetaList list ->
            ( { model | betaList = list }
            , Cmd.none
            )

        GenerateBenroulliBoolList ->
            ( model
            , Random.generate BernoulliList (StatRandom.generateList 1000 (StatRandom.bernoulliBool 0.4))
            )

        BernoulliList list ->
            ( { model | bernoulliList = list }
            , Cmd.none
            )

        GenerateBinomialList ->
            ( model
            , Random.generate BinomialList (StatRandom.generateList 500 (StatRandom.binomial 0.8 4))
            )

        BinomialList list ->
            ( { model | binomialList = list }
            , Cmd.none
            )

        GeneratePoissonList ->
            ( model
            , Random.generate PoissonList (StatRandom.generateList 500 (StatRandom.poisson 0.8 4))
            )

        PoissonList list ->
            ( { model | poissonList = list }
            , Cmd.none
            )

        GenerateGeometricList ->
            ( model
            , Random.generate GeometricList (StatRandom.generateList 1000 (StatRandom.geometric 0.166 6))
            )

        GeometricList list ->
            ( { model | geometricList = list }
            , Cmd.none
            )



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions _ =
    Sub.none



-- VIEW


view model =
    Element.layout
        [ Font.size 16
        , Font.family
            [ Font.typeface "Helvetica"
            , Font.sansSerif
            ]
        , height fill
        ]
        (mainRow model)


mainRow : Model -> Element Msg
mainRow model =
    Element.row [ width fill, height fill ] [ leftColumn model, mainColumn model ]


borders =
    { bottom = 0
    , left = 0
    , right = 0
    , top = 0
    }


paddings =
    { top = 0
    , right = 0
    , bottom = 0
    , left = 0
    }


leftColumn : Model -> Element Msg
leftColumn model =
    Element.column [ height fill, alignTop, width <| px 260, scrollbars, spacing 20, padding 0, Border.widthEach { borders | right = 2 }, Region.navigation ]
        [ paragraph
            [ alignLeft
            , Font.size 18
            , Border.widthEach { borders | bottom = 2 }
            , padding 20
            ]
            [ el [] (text "Welcome to the elm-stat examples!") ]
        , section "Measures of Central Tendency" [ "mean", "average", "weightedMean", "harmonicMean", "geometricMean", "mode", "median", "rootMeanSquare", "sampleSkewness" ]
        , section "Measures of Dispersion" [ "variance", "standardDeviation", "meanAbsoluteDeviation", "medianAbsoluteDeviation", "zScore", "zScores" ]
        , section "Similarity" [ "covariance", "correlation" ]
        , section "Linear regression" [ "linearRegression", "linearRegressionLine" ]
        , section "Distributions" [ "Bernoulli", "Binomial", "Poisson", "Geometric", "Uniform", "Normal", "Student T", "Exponential" ]
        ]


section : String -> List String -> Element Msg
section topicName subTopicNames =
    Element.column [] [ topic topicName, subTopics subTopicNames ]


topic : String -> Element Msg
topic name =
    Element.row [ Font.size 16, paddingXY 20 0 ] [ text name ]


subTopics : List String -> Element msg
subTopics names =
    let
        rows =
            List.map createSubTopic names
    in
    column [ Font.size 14, paddingXY 30 5 ] rows


createSubTopic : String -> Element msg
createSubTopic name =
    row
        [ padding 4
        , Border.widthEach { borders | bottom = 1 }
        , Border.color <| rgba 0 0 0 0
        , mouseOver [ Font.size 15, Border.color <| rgb 0 0 0 ]
        , pointer
        ]
        [ text name ]


normal : Model -> Element Msg
normal model =
    el [ width shrink, height shrink, Border.width 1, Border.color black, Border.rounded 5, Border.shadow { offset = ( 0, 0 ), size = 10.0, blur = 50.0, color = black }, centerX, padding 30 ]
        (column []
            [ descriptionTitle "Normal Distribution"
            , el [] (syntax "StatRandom.generateList 500 (StatRandom.normal 2 0.5)" |> Element.html)
            , el [ width <| px 900, height fill ] (HistogramChart.view model.normalList |> Element.html)
            , button "Generate" GenerateNormalList
            ]
        )


uniform : Model -> Element Msg
uniform model =
    el [ width shrink, height shrink, Border.width 1, Border.color black, Border.rounded 5, Border.shadow { offset = ( 0, 0 ), size = 10.0, blur = 50.0, color = black }, centerX, padding 30 ]
        (column []
            [ descriptionTitle "Uniform Distribution"
            , el [ Border.rounded 5 ] (syntax "StatRandom.generateList 500 (StatRandom.float 0 4)" |> Element.html)
            , el [ width <| px 900, height fill ] (HistogramChart.view model.uniformList |> Element.html)
            , button "Generate" GenerateUniformList
            ]
        )

exponential : Model -> Element Msg
exponential model =
    el [ width shrink, height shrink, Border.width 1, Border.color black, Border.rounded 5, Border.shadow { offset = ( 0, 0 ), size = 10.0, blur = 50.0, color = black }, centerX, padding 30 ]
        (column []
            [ descriptionTitle "Exponential Distribution"
            , el [ Border.rounded 5 ] (syntax "StatRandom.generateList 1000 (StatRandom.exponential 1.0)" |> Element.html)
            , el [ width <| px 900, height fill ] (HistogramChart.view model.exponentialList |> Element.html)
            , button "Generate" GenerateExponentialList
            ]
        )

beta : Model -> Element Msg
beta model =
    el [ width shrink, height shrink, Border.width 1, Border.color black, Border.rounded 5, Border.shadow { offset = ( 0, 0 ), size = 10.0, blur = 50.0, color = black }, centerX, padding 30 ]
        (column []
            [ descriptionTitle "Beta Distribution"
            , el [ Border.rounded 5 ] (syntax "StatRandom.generateList 1000 (StatRandom.beta 1.0)" |> Element.html)
            , el [ width <| px 900, height fill ] (HistogramChart.view model.betaList |> Element.html)
            , button "Generate" GenerateBetaList
            ]
        )


bernoulli : Model -> Element Msg
bernoulli model =
    let
        t =
            List.length <| List.filter (\x -> x) model.bernoulliList
    in
    el [ width shrink, height shrink, Border.width 1, Border.color black, Border.rounded 5, Border.shadow { offset = ( 0, 0 ), size = 10.0, blur = 50.0, color = black }, centerX, padding 30 ]
        (column []
            [ descriptionTitle "Bernoulli Distribution"
            , el [ Border.rounded 5, paddingXY 0 10 ] (syntax "StatRandom.generateList 1000 (Random.bernoulliBool 0.4)" |> Element.html)
            , row [ Border.rounded 5, paddingXY 0 10 ]
                [ text "True: "
                , text (String.fromInt t)
                ]
            , button "Generate" GenerateBenroulliBoolList
            ]
        )


binomial : Model -> Element Msg
binomial model =
    el [ width shrink, height shrink, Border.width 1, Border.color black, Border.rounded 5, Border.shadow { offset = ( 0, 0 ), size = 10.0, blur = 50.0, color = black }, centerX, padding 30 ]
        (column []
            [ descriptionTitle "Binomial Distribution"
            , el [ Border.rounded 5, paddingXY 0 10 ] (syntax "StatRandom.generateList 500 (Random.binomial 0.8 4)" |> Element.html)
            , el [ width <| px 900, height fill ] (HistogramChart.view (List.map toFloat model.binomialList) |> Element.html)
            , button "Generate" GenerateBinomialList
            ]
        )


poisson : Model -> Element Msg
poisson model =
    el [ width shrink, height shrink, Border.width 1, Border.color black, Border.rounded 5, Border.shadow { offset = ( 0, 0 ), size = 10.0, blur = 50.0, color = black }, centerX, padding 30 ]
        (column []
            [ descriptionTitle "Poisson Distribution"
            , el [ Border.rounded 5, paddingXY 0 10 ] (syntax "StatRandom.generateList 500 (Random.poisson 0.8 4)" |> Element.html)
            , el [ width <| px 900, height fill ] (HistogramChart.view (List.map toFloat model.poissonList) |> Element.html)
            , button "Generate" GeneratePoissonList
            ]
        )

geometric : Model -> Element Msg
geometric model =
    el [ width shrink, height shrink, Border.width 1, Border.color black, Border.rounded 5, Border.shadow { offset = ( 0, 0 ), size = 10.0, blur = 50.0, color = black }, centerX, padding 30 ]
        (column []
            [ descriptionTitle "Geometric Distribution"
            , el [ Border.rounded 5, paddingXY 0 10 ] (syntax "StatRandom.generateList 500 (Random.geometric 0.166 4)" |> Element.html)
            , el [ width <| px 900, height fill ] (HistogramChart.view (List.map toFloat model.geometricList) |> Element.html)
            , button "Generate" GenerateGeometricList
            ]
        )


modeExample : Model -> Element Msg
modeExample model =
    let
        t =
            [ 2, 4, 4, 4, 5, 5, 7, 9 ]

        w =
            [ ( 2, 4 ), ( 2, 10 ) ]
    in
    el [ width shrink, height shrink, Border.width 1, Border.color black, Border.rounded 5, Border.shadow { offset = ( 0, 0 ), size = 10.0, blur = 50.0, color = black }, centerX, padding 30 ]
        (column []
            [ descriptionTitle "Measures of Central Tendency"
            , el [ Border.rounded 5, paddingXY 0 10 ] (text (t |> List.map String.fromInt |> String.join ", "))
            , centralTendencyRow "mode" Stat.mode t
            , centralTendencyRow "average" Stat.mean t
            , centralTendencyRow "geometric mean" Stat.geometricMean t
            , centralTendencyRow "harmonic mean" Stat.harmonicMean t
            , centralTendencyRow "weighted mean" Stat.weightedMean w
            , centralTendencyRow "root mean square" Stat.rootMeanSquare t
            , centralTendencyRow "median" Stat.median t
            , centralTendencyRow "skewness" Stat.skewness t
            ]
        )


dispersion : Model -> Element Msg
dispersion model =
    let
        t =
            [ 2, 4, 4, 4, 5, 5, 7, 9, 122 ]

        w =
            [ ( 2, 4 ), ( 2, 10 ) ]
    in
    el [ width shrink, height shrink, Border.width 1, Border.color black, Border.rounded 5, Border.shadow { offset = ( 0, 0 ), size = 10.0, blur = 50.0, color = black }, centerX, padding 30 ]
        (column []
            [ descriptionTitle "Measures of Dispersion"
            , el [ Border.rounded 5, paddingXY 0 10 ] (text (t |> List.map String.fromInt |> String.join ", "))
            , centralTendencyRow "variance" Stat.variance t
            , centralTendencyRow "standard deviation" Stat.standardDeviation t
            , centralTendencyRow "mean absolute deviation" Stat.meanAbsoluteDeviation t
            , centralTendencyRow "median absolute deviation" Stat.medianAbsoluteDeviation t
            , text ("z score: " ++ Debug.toString (Stat.zScore 2 5 2))
            , centralTendencyRow "z scores" Stat.zScores t
            ]
        )


similarity : Model -> Element Msg
similarity model =
    let
        t =
            [ 2, 4, 4, 4, 5, 5, 7, 9 ]

        w =
            -- [ ( 1, 10 ), ( 2, 20 ), (3,27), (4,35), (5, 55) ]
            [ ( 1, 1 ), ( 2, 3 ), ( 3, 3 ), ( 4, 5 ) ]
    in
    el [ width shrink, height shrink, Border.width 1, Border.color black, Border.rounded 5, Border.shadow { offset = ( 0, 0 ), size = 10.0, blur = 50.0, color = black }, centerX, padding 30 ]
        (column []
            [ descriptionTitle "Similarity"
            , el [ Border.rounded 5, paddingXY 0 10 ] (text <| Debug.toString w)
            , centralTendencyRow "covariance" Stat.covariance w
            , centralTendencyRow "correlation" Stat.correlation w
            ]
        )


linearReg : Model -> Element Msg
linearReg model =
    let
        w =
            [ ( 1, 4 ), ( 2, 4.5 ), ( 3, 5.5 ), ( 4, 5.3 ), ( 5, 6 ) ]
    in
    el [ width shrink, height shrink, Border.width 1, Border.color black, Border.rounded 5, Border.shadow { offset = ( 0, 0 ), size = 10.0, blur = 50.0, color = black }, centerX, padding 30 ]
        (column []
            [ descriptionTitle "Linear Regression"
            , el [ Border.rounded 5, paddingXY 0 10 ] (text <| Debug.toString w)
            , centralTendencyRow "linear regression" Stat.linearRegression w
            ]
        )


centralTendencyRow funcName func list =
    row [ paddingXY 0 10, width <| px 800 ]
        [ text (funcName ++ ": " ++ Debug.toString (func list))
        ]


syntax : String -> Html msg
syntax code =
    div []
        [ useTheme gitHub
        , elm code
            |> Result.map toInlineHtml
            |> Result.withDefault (div [] [])
        ]


descriptionTitle : String -> Element Msg
descriptionTitle title =
    el [ Font.size 18, paddingXY 0 30 ] (text title)


mainColumn : Model -> Element Msg
mainColumn model =
    Element.column [ width fill, height fill, centerX, centerY, spacing 36, padding 50, scrollbars ]
        [ uniform model
        , normal model
        , exponential model
        , beta model
        , bernoulli model
        , binomial model
        , poisson model
        , geometric model
        , modeExample model
        , dispersion model
        , similarity model
        , linearReg model
        ]


blue : Color
blue =
    Element.rgb 0 0 0.8


red : Color
red =
    Element.rgb 0.8 0 0


black : Color
black =
    Element.rgba 0 0 0 0.1


white : Color
white =
    Element.rgb 1 1 1


orange : Color
orange =
    Element.rgba255 247 111 27 0.84


grey : Color
grey =
    Element.rgba255 94 83 83 0.8


button : String -> msg -> Element msg
button buttonText message =
    Input.button
        [ padding 5
        , Border.width 1
        , Border.rounded 5
        , Border.color black
        , Background.color grey
        , Font.color white
        , mouseOver
            [ Background.color <| rgb255 0xFF 0xFF 0xFF, Font.color <| rgb255 0 0 0 ]
        ]
        { onPress = Just message
        , label = text buttonText
        }
