{-# LANGUAGE PolyKinds #-}
{-# LANGUAGE DataKinds #-}
{-# LANGUAGE GADTs #-}
-----------------------------------------------------------------------------
-- |
-- Module      :  Indexed.Group
-- Copyright   :  (C) 2012 Edward Kmett
-- License     :  BSD-style (see the file LICENSE)
-- Maintainer  :  Edward Kmett <ekmett@gmail.com>
-- Stability   :  experimental
-- Portability :  non-portable
--
-- Indexed groups and groupoids
-----------------------------------------------------------------------------
module Indexed.Group
  ( Group(..)
  , Groupoid(..)
  , IGroup(..)
  ) where

import Indexed.Types
import Indexed.Monoid

class Monoid m => Group m where
  -- | @'inv' '.' 'inv' = 'id'@
  inv :: m -> m

class Cat k => Groupoid k where
  -- | @'invert' '.' 'invert' = 'idd'@
  invert :: k i j -> k j i

class IMonoid m => IGroup m where
  -- | @'iinv' '.' 'iinv' = 'imempty'@
  iinv :: m '(i,j) -> m '(j,i)

-- | A 'Groupoid' is an indexed group
instance Groupoid k  => IGroup (Morphism k) where
  iinv (Morphism f) = Morphism (invert f)

instance Group m => Groupoid (At m) where
  invert (At m) = At (inv m)

instance Groupoid (:~:) where
  invert Refl = Refl
