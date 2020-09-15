open Types

let flip_binop = function
  | Add -> Sub
  | Sub -> Add
  | Mul -> Div
  | Div -> Mul
  | Lt -> Ge
  | Gt -> Le
  | Ge -> Lt
  | Le -> Gt
  | Eq -> Eq (* sad *)
  | And -> Or
  | Or -> And

let flip_unop = function
  | Not -> Id
  | Id -> Id

let flip_arith_logic_instrs prog =
  List.map (fun func ->
    {
      func with
      instrs = List.map (function
        | Binop (d, t, op, arg1, arg2) -> Binop (d, t, flip_binop op, arg2, arg1)
        | Unop (d, t, op, arg) -> Unop (d, t, flip_unop op, arg)
        | x -> x
      ) func.instrs
    }

  ) prog