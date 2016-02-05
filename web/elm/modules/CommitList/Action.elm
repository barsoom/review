module CommitList.Update (Action (..), inbox) where

import CommitList.Model exposing(..)

inbox : Signal.Mailbox Action
inbox =
  Signal.mailbox NoOp

type Action
  = NoOp
  | StartReview Int
  | AbandonReview Int
  | UpdatedCommit Commit
