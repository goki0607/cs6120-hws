type blocks_t = (Types.lbl, Types.instr list) Hashtbl.t
type cfg_t = (Types.lbl, Types.lbl list) Hashtbl.t

val extract_cfg : Types.prog -> (blocks_t * cfg_t)