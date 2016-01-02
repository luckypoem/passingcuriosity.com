{-# LANGUAGE DeriveFunctor         #-}
{-# LANGUAGE FlexibleContexts      #-}
{-# LANGUAGE FlexibleInstances     #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE RankNTypes            #-}
{-# LANGUAGE TypeOperators         #-}

-- |
--
-- This module demonstrates each component in building a program using:
--
-- - Algebras
-- - Coproducts of functors
-- - Free monads
-- - Natural transformations
--
-- We represent the different concerns in our program -- logging, database
-- access, file I/O, etc. -- as algebras which we combine using coproducts.
-- The free monads generated by these functors allow us to easily write code
-- using this API which can be interpreted with natural transformations for
-- execution, unit testing, documentation, etc.
--
-- Rather than using libraries we'll build all of the following:
--
-- - Coproducts of functors
-- - Injectivity into coproducts
-- - Natural transformations
-- - Free monads
-- - Interpretation using natural transformations
--
-- Ordinarily we'd take these from libraries, it's pretty much all there waiting
-- to be used in the @comonad@ and @free@ packages.
--
-- We'll demonstrate them all by building a suite of algebras, a natural
-- transformation for each of them, and several programs written with the same
-- API but exercising different combinations of algebras.

module FreeMonadOfAlgebrasExample where

import           Control.Monad
import           Prelude       hiding (sum)

-- The following imports are only used in the logic of the specific examples we
-- implement.

import           Data.Char     (toLower, toUpper)
import           Data.List     (isInfixOf)
import           Data.Monoid

-- * Coproduct of functors

-- $ 'Coproduct' is like the 'Either' type most Haskell programmers will
-- familiar with but instead of either an @A@ or a @B@ value, 'Coproduct'
-- represents an @A@ wrapping in either an @F@ functor or a $G$ functor.
--
-- You can find coproducts almost identical to this in the @comonad@ package.

newtype Coproduct f g a = Coproduct { getCoproduct :: Either (f a) (g a) }

instance (Functor f, Functor g) => Functor (Coproduct f g) where
    fmap f = Coproduct . coproduct (Left . fmap f) (Right . fmap f)

-- | Inject a wrapped value into a coproduct on the left.
left :: f a -> Coproduct f g a
left = Coproduct . Left

-- | Inject a wrapped value into a coproduct on the right.
right :: g a -> Coproduct f g a
right = Coproduct . Right

-- | Eliminate a coproduct.
--
-- Uses the supplied functions to handle the left or right value, whichever
-- happens to be passed in.
coproduct :: (f a -> b) -> (g a -> b) -> Coproduct f g a -> b
coproduct faf gaf = either faf gaf . getCoproduct

-- * Injectivity

-- $ We use injections and projections model the relationship between a
-- 'Coproduct' and the individual component types. An instance of the 'Inject'
-- typeclass describes how to reach inside some type @g@ to access the @f@
-- inside it.
--
-- The instances below assume that 'Coproduct' is associated to the right.

class (Functor f, Functor g) => Inject f g where
    inj :: f a -> g a
    prj :: g a -> Maybe (f a)

-- | Injectivity is reflexive.
instance (Functor f) => Inject f f where
    inj = id
    prj = Just

-- | Injectivity for the head of a 'Coproduct'.
instance {-# OVERLAPS #-} (Functor f, Functor g) => Inject f (Coproduct f g)
  where
    inj = left
    prj = coproduct (Just) (const Nothing)

-- | Injectivity in the tail of a 'Coproduct'.
instance {-# OVERLAPS #-} (Functor f, Functor g, Functor h, Inject f g)
    => Inject f (Coproduct h g)
  where
    inj = right . inj
    prj = coproduct (const Nothing) (prj)

-- * Natural transformations

-- $ A natural transformation (as we're using the term here; Haskell fake
-- category theory strikes again!) is a function between functors.
--
-- In the same way that @Coproduct F G A@ is like 'Either' but for the wrappers
-- around the @A@ a natural transformation is like a function but for the
-- wrappers around the value. (You might need to look at the source for '~>'
-- below for this to make sense.)
--
-- Note that our natural transformations don't insist their domains and
-- codomains be 'Functor's, just that they be type constructors with a single
-- parameter.
--
-- While there are libraries that provide natural transformations, they are
-- just functions with types like @forall a. f a -> g a@.

-- | A natural transformation from f to g.
newtype f ~> g = NT { apply :: forall a. f a -> g a }

-- | Compose two natural transformations.
compose :: f ~> g -> g ~> h -> f ~> h
compose fg gh = NT (apply gh . apply fg)

-- | Use two natural transformations to transform a 'Coproduct'.
sum :: f ~> h -> g ~> h -> (Coproduct f g) ~> h
sum ft gt = NT (coproduct (apply ft) (apply gt))

-- * Free monad

-- $ Construct the free monad associated with an arbitrary functor.
--
-- The basic function described here and much more besides is available in the
-- @free@ package with assorted useful additions in @kan-extensions@.

-- | From any functor @f@, build a monad.
data Free f a = Pure a | Free (f (Free f a))

instance Functor f => Functor (Free f) where
    fmap f (Pure a) = Pure (f a)
    fmap f (Free ma) = Free $ (fmap f) <$> ma

instance Functor f => Applicative (Free f) where
    pure = Pure

    Pure f <*> Pure a = Pure $ f a
    Pure f <*> Free mb = Free $ fmap f <$> mb
    Free mf <*> b = Free $ (<*> b) <$> mf

instance Functor f => Monad (Free f) where
    return = Pure

    Pure a >>= f = f a
    Free m >>= f = Free ((>>= f) <$> m)

-- | Lift a functorial value into a free monad.
liftF :: (Functor f) => f a -> Free f a
liftF = Free . fmap return

-- | Lift a functorial value into a free monad, injecting it into a more general
-- functor along the way.
liftI :: (Functor f, Functor g, Inject f g) => f a -> Free g a
liftI fa = liftF (inj fa)

-- * Define algebras

-- $ Now we can define "algrebas" which each represent a separate "concern" of
-- our program.

type Thing = String
type Image = String
type Sound = String

-- | We can glance or stare at a specific object or just gaze at the view.
data See a
    = Glance Thing (Image -> a)
    | Stare Thing (Image -> a)
    | Gaze (Image -> a)
  deriving (Functor)

-- | We can convert a 'See a' into an 'IO a' by performing the glance, stare,
-- and gaze actions.
ioSee :: See ~> IO
ioSee = NT see
  where
    see (Glance s a) = putStrLn ("Glace at " <> s) >> return (a "a glimpse of a bird")
    see (Stare s a) = putStrLn ("Stare at " <> s) >> return (a "you're sure it's a cat")
    see (Gaze a) = putStrLn ("Gaze around") >> return (a "the sky is blue")

-- | We can listen to the sounds around us.
data Hear a
    = Listen (Sound -> a)
  deriving (Functor)

-- | We can convert a 'Hear a' into an 'IO a' by performing the listen action.
ioHear :: Hear ~> IO
ioHear = NT hear
  where
    hear (Listen a) = putStrLn ("You strain your ears") >> return (a "is that greensleeves? or a meow")

-- | We can poke or prod specific objects.
data Touch a
    = Poke Thing a
    | Prod Thing a
  deriving (Functor)

-- | We can convert a 'Touch a' into an 'IO a' by performing the poke and prod
-- actions.
ioTouch :: Touch ~> IO
ioTouch = NT touch
  where
    touch (Poke t a) = putStrLn ("[PROD] " <> t) >> return a
    touch (Prod t a) = putStrLn ("[PROD] " <> t) >> return a

-- | We can make noises with our mouth.
data Say a
    = Say String a
    | Shout String a
    | Whisper String a
  deriving (Functor)

-- | We can convert a 'Say a' into an 'IO a' by performing the say, whisper,
-- and shout actions.
ioSay :: Say ~> IO
ioSay = NT say
  where
    say (Say m a) = putStrLn ("\"" <> m <> ",\" you say") >> return a
    say (Whisper m a) = putStrLn ("\"" <> map toLower m <> ",\" you whisper") >> return a
    say (Shout m a) = putStrLn ("\"" <> map toUpper m <> ",\" you shout") >> return a

-- $ We can combine one or more of these algebras using the 'Coproduct' type.
-- Because we have `Inject` instances for `Coproduct` all of the lifted DSL
-- operations we defined above should work in any coproduct which includes the
-- appropriate algebra.
--
-- We can even add additional algebras defined in different libraries and it
-- will all interoperate nicely.

-- | The 'Program' algebra is just the coproduct of the 'See', 'Hear', 'Touch',
-- and 'Say' algebras.
type Program = (Coproduct See (Coproduct Hear (Coproduct Touch Say)))

-- | We can convert a 'Program a' value into an 'IO a' value by converting the
-- 'See a' (if it is one) into an 'IO a', or the 'Hear a' (if it is one) into an
-- 'IO a', etc. To do this we just apply the natural transformations we defined
-- above in the appropriate order.
ioProgram :: Coproduct See (Coproduct Hear (Coproduct Touch Say)) ~> IO
ioProgram = sum ioSee (sum ioHear (sum ioTouch ioSay))

-- * Lifted "DSL"

-- $ We can lift the constructors of each "algebra" using the 'liftI' function
-- we wrote above. This makes it easy to use any of the operations in any 'Free'
-- monad which includes the specific algebra the operation comes from. In
-- particular, we will be able to use all of them in the 'Program' algebra we
-- defined above.

glance :: (Inject See f) => Thing -> Free f Image
glance t = liftI (Glance t id)

stare :: (Inject See f) => Thing -> Free f Image
stare t = liftI (Stare t id)

gaze :: (Inject See f) => Free f Image
gaze = liftI (Gaze id)

listen :: (Inject Hear f) => Free f Sound
listen = liftI (Listen id)

poke :: (Inject Touch f) => Thing -> Free f ()
poke t = liftI (Poke t ())

prod :: (Inject Touch f) => Thing -> Free f ()
prod t = liftI (Prod t ())

say :: (Inject Say f) => String -> Free f ()
say m = liftI (Say m ())

shout :: (Inject Say f) => String -> Free f ()
shout m = liftI (Shout m ())

whisper :: (Inject Say f) => String -> Free f ()
whisper m = liftI (Whisper m ())

-- * Writing programs

-- $ With our infrastructure in place and our algebras defined and lifted for
-- convenient use we're ready to write some programs.

-- | Use all four of the algebras we defined in a single program.
prog1 :: Free Program ()
prog1 = do
    img <- gaze
    sound <- listen
    when ("meow" `isInfixOf` sound) $ do
        shout "CAT"
        poke "the cat"
    when ("tweet" `isInfixOf` sound) $
        whisper "bird"
    say "I'm done"

-- | Use just a single algebra.
prog2 :: Free Say ()
prog2 = do
  say "LOL"
  shout "Bang"

-- * Running programs

-- $ The final step is to be able to interpret a program in a 'Free' monad in a
-- way that does some useful work. We do this by unwinding the 'Free' structure
-- while transforming the algebraic structure using a natural transformation.
--
-- The particular natural transformation we choose identifies the target monad
-- and actually performs the effects while the 'interpret' function below
-- stitches them together into a single monadic value.

-- | Intepret a free monad using a natural transformation from the functor to a
-- monad.
--
-- This is essentially 'foldFree' from the @free@ package.
interpret :: (Functor f, Monad g) => f ~> g -> Free f a -> g a
interpret fg (Pure a) = pure a
interpret fg (Free m) = apply fg m >>= interpret fg
