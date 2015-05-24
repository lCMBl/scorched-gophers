module CounterPair where

import Counter
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (..)

--Our Model is a record with two fields, one for each of the counters we would like to show on screen. This fully describes all of the application state. We also have an init function to create a new Model whenever we want.

type alias Model =
  { topCounter : Counter.Model
  , bottomCounter : Counter.Model
  }

init : Int -> Int -> Model
init top bottom =
  { topCounter = Counter.init top
  , bottomCounter = Counter.init bottom
  }

--Notice that our union type refers to the Counter.Action type, but we do not know the particulars of those actions. When we create our update function, we are mainly routing these Counter.Actions to the right place:
type Action
  = Reset
  | Top Counter.Action
  | Bottom Counter.Action


-- define actions
update : Action -> Model -> Model
update action model=
  case action of
    Reset -> init 0 0
    -- when Top is called, expect another action to come with it
    -- then, update the model for this call by pipping Counter.update (Action that followed along, topCounter model)
    -- updating a record
    Top act -> {model | topCounter <- Counter.update act model.topCounter}
    Bottom act -> {model | bottomCounter <- Counter.update act model.bottomCounter}




--Notice that we are able to reuse the Counter.view function for both of our counters. For each counter we create a forwarding address. Essentially what we are doing here is saying, “these counters will tag all outgoing messages with Top or Bottom so we can tell the difference.”
view : Signal.Address Action -> Model -> Html
view address model =
  div []
    [ Counter.view (Signal.forwardTo address Top) model.topCounter
    , Counter.view (Signal.forwardTo address Bottom) model.bottomCounter
    , button [onClick address Reset] [text "RESET"]
    ]


-- signals
main : Signal Html
main =
  Signal.map (view actions.address) model

model : Signal Model
model =
  Signal.foldp update (init 0 0) actions.signal

actions : Signal.Mailbox Action
actions =
  Signal.mailbox Reset