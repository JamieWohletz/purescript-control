module Control.MonadZero
  ( class MonadZero
  , guard
  , module Control.Alt
  , module Control.Alternative
  , module Control.Applicative
  , module Control.Apply
  , module Control.Bind
  , module Control.Monad
  , module Control.Plus
  , module Data.Functor
  ) where

import Control.Alt (class Alt, alt, (<|>))
import Control.Alternative (class Alternative)
import Control.Applicative (class Applicative, pure, liftA1, unless, when)
import Control.Apply (class Apply, apply, (*>), (<*), (<*>))
import Control.Bind (class Bind, bind, ifM, join, (<=<), (=<<), (>=>), (>>=))
import Control.Monad (class Monad, ap, liftM1)
import Control.Plus (class Plus, empty)

import Data.Functor (class Functor, map, void, ($>), (<#>), (<$), (<$>))
import Data.Unit (Unit, unit)

-- | The `MonadZero` type class has no members of its own; it just specifies
-- | that the type has both `Monad` and `Alternative` instances.
-- |
-- | Types which have `MonadZero` instances should also satisfy the following
-- | laws:
-- |
-- | - Annihilation: `empty >>= f = empty`
class (Monad m, Alternative m) <= MonadZero m

instance monadZeroArray :: MonadZero Array

-- | Fail using `Plus` if a condition does not hold, or
-- | succeed using `Monad` if it does.
-- |
-- | For example:
-- |
-- | ```purescript
-- | import Data.Array
-- |
-- | factors :: Int -> Array Int
-- | factors n = do
-- |   a <- 1..n
-- |   b <- a..n
-- |   guard $ a * b == n
-- |   pure [a, b]
-- | ```
-- | In this example, a step of the array comprehension will fail with
-- | `empty` (`[]` in the case of Array) if `a * b != n`. Otherwise, 
-- | `guard` will return an array with one value (Unit) and the step will proceed,
-- | returning `[[a, b]]`.
guard :: forall m. MonadZero m => Boolean -> m Unit
guard true = pure unit
guard false = empty
