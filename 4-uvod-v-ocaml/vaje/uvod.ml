
(* ========== Vaja 1: Uvod v OCaml  ========== *)
(*
let vsota_celih x y =
  x + y

let prvi = function
  | [] -> None
  | x :: xs -> Some x

let drugi_prvi list =
  match list with 
  | [] -> None
  | x :: xs -> Some x
*)

let rec reverse acc seznam  =  
  match seznam with
  | [] -> acc
  | x :: [] -> x :: acc
  | x :: xs -> reverse (x :: acc) xs 

(*----------------------------------------------------------------------------*]
 Funkcija [penultimate_element] vrne predzadnji element danega seznama. V
 primeru prekratkega seznama vrne napako.
 - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
 # penultimate_element [1; 2; 3; 4];;
 - : int = 3
[*----------------------------------------------------------------------------*)

let rec penultimate_element list = 
  match list with
  | [] | _ :: [] -> failwith "List too short"
  | x :: y :: [] -> x
  | x :: xs -> penultimate_element (xs)

(*----------------------------------------------------------------------------*]
 Funkcija [get k list] poišče [k]-ti element v seznamu [list]. Številčenje
 elementov seznama (kot ponavadi) pričnemo z 0. Če je k negativen, funkcija
 vrne ničti element. V primeru prekratkega seznama funkcija vrne napako.
 - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
 # get 2 [0; 0; 1; 0; 0; 0];;
 - : int = 1
[*----------------------------------------------------------------------------*)

let rec get k list =
  match k, list with
  | _, [] -> failwith "List too short"
  | k, x :: xs when k <= 0 -> x
  | k, x :: xs -> get (k -1) xs
(* Lahko tudi takole: *)

let rec lepsi_get k = function
  | [] -> failwith "List is too short!"   
  | x :: xs when k <= 0 -> x
  | x :: xs -> lepsi_get (k - 1) xs

(*----------------------------------------------------------------------------*]
 Funkcija [double] podvoji pojavitve elementov v seznamu.
 - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
 # double [1; 2; 3];;
 - : int list = [1; 1; 2; 2; 3; 3]
[*----------------------------------------------------------------------------*)

let rec double = function
  | [] -> []
  | x :: xs -> (x :: x :: double xs) 

(*----------------------------------------------------------------------------*]
 Funkcija [divide k list] seznam razdeli na dva seznama. Prvi vsebuje prvih [k]
 elementov, drugi pa vse ostale. Funkcija vrne par teh seznamov. V primeru, ko
 je [k] izven mej seznama, je primeren od seznamov prazen.
 - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
 # divide 2 [1; 2; 3; 4; 5];;
 - : int list * int list = ([1; 2], [3; 4; 5])
 # divide 7 [1; 2; 3; 4; 5];;
 - : int list * int list = ([1; 2; 3; 4; 5], [])
[*----------------------------------------------------------------------------*)

let rec divide k list = 
  match k, list with
  | k, list when (k <= 0) -> ([], list)
  | k, [] -> ([], [])
  | k, x :: xs -> let (left_list, right_list) = divide (k-1) xs in (x :: left_list, right_list)


(*----------------------------------------------------------------------------*]
 Funkcija [delete k list] iz seznama izbriše [k]-ti element. V primeru
 prekratkega seznama funkcija vrne napako.
 - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
 # delete 3 [0; 0; 0; 1; 0; 0];;
 - : int list = [0; 0; 0; 0; 0]
[*----------------------------------------------------------------------------*)

let rec delete k = 
  let rec delete_aux k acc = function
    | [] -> failwith "List is too short!"   
    | x :: xs when k <= 0 -> acc @ xs
    | x :: xs -> delete_aux (k - 1) (acc @ [x]) xs
  in delete_aux k []
(*----------------------------------------------------------------------------*]
 Funkcija [slice i k list] sestavi nov seznam, ki vsebuje elemente seznama
 [list] od vključno [i]-tega do izključno [k]-tega. Predpostavimo, da sta [i] in
 [k] primerna.
 - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
 # slice 3 6 [0; 0; 0; 1; 2; 3; 0; 0];;
 - : int list = [1; 2; 3]
[*----------------------------------------------------------------------------*)

