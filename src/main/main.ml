open Json_processor
open Cfg_extractor

let () =
  let res = parse_prog "test.json" in
  Format.printf "%a" Types.pp_prog res;
  let rev_res = Reverser.flip_arith_logic_instrs res in
  Format.printf "%a" Types.pp_prog rev_res;
  let res' = to_json rev_res |> Yojson.Basic.to_string in
  Format.printf "%s" res'