(* ========================================================= *)
(* Strategy Pattern in OCaml based on the C++ version            *)
(* ========================================================= *)

(* ---------- Helper stuff ---------- *)
let print_list lst =
  print_string "[ ";
  List.iter (Printf.printf "%d ") lst;
  print_endline "]"

let time f x =
  let start = Sys.time () in
  let result = f x in
  let finish = Sys.time () in
  (result, finish -. start)

let sort_with strategy lst =
  strategy lst

(* concrete strategies *)
let quicksort = List.sort compare

let rec mergesort = function
  | [] | [_] as l -> l
  | lst ->
      let rec split = function
        | [] -> [], []
        | [x] -> [x], []
        | x::y::zs ->
            let l, r = split zs in
            (x::l, y::r)
      in
      let left, right = split lst in
      let l = mergesort left in
      let r = mergesort right in
      let rec merge a b = match a, b with
        | [], ys -> ys
        | xs, [] -> xs
        | x::xs, y::ys ->
            if x <= y then x :: merge xs (y::ys)
            else y :: merge (x::xs) ys
      in
      merge l r

let rec bubblesort lst =
  let rec bubble = function
    | [] -> [], false
    | [x] -> [x], false
    | x::y::zs ->
        let rest, swapped = bubble (y::zs) in
        if x > y then (y :: (x::rest), true)
        else (x :: rest, swapped)
  in
  let rec aux l =
    let l', swapped = bubble l in
    if swapped then aux l' else l'
  in
  aux lst

(* ========================================================= *)
(*  Strategy Pattern  via functors                           *)
(* ========================================================= *)

module type SORT = sig
  val sort : int list -> int list
end

module QuickSort : SORT = struct
  let sort = quicksort
end

module MergeSort : SORT = struct
  let sort = mergesort
end

module BubbleSort : SORT = struct
  let sort = bubblesort
end

(* SortContext functor — adds a timed wrapper *)
module SortContext (S : SORT) = struct
  let sort = S.sort
  let sort_timed lst = time S.sort lst
end

let lambda_strategy name f =
  fun lst ->
    let res, dt = time f lst in
    Printf.printf "%s took %.6fs\n" name dt;
    res

(* ========================================================= *)
(*  MAIN TEST                                               *)
(* ========================================================= *)

let () =
  let lst = [5;1;8;3;9;2;7;4;6] in
  print_string "Original: "; print_list lst;

  let (r, dt) = time quicksort lst in
  Printf.printf "Quicksort time: %.6fs  Result: " dt; print_list r;

  let (r, dt) = time mergesort lst in
  Printf.printf "MergeSort time: %.6fs  Result: " dt; print_list r;

  let (r, dt) = time bubblesort lst in
  Printf.printf "BubbleSort time: %.6fs  Result: " dt; print_list r;

  (* using functor-based context *)
  let module QS = SortContext(QuickSort) in
  let (_res, t) = QS.sort_timed lst in
  Printf.printf "Functor QuickSort time: %.6fs\n" t;

  (* lambda strategy *)
  let ls = lambda_strategy "lambda-quicksort" quicksort in
  let _ = ls lst in
  ()