(*
let rec slice i k list= 
  let rec slice_aux i k list acc = 
    match i, k, list with
    | _, _,  [] -> acc
    | 0, 0, x :: xs -> acc
    | 0, _, x :: xs -> slice_aux i (k-1) (x :: acc) xs
    | _, _, x :: xs -> slice_aux (i-1) (k-1) acc xs
  in reverse (slice_aux i k list [] ) []
*)
let rec slice i k list =
  let rec slice' i k acc = function
    | [] -> []
    | x :: xs when (i <> 0 && k <> 0) -> slice' (i-1) (k-1) acc xs
    | x :: xs when (i = 0 && k <> 0) -> slice' i (k-1) (x :: acc) xs
    | x :: xs when (i = 0 && k = 0) -> acc
  in reverse [] (slice' i k [] list)
(*----------------------------------------------------------------------------*]
 Funkcija [insert x k list] na [k]-to mesto seznama [list] vrine element [x].
 Če je [k] izven mej seznama, ga funkcija doda na začetek oziroma na konec.
 - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
 # insert 1 3 [0; 0; 0; 0; 0];;
 - : int list = [0; 0; 0; 1; 0; 0]
 # insert 1 (-2) [0; 0; 0; 0; 0];;
 - : int list = [1; 0; 0; 0; 0; 0]
[*----------------------------------------------------------------------------*)

(*
let insert x k list =
  let l = List.length list in
  match k with
  | _ when l = 0 -> []
  | i when i < 0 -> x :: list
  | i when i > l -> list @ [x]
  | i -> 
    let left, right = divide i list in
    left @ [x] @ right

*)

let rec insert x k list =
  let l = List.length list in
  let rec insert' x k list acc =
    match k, list with
    | _, [] -> (reverse [] (x :: acc))
    | i, y :: ys when i < 0 -> x :: y :: ys
    | i, y :: ys when i > (l-1) -> (y :: ys) @ [x]
    | 0, _ -> (reverse [] (x :: acc)) @ list
    | i, y :: ys -> insert' x (i-1) ys (y :: acc)
  in insert' x k list []


(*----------------------------------------------------------------------------*]
 Funkcija [rotate n list] seznam zavrti za [n] mest v levo. Predpostavimo, da
 je [n] v mejah seznama.
 - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
 # rotate 2 [1; 2; 3; 4; 5];;
 - : int list = [3; 4; 5; 1; 2]
[*----------------------------------------------------------------------------*)

let rec rotate n list = 
  let rec rotate' n list acc =
    match n, list with
    | _, [] -> []
    | 0, _ -> list @ (reverse [] acc)
    | i, y :: ys -> rotate' (i - 1) ys (y :: acc)
  in rotate' n list []

(*----------------------------------------------------------------------------*]
 Funkcija [remove x list] iz seznama izbriše vse pojavitve elementa [x].
 - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
 # remove 1 [1; 1; 2; 3; 1; 2; 3; 1; 1];;
 - : int list = [2; 3; 2; 3]
[*----------------------------------------------------------------------------*)

let rec remove x list = 
  let rec remove' x list acc =
    match x, list with
    | _, [] -> reverse [] acc
    | z, y :: ys when z <> y -> remove' x ys (y :: acc) 
    | z, y :: ys -> remove' x ys acc
  in remove' x list []

(*----------------------------------------------------------------------------*]
 Funkcija [is_palindrome] za dani seznam ugotovi ali predstavlja palindrom.
 Namig: Pomagaj si s pomožno funkcijo, ki obrne vrstni red elementov seznama.
 - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
 # is_palindrome [1; 2; 3; 2; 1];;
 - : bool = true
 # is_palindrome [0; 0; 1; 0];;
 - : bool = false
[*----------------------------------------------------------------------------*)
let first_element = function
    | [] -> failwith "Prazen seznam nima prvega elementa!"
    | y :: ys -> y

let oklesten_seznam list =
  let rec oklesten_seznam' acc list =
    let l = List.length acc in
    match list with
    | [] -> []
    | y :: ys when l = 2 -> y :: ys
    | y :: ys -> oklesten_seznam' (y :: acc) (reverse [] ys)
  in oklesten_seznam' [] list

let rec is_palindrome list =
  let reversed = reverse [] list in
  match list with
    | [] -> true
    | y :: ys when y == (first_element reversed) -> is_palindrome (oklesten_seznam (y :: ys))
    | y :: ys -> false

(*----------------------------------------------------------------------------*]
 Funkcija [max_on_components] sprejme dva seznama in vrne nov seznam, katerega
 elementi so večji od istoležnih elementov na danih seznamih. Skupni seznam ima
 dolžino krajšega od danih seznamov.
 - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
 # max_on_components [5; 4; 3; 2; 1] [0; 1; 2; 3; 4; 5; 6];;
 - : int list = [5; 4; 3; 3; 4]
[*----------------------------------------------------------------------------*)

let max_on_components list1 list2 =
  let rec max_on_components' list1 list2 acc =
    match list1, list2 with
    | [], _ | _, [] -> reverse [] acc
    | x :: xs, y :: ys when x >= y -> max_on_components' xs ys (x :: acc)
    | x :: xs, y :: ys -> max_on_components' xs ys (y :: acc)
  in max_on_components' list1 list2 []

(*----------------------------------------------------------------------------*]
 Funkcija [second_largest] vrne drugo največjo vrednost v seznamu. Pri tem se
 ponovitve elementa štejejo kot ena vrednost. Predpostavimo, da ima seznam vsaj
 dve različni vrednosti.
 Namig: Pomagaj si s pomožno funkcijo, ki poišče največjo vrednost v seznamu.
 - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
 # second_largest [1; 10; 11; 11; 5; 4; 10];;
 - : int = 10
[*----------------------------------------------------------------------------*)
let largest list =
  let rec largest' list acc =
    match list with
    | [] -> first_element acc
    | y :: ys when [y] > acc ->
      let new_acc = [y] in
      largest' ys new_acc
    | y :: ys -> largest' ys acc
  in largest' list []


let second_largest list =
  match list with 
    | [] -> failwith "prazen seznam nima največjega elementa!"
    | y :: ys -> 
    let najvecji = largest list in
    largest (remove najvecji (y :: ys))
