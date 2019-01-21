(*Hint: Poglej si "Pervasives" *)

(*PRVA NALOGA*)

(*A*)

let razlika_kvadratov a b =
  let kvadrat_vsote = (a + b) * (a + b) in
  let vsota_kvadratov = (a * a + b * b) in
  kvadrat_vsote - vsota_kvadratov
  

(*B*)

let uporabi_na_paru f (x, y) = (f x, f y)

(*C*)

let rec ponovi_seznam n sez =
  if n <= 0 then
    []
  else
    sez @ ponovi_seznam (n-1) sez

(*D*)

let razdeli sez =
  let rec raz n_acc p_acc = function
    | [] -> (List.rev n_acc, List.rev p_acc)
    | x :: xs when x < 0 -> raz (x :: n_acc) p_acc xs
    | x :: xs -> raz n_acc (x :: p_acc) xs
  in raz [] [] sez

(*DRUGA NALOGA*)

type 'a tree =
  | Empty
  | Node of 'a tree * 'a * 'a tree


let leaf x = Node(Empty, x, Empty)

(*A*)

(*
1. vrh drevesa je v verigi
  a. padajoča v desnem + 11 + naraščajoča v levem 
  b. naraščajoča v desnem + 11 + padajoča v levem 
*)

let test1 =
  Node(
    Node(
      leaf 3, 10, Node(leaf 14, 13, leaf 6)),
      11,
      Node(leaf 2, 8, leaf 10)
  )

  let test2 =
    Node(
      Node(
        leaf 3, 12, Node(leaf 14, 13, leaf 6)),
        11,
        Node(leaf 2, 8, leaf 10)
    )
let rec padajoca v = function
  | Empty -> []
  | Node(lt, x, rt) when x > v -> []
  | Node(lt, x, rt) ->
    let left = padajoca x lt in
    let right = padajoca x rt in
    if List.length left > List.length right then
      left @ [x]
    else
      right @ [x]

let rec narascajoca v = function
  | Empty -> []
  | Node(lt, x, rt) when x < v -> []
  | Node(lt, x, rt) ->
    let left = narascajoca x lt in
    let right = narascajoca x rt in
    if List.length left > List.length right then
      x :: left
    else
      x :: right

let rec monotona_pot = function
  | Empty -> []
  | Node(lt, x, rt) ->
    (* Rekurzivno iščemo verige *)
    let pure_left = monotona_pot lt in
    let pure_right = monotona_pot rt in
    let left_to_right = (padajoca x lt) @ [x] @ (narascajoca x rt) in
    let right_to_left = (padajoca x rt) @ [x] @ (narascajoca x lt) in
    (* Izberi najdaljšo verigo *)
    let options = [pure_right; left_to_right; right_to_left] in
    let pick_bigger x y = if List.length x > List.length y then x else y in
    List.fold_left pick_bigger pure_left options

(* TRETJA NALOGA *)

type 'a veriga =
  | Filter of ('a -> bool) * 'a list * 'a veriga
  | Ostalo of 'a list

(*A*)

let test = Filter((fun x -> x < 0), [], Filter((fun x -> x < 10), [], Ostalo []))

(*B*)

let rec vstavi x veriga =
  match veriga with
  | Ostalo (elementi) -> Ostalo (x :: elementi)
  | Filter(f, elementi, filtri) -> 
    if f x then
      Filter(f, x :: elementi, filtri)
    else
      Filter(f, elementi, vstavi x filtri)

let rec vstavi x veriga =
  match veriga with
  | Ostalo (elementi) -> Ostalo (x :: elementi)
  | Filter (f, elementi, filtri) when f x -> Filter (f, x :: elementi, filtri)
  | Filter (f, elementi, filtri) -> Filter(f, elementi, vstavi x filtri)

(*C*)

let rec poisci x = function
  | Ostalo (elementi) -> List.mem x elementi
  | Filter (f, elementi, filtri) ->
    if f x then List.mem x elementi else poisci x filtri

(*D*)

let rec izprazni = function
  | Ostalo elementi -> (Ostalo [], elementi)
  | Filter (f, elementi, filtri) ->
    let prazni_filtri, pobrani_elementi = izprazni filtri in
    let vsi_elementi = elementi @ pobrani_elementi in
    (Filter(f, [], prazni_filtri), vsi_elementi)

(*E*)

let dodaj f veriga =
  let veriga' = Filter(f, [], veriga) in
  let prazna_veriga, elementi = izprazni veriga' in
  List.fold_left (fun v x -> vstavi x v) prazna_veriga elementi