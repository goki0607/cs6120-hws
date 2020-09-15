(* for now lets not support pointer types *)
(* also lets not support floating-point types *)
type typ = 
    Int
  | Bool (*| Pointer of typ | Float of float*)
[@@deriving show]

type cst = 
    IntC of int
  | BoolC of bool
[@@deriving show]

type lbl = string [@@deriving show]
type arg = string [@@deriving show]
type dst = string [@@deriving show]

(* binary operations *)
type binop =
    Add  (* arithmetic operations *)
  | Mul
  | Sub
  | Div
  | Eq   (* compare operations *)
  | Lt
  | Gt
  | Le
  | Ge 
  | And  (* logical operations *)
  | Or
[@@deriving show]
  (*| Store | Ptradd*)

(* unary operations *)
type unop =
    Not
  | Id  (*| Alloc | Free | Load*)
[@@deriving show]

(* types of instructions *)
type instr =
    Label of lbl
  | Cst of dst * typ * cst
  | Binop of dst * typ * binop * arg * arg
  | Unop of dst * typ * unop * arg
  | Jmp of lbl
  | Br of arg * lbl * lbl
  | Call of dst option * typ option * string * arg list option
  | Ret of arg option
  | Print of arg list
  | Nop
[@@deriving show]

type func = {
  name : string ;
  args : ((arg * typ) list) option ;
  rtyp : typ option ;
  instrs : instr list ;
}
[@@deriving show]

type prog = func list
[@@deriving show]
