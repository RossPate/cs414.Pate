type 'a rose = Node of 'a * 'a rose list

(* size : 'a rose -> int *)
let rec size tree =
  match tree with
  | Node (_, children) ->
    1 + List.fold_left (fun acc child -> acc + size child) 0 children

(* map : ('a -> 'b) -> 'a rose -> 'b rose *) 
let rec map f tree =
  match tree with
  | Node (value, children) ->
    let new_children = List.map (map f) children in
    Node (f value, new_children)

(* fold : ('a -> 'b list -> 'b) -> 'a rose -> 'b *)
let rec fold f tree =
  match tree with
  | Node (value, children) ->
    let folded_children = List.map (fold f) children in
    f value folded_children
