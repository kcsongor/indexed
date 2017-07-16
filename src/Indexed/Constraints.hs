{-# LANGUAGE ConstraintKinds #-}
{-# LANGUAGE GADTs #-}
{-# LANGUAGE TypeOperators #-}
{-# LANGUAGE RankNTypes #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE FunctionalDependencies #-}
{-# LANGUAGE UndecidableInstances #-}
{-# LANGUAGE FlexibleInstances #-}
{-# LANGUAGE ExplicitNamespaces #-}
-----------------------------------------------------------------------------
-- |
-- Module      :  Indexed.Constraints
-- Copyright   :  (C) 2012 Edward Kmett
-- License     :  BSD-style (see the file LICENSE)
-- Maintainer  :  Edward Kmett <ekmett@gmail.com>
-- Stability   :  experimental
-- Portability :  non-portable
--
-- A poly-kinded 'Control.Category.Category' for 'Constraint' entailment.
-----------------------------------------------------------------------------
module Indexed.Constraints
  ( Dict(Dict)
  , type (|-)(Sub)
  , Class(byClass)
  , type (|=)(byInstance)
  , (\\)
  ) where

import Indexed.Monoid

-------------------------------------------------------------------------------
-- Constraint Kinds
-------------------------------------------------------------------------------

-- | A dictionary for a constraint
data Dict p where Dict :: p => Dict p

infixr 9 |-, |=
-- | Entailment of constraints
newtype p |- q = Sub (p => Dict q)

infixl 1 \\
-- | Substitution of constraints
(\\) :: p => (q => r) -> (p |- q) -> r
r \\ Sub Dict = r

-- | Reification of a @class@ declaration
class Class b h | h -> b where
  byClass :: h |- b

-- | Reification of an @instance@ declaration
class b |= h | b -> h where
  byInstance :: b |- h

{-
instance Class () (Class b a) where byClass = Sub Dict
instance Class () (b |= a) where byClass = Sub Dict
instance Class b a => () |= Class b a where byInstance = Sub Dict
instance (b |= a) => () |= b |= a where byInstance = Sub Dict
instance Class () () where byClass = Sub Dict
instance () |= () where byClass = Sub Dict
-}

-- instance Class () () where byClass = Sub Dict
-- instance () |= () where byInstance = Sub Dict


instance Cat (|-) where
  idd = Sub Dict
  f % g = Sub $ Dict \\ f \\ g
