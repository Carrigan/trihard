module Login where

import Html exposing (div, button, text, input, label)
import Html.Attributes exposing (attribute, id, type')

main =
  div []
  [ div [ attribute "class" "modal-body" ]
      [ label [] [text "Email or Username"]
      , input
          [ attribute "class" "form-control"
          , id "username"
          ]
          []
      , label [] [text "Password"]
      , input
          [ attribute "class" "form-control"
          , type' "password"
          , id "password"
          ]
          []
      ]
  , div [ attribute "class" "modal-footer" ]
      [ button [attribute "class" "btn btn-primary" ] [ Html.text "Login" ] ]
  ]
