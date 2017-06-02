(** [ Model Parallel ] Parameter server module  *)

open Actor_types

let start jid url =
  let _ztx = ZMQ.Context.create () in
  let _addr, _router = Actor_utils.bind_available_addr _ztx in
  let req = ZMQ.Socket.create _ztx ZMQ.Socket.req in
  ZMQ.Socket.connect req url;
  Actor_utils.send req Job_Reg [|_addr; jid|];
  (* create and initialise part of the context *)
  let _context = Actor_utils.empty_param_context () in
  _context.job_id <- jid;
  _context.myself_addr <- _addr;
  _context.myself_sock <- _router;
  _context.ztx <- _ztx;
  (* depends on the role, start server or client *)
  let m = of_msg (ZMQ.Socket.recv req) in
  match m.typ with
  | Job_Master -> Actor_paramserver.init m _context
  | Job_Worker -> Actor_paramclient.init m _context
  | _ -> Actor_logger.info "%s" "unknown command";
  ZMQ.Socket.close req

let register_barrier (f : ps_barrier_typ) =
  Actor_paramserver._barrier := Marshal.to_string f [ Marshal.Closures ]

let register_schedule (f : ('a, 'b, 'c) ps_schedule_typ) =
  Actor_paramserver._schedule := Marshal.to_string f [ Marshal.Closures ]

let register_pull (f : ('a, 'b, 'c) ps_pull_typ) =
  Actor_paramserver._pull := Marshal.to_string f [ Marshal.Closures ]

let register_push (f : ('a, 'b, 'c) ps_push_typ) =
  Actor_paramclient._push := Marshal.to_string f [ Marshal.Closures ]

let register_stop (f : ps_stop_typ) =
  Actor_paramserver._stop := Marshal.to_string f [ Marshal.Closures ]

let get k =
  match Actor_paramserver.(!_context.job_id) = "" with
  | true  -> Actor_paramclient._get k
  | false -> Actor_paramserver._get k

let set k v =
  match Actor_paramserver.(!_context.job_id) = "" with
  | true  -> Actor_paramclient.(_set k v !_context.step)
  | false -> Actor_paramserver.(_set k v !_context.step)

let keys () = Hashtbl.fold (fun k v l -> l @ [ Obj.obj k ]) Actor_paramserver._param []