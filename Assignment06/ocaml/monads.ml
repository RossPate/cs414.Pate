module type MONAD = sig
  type 'a t
  val return : 'a -> 'a t
  val bind   : 'a t -> ('a -> 'b t) -> 'b t
  (* Optional: map and apply derived from return/bind *)
  val map    : ('a -> 'b) -> 'a t -> 'b t
end

module Make_infix (M : MONAD) = struct
  let ( >>= ) = M.bind
  let ( let* ) = M.bind      (* for let-operators *)
  let ( >|= ) m f = M.map f m
end

module OptionM : MONAD with type 'a t = 'a option = struct
  type 'a t = 'a option
  let return x = Some x
  let bind m f = match m with None -> None | Some x -> f x
  let map f m = match m with None -> None | Some x -> Some (f x)
end

module O = Make_infix(OptionM)

module ResultM : MONAD = struct
  type 'a t = ('a, string) result
  let return x = Ok x
  let bind m f = match m with Error e -> Error e | Ok x -> f x
  let map f m = match m with Error e -> Error e | Ok x -> Ok (f x)
end
module R = Make_infix(ResultM)

module ListM : MONAD = struct
  type 'a t = 'a list
  let return x = [x]
  let bind xs f = List.concat (List.map f xs)
  let map f xs = List.map f xs
end
module L = Make_infix(ListM)

open O

let safe_div x y =
  if y = 0 then None else Some (x / y)

let safe_div3 x y z =
  let* a = safe_div x y in
  let* b = safe_div a z in
  OptionM.return b

  let () =
  match safe_div3 36 2 3 with
  | Some r -> Printf.printf "Result = %d\n" r
  | None -> Printf.printf "Division by zero!\n"