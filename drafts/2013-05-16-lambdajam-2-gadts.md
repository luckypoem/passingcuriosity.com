[Matthew Brecknell](http://matthew.brecknell.net) ([@mbrcknl][]) on Generalised
[Algebraic Data Types and nested types.

[@mbrcknl]: http://twitter.com/mbrcknl


- 2-3 btree comprises either {one,two} data + {two,three} subtrees; a leaf
  containing nothing at all.
- Every leaf is equidstanct from root.
- Data ordered left to right.

data N a
 = T1 (T a) a (T a)
 | T2 (T a) a (T a) a (T a)

data T a
 = Br (N a)
 | LF

But this doesn't enforce all of our structural invariants.

GADTs
=====

Given `T`, what's the type of a data constructor?

    ghci> :t Br
    BR :: N a -> T a

Writing the data type as a GADT:

    data T a where
      Br :: N a -> T a
      LF :: T a

Each constructor can have a specialised result type. This lets us specialise
the types of each constructor.

Using type-level natural numbers to include the depth of a tree and use this
to maintain the invariant/s:

    {-# LANGUAGE DataKinds #-}

    data Nat = Z | S Nat

    data T a where
      Br :: N n a -> T (S n) a
      LF :: T Z a

    -- Add `n`s to constructors in N.

Wrap the whole thing in an existential type for clients.

    data Tree a where
      Tree :: T n a -> Tree a

Insertion algorithm:

Two cases:

1. Insert value into subtree
2. Overflow.

    {-# LANGUAGE ScopedTypeVariables #-}
    -- | Smart constructor
    t1 = undefined

    insert :: Ord a => a -> Tree a -> Tree a
    insert x (Tree t) = ins t Tree (((Tree .) .) . t1)
       where ins :: T n a -> Keep t n a -> Push t n a -> t
             ins LF = \keep push -> push LF x LF
	     ins (Br n) = i n
	     	 where i :: S p ~ n =>
		       	    N p a -> Keep t n a -> Push t n a -> t
		       i = undefined

(A `T Z a` must be a leaf, you can't build one with the branch const)

Well-typed, invariant enforcing data structures with a nice interface for
clients to use.