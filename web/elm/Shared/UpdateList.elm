module Shared.UpdateList exposing (addOrUpdateById)

import Shared.Types exposing (..)


addOrUpdateById : Identifyable a -> List (Identifyable a) -> List (Identifyable a)
addOrUpdateById record list =
    if isNewRecord record list then
        List.concat [ [ record ], list ]
    else
        List.map (updateById record) list


updateById : Identifyable a -> Identifyable a -> Identifyable a
updateById record r =
    if r.id == record.id then
        record
    else
        r


isNewRecord : Identifyable a -> List (Identifyable a) -> Bool
isNewRecord record list =
    not
        (list
            |> List.map (\r -> r.id)
            |> List.member record.id
        )
