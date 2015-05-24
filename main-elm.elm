import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)
-- counter example
-- define model
type alias Model = Int

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

-- signals
main : Signal Html
main =
  Signal.map (view actions.address) model

model : Signal Model
model =
  Signal.foldp update 0 actions.signal

-- defines a signal of type action flowing through the action mailbox
--So when we specify certain addresses in our view, we are describing how user Actions should be directed to mailboxes and directed back into our program. Notice we are not performing those actions, we are simply reporting them back to our main Elm program. This separation is a key detail!

actions : Signal.Mailbox Action
actions =
  Signal.mailbox Increment