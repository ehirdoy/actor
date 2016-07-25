(** [ Server ]
  Handle actor registration
*)

let context = ZMQ.Context.create () in
let responder = ZMQ.Socket.create context ZMQ.Socket.rep in
ZMQ.Socket.bind responder "tcp://*:5555";

while true do
  let request = ZMQ.Socket.recv responder in
  Printf.printf "Received request: [%s]\n%!" request;
  let s = Actor.to_string Actor.test in
  ZMQ.Socket.send responder s;
done;

ZMQ.Socket.close responder;
ZMQ.Context.terminate context
