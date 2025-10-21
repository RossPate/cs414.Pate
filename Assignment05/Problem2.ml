(* File: Assignment05/Problem2.ml *)
(* Description: Implementation of a zipper list in OCAML *)
(* Author: Ross Pate *)

type 'a zipper = {
  front : 'a list;  (* items before the focus, stored reversed *)
  focus : 'a;       (* current element *)
  back  : 'a list;  (* items after the focus *)
}

type 'a t =
  | Empty
  | NonEmpty of 'a zipper

let is_empty = function
  | Empty -> true
  | _ -> false

let create_empty = Empty

(* Move focus one step left *)
let move_left = function
  | Empty -> Empty
  | NonEmpty { front = []; _ } as z -> z
  | NonEmpty { front = x :: xs; focus; back } ->
      NonEmpty { front = xs; focus = x; back = focus :: back }

(* Move focus one step right *)
let move_right = function
  | Empty -> Empty
  | NonEmpty { back = []; _ } as z -> z
  | NonEmpty { front; focus; back = x :: xs } ->
      NonEmpty { front = focus :: front; focus = x; back = xs }

(* Add an item to the logical front *)
let push_front x = function
  | Empty -> NonEmpty { front = []; focus = x; back = [] }
  | NonEmpty z -> NonEmpty { z with front = x :: z.front }

(* Add an item to the logical back *)
let push_back x = function
  | Empty -> NonEmpty { front = []; focus = x; back = [] }
  | NonEmpty z -> NonEmpty { z with back = x :: z.back }

(* Get the current focus *)
let focus = function
  | Empty -> None
  | NonEmpty z -> Some z.focus

(* First logical element *)
let front = function
  | Empty -> None
  | NonEmpty { front = h :: _; _ } -> Some h
  | NonEmpty { front = []; focus; _ } -> Some focus

(* Last logical element *)
let back = function
  | Empty -> None
  | NonEmpty { back = h :: _; _ } -> Some h
  | NonEmpty { back = []; focus; _ } -> Some focus
