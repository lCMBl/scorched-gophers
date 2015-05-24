module Counter(Model, init, Action, update, view) where

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
-- counter example
-- define model
type alias Model = Int

-- creates a new model when passed an int
init : Int -> Model
init count = count
-- define actions
-- action behaves like an enumerable
type Action = Increment | Decrement -- < this is a union type!

-- define update function
-- takes an action and a model, and returns a (modified) model
update : Action -> Model -> Model
update action model =
  -- perform a different change based upon the action passed
  case action of
    Increment -> model + 1
    Decrement -> model - 1


-- define a view, which records actions and displays information
-- signal.address is a data type? union type?
view : Signal.Address Action -> Model -> Html
view address model =
  div []
    [ button [onClick address Decrement] [text "-"]
    , div [countStyle] [text (toString model)]
    , button [onClick address Increment] [text "+"]
    ]

countStyle : Attribute
countStyle =
  style -- what appears to be basic css
  [ ("font-size", "20px")
  , ("font-family", "monospace")
  , ("display", "inline-block")
  , ("width", "50px")
  , ("text-align", "center")
  ]