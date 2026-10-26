# comp-splice pin (spec_comp_do_let): a do-block let without its type.
# Everywhere else a let is `x = v`, but a do statement that starts with a
# name and an `=` is the grammar's DoLet only with its annotation
# (`x : T = v`). The untyped form used to be refused with "a pattern (a
# binder or a constructor)" and the caret on the PREVIOUS statement,
# because the leftover `= v` was re-parsed as the next statement (#1868);
# now the refusal names the working form and points at the let itself.
import Base

def pure_of() -> Nat:
  5n

def f() -> IO(Unit):
  do IO<Unit>:
    IO.print("a")
    x = pure_of()
    IO.print("ok")
    return Unit{}

def main() -> IO(Unit):
  f()
#|SOME PROOFS FAIL
#|Error:
#|- expected : a do-block let with its type (write "x : T = ...", or bind the value before the block)
#|- observed : 'x '
#|Location:
#|15 |     IO.print("a")
#|16>|     x = pure_of()
#|   |     ^^
#|17 |     IO.print("ok")
#|exit 1
