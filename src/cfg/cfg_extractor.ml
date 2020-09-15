open Types

type blocks_t = (Types.lbl, Types.instr list) Hashtbl.t
type cfg_t = (Types.lbl, Types.lbl list) Hashtbl.t

let gen_block_name d = Printf.sprintf "block%d" d

let make_blocks prog =
  (*let funcs = List.to_seq prog |>
    Seq.map (fun func -> (func.name, func)) |>
    Hashtbl.of_seq
  in *)
  let blocks = ref [] in
  let get_blocks instrs = List.fold_left (fun (name,curr_block) instr ->
      match instr with
      | Label lbl -> (lbl, curr_block)
      | Jmp _ | Br _ | Ret _ ->
          blocks := (name,List.rev (instr::curr_block)) :: !blocks;
          (List.length !blocks |> gen_block_name, [])
      | _ -> (name,List.rev (instr::curr_block))
    ) (gen_block_name 0,[]) instrs |> (fun x -> blocks := x::!blocks)
  in
  List.iter (fun func -> get_blocks func.instrs) prog;
  List.rev !blocks (*|>
  List.filter (fun (name,block) -> block <> [])*)

let make_cfg blocks =
  List.mapi (fun i (name,block) ->
    match List.length block |> List.nth block with
    | Jmp lbl -> (name,[lbl])
    | Br (_, lbl1, lbl2) -> (name,[lbl1;lbl2])
    | Ret _ -> (name,[])
    | _ -> match List.nth_opt blocks (i+1) with
        | None -> (name,[])
        | Some (lbl, _) -> (name,[lbl]))
  blocks

let add_phantom_jmps blocks cfg =
  List.mapi (fun i (name,block) ->
    match List.length block |> List.nth_opt block with
    | None -> (name,[Jmp (List.nth blocks (i+1) |> fst)])
    | Some instr -> match instr with
      | Jmp _ | Br _ | Ret _ -> (name,block)
      | _ -> match List.nth_opt blocks (i+1) with
          | None -> (name,block@[Ret None])
          | Some (lbl, _) -> (name,block@[Jmp (Hashtbl.find cfg lbl |> List.hd)])
  ) blocks

let extract_cfg prog =
  let blocks = make_blocks prog in
  let cfg = make_cfg blocks in
  let cfg_map = List.to_seq cfg |> Hashtbl.of_seq in
  let blocks = add_phantom_jmps blocks cfg_map in
  List.to_seq blocks |> Hashtbl.of_seq, cfg_map
