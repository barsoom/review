module CommitList.Action (Action (..), inbox) where

import CommitList.Model exposing(..)

inbox : Signal.Mailbox Action
inbox =
  Signal.mailbox NoOp

type Action
  = NoOp
  | StartReview Int
  | AbandonReview Int
  | ShowCommit Int
  | UpdatedCommit Commit
