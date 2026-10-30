# A mention in a type position (an equation's endpoints) is dead: the
# measure does not count it, so the caret must not point there either.

import Base

def f(x: Nat) -> Nat:
  y = {x == x : Nat}
  Nat.add(x, x)

#|SOME PROOFS FAIL
#|Error:
#|- expected : x
#|- observed : x (consumed more than once)
#|Context:
#|- x : Nat
#|- y : Data
#|Location: f
#|7 |   y = {x == x : Nat}
#|8>|   Nat.add(x, x)
#|  |              ^
#|9 | 
#|exit 1
