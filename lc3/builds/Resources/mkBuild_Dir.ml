module Sim = struct
  type sim = Bluesim | Verilator | Iverilog

  let to_string = function
    | Bluesim -> "bluesim"
    | Verilator -> "verilator"
    | Iverilog -> "iverilog"
end

let makebuilddir (repo : string) (sim : Sim.sim) (debug : bool) (tv : bool) =
  let sim_name = Sim.to_string sim in
  let dir_name = Format.sprintf "_%s_%b" sim_name tv in
  if debug then
    Printf.printf "repo: %s\ndir name: %s\ndebug: %b\nsim: %s\ntandem: %b\n"
      repo dir_name debug sim_name tv;
  (try Unix.mkdir dir_name 0o744
   with Unix.Unix_error (Unix.EEXIST, _, _) ->
     if debug then Printf.printf "Directory exists: %s\n" dir_name);
  let makefile_name = Filename.concat dir_name "Makefile" in
  let header = "# *** DO NOT EDIT! ***\n" in
  Out_channel.with_open_text makefile_name (fun oc ->
      let write_line line = Printf.fprintf oc "%s\n" line in
      let resources_dir = "builds/Resources" in
      write_line header;
      write_line "# Flags";
      write_line "# =====";
      write_line @@ Format.sprintf "REPO ?= %s\n" repo;
      write_line "# Config macros passed to bsc";
      write_line "# ===========================";
      write_line "BSC_COMPILATION_FLAGS += \\";
      if tv then write_line "\t-D INCLUDE_TANDEM_VERIF";
      if debug then write_line "\t-D INCLUDE_GDB_CONTROL";
      write_line "";
      write_line "# Common boilerplate rules";
      write_line "# ========================";
      write_line
      @@ Format.sprintf "include %s/%s/Include_Common.mk\n" repo resources_dir;
      write_line @@ Format.sprintf "# Makefile rules for simulator: %s" sim_name;
      write_line "# ======================================";
      write_line
      @@ Format.sprintf "include %s/%s/Include_%s.mk\n" repo resources_dir
           sim_name;
      ())

let usage_msg = "Usage: ./mkBuild_Dir.ml [repo]"
let repo = ref None
let sim = ref Sim.Bluesim
let debug = ref false
let tandem = ref false
let anon_fun r = repo := Some r

let speclist =
  [
    ( "-sim",
      Arg.String
        (fun s ->
          sim :=
            match s with
            | "bluesim" -> Bluesim
            | _ as x -> failwith @@ Format.sprintf "Not implemented: %s\n" x),
      "bluesim [default], verilator or iverilog" );
    ("-debug", Arg.Set debug, "Debug");
    ("-tandem", Arg.Set tandem, "Tandem verification");
  ]

let () =
  Arg.parse speclist anon_fun usage_msg;
  match !repo with
  | None -> Arg.usage speclist usage_msg
  | Some repo -> makebuilddir (Unix.realpath repo) !sim !debug !tandem
