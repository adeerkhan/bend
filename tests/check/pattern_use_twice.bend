# A pattern field used twice: the caret points at the second use. Marking
# the field, 1n+(+p), lets it be copied.

import Base

def twice(n: Nat) -> Nat:
  match n:
    case 0n:
      0n
    case 1n+p:
      Nat.add(p, p)

#|SOME PROOFS FAIL
#|Error:
#|- expected : p
#|- observed : p (consumed more than once)
#|Context:
#|- p : Nat
#|Location: twice
#|10 |     case 1n+p:
#|11>|       Nat.add(p, p)
#|   |                  ^
#|12 | 
#|exit 1
