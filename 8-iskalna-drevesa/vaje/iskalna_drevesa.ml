(* ========== Vaja 4: Iskalna Drevesa  ========== *)

(*-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*]
 Ocaml omogoča enostavno delo z drevesi. Konstruiramo nov tip dreves, ki so
 bodisi prazna, bodisi pa vsebujejo podatek in imajo dve (morda prazni)
 poddrevesi. Na tej točki ne predpostavljamo ničesar drugega o obliki dreves.
[*-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*)
type 'a tree =
     | Empty
     | Node of 'a tree * 'a * 'a tree

(*
type a' tree =
     | Empty
     | Leaf 'a
     | Node of 'a tree * 'a * 'a tree
kjer je Leaf 'a = Node (Empty, 'a, Empty)
*)

(*----------------------------------------------------------------------------*]
 Definirajmo si testni primer za preizkušanje funkcij v nadaljevanju. Testni
 primer predstavlja spodaj narisano drevo, pomagamo pa si s pomožno funkcijo
 [leaf], ki iz podatka zgradi list.
          5
         / \
        2   7
       /   / \
      0   6   11
[*----------------------------------------------------------------------------*)
let leaf x = Node(Empty, x, Empty)

let test_tree =
     let left_t = Node(leaf 0, 2, Empty) in
     let right_t = Node(leaf 6, 7, leaf 11) in
     Node(left_t, 5, right_t)
     
(*----------------------------------------------------------------------------*]
 Funkcija [mirror] vrne prezrcaljeno drevo. Na primeru [test_tree] torej vrne
          5
         / \
        7   2
       / \   \
      11  6   0
 - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
 # mirror test_tree ;;
 - : int tree =
 Node (Node (Node (Empty, 11, Empty), 7, Node (Empty, 6, Empty)), 5,
 Node (Empty, 2, Node (Empty, 0, Empty)))
[*----------------------------------------------------------------------------*)
let rec mirror = function
     | Empty -> Empty
     | Node(lt, x, rt) -> Node(mirror rt, x, mirror lt)

(*----------------------------------------------------------------------------*]
 Funkcija [height] vrne višino oz. globino drevesa, funkcija [size] pa število
 vseh vozlišč drevesa.
 - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
 # height test_tree;;
 - : int = 3
 # size test_tree;;
 - : int = 6
[*----------------------------------------------------------------------------*)
let rec size = function
     | Empty -> 0
     | Node(lt, x, rt) -> 1 + size lt + size rt

let rec height = function
     | Empty -> 0
     | Node(Empty, x, Empty) -> 0 
     | Node(lt, x, rt) -> 1 + height lt + height rt

(*
repno rekurziven size:
let tl_rec_size tree =
     let rec size' acc queue =
          match queue with
          | [] -> acc
          | t :: ts -> (
               match t with
               | Empty -> size' acc ts
               | Node(lt, x, rt) -> size' (acc + 1) (lt :: rt :: ts)
          )
          in size' 0 [tree]
*)
(*----------------------------------------------------------------------------*]
 Funkcija [map_tree f tree] preslika drevo v novo drevo, ki vsebuje podatke
 drevesa [tree] preslikane s funkcijo [f].
 - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
 # map_tree ((<)3) test_tree;;
 - : bool tree =
 Node (Node (Node (Empty, false, Empty), false, Empty), true,
 Node (Node (Empty, true, Empty), true, Node (Empty, true, Empty)))
[*----------------------------------------------------------------------------*)
let rec map_tree f tree =
     match tree with
     | Empty -> Empty
     | Node(Empty, x, Empty) -> Node(Empty, f x, Empty)
     | Node(lt, x, rt) -> Node((map_tree f lt), (f x), (map_tree f rt))

(*----------------------------------------------------------------------------*]
 Funkcija [list_of_tree] pretvori drevo v seznam. Vrstni red podatkov v seznamu
 naj bo takšen, da v primeru binarnega iskalnega drevesa vrne urejen seznam.
 - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
 # list_of_tree test_tree;;
 - : int list = [0; 2; 5; 6; 7; 11]
[*----------------------------------------------------------------------------*)
let rec list_of_tree = function
     | Empty -> []
     | Node(lt, x, rt) -> list_of_tree lt @ [x] @ list_of_tree rt

(*----------------------------------------------------------------------------*]
 Funkcija [is_bst] preveri ali je drevo binarno iskalno drevo (Binary Search 
 Tree, na kratko BST). Predpostavite, da v drevesu ni ponovitev elementov, 
 torej drevo npr. ni oblike Node( leaf 1, 1, leaf 2)). Prazno drevo je BST.
 - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
 # is_bst test_tree;;
 - : bool = true
 # test_tree |> mirror |> is_bst;;
 - : bool = false
[*----------------------------------------------------------------------------*)
let rec is_bst = function
     | Empty -> true
     | Node(lt, x, rt) -> (
          match lt, rt with
          | Empty, Empty -> true
          | Node(lt1, y, rt1), Empty -> is_bst lt && y < x 
          | Empty, Node(lt2, z, rt2) -> x < z && is_bst rt
          | Node(lt1, y, rt1), Node(lt2, z, rt2) -> is_bst lt && y < x && x < z && is_bst rt
          )

(*-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*]
 V nadaljevanju predpostavljamo, da imajo dvojiška drevesa strukturo BST.
[*-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*)

(*----------------------------------------------------------------------------*]
 Funkcija [insert] v iskalno drevo pravilno vstavi dani element. Funkcija 
 [member] preveri ali je dani element v iskalnem drevesu.
 - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
 # insert 2 (leaf 4);;
 - : int tree = Node (Node (Empty, 2, Empty), 4, Empty)
 # member 3 test_tree;;
 - : bool = false
[*----------------------------------------------------------------------------*)
let rec member x tree = 
     match x, tree with 
     | _, Empty -> false
     | k, Node(lt, c, rt) when k == c -> true
     | k, Node(lt, c, rt) when k < c -> member x lt
     | k, Node(lt, c, rt) when k > c -> member x rt
     | _, Node(_, _, _) -> false (* Dodal, da se program ne bi jezil, da funkcija ni dovolj izčrpna. *) 


let rec insert x tree =
     match x, tree with
     | y, Empty -> leaf y
     | y, Node(lt, z, rt) -> (
          match member x tree with
          | true -> tree
          | false when y < z -> Node((insert y lt), z, rt)
          | false -> Node(lt, z, (insert y rt)) 
     )         

(*----------------------------------------------------------------------------*]
 Funkcija [member2] ne privzame, da je drevo bst.
 
 Opomba: Premislte kolikšna je časovna zahtevnost funkcije [member] in kolikšna
 funkcije [member2] na drevesu z n vozlišči, ki ima globino log(n). 
[*----------------------------------------------------------------------------*)
let rec member2 x tree = 
     match x, tree with 
     | _, Empty -> false
     | k, Node(lt, c, rt) when k == c -> true
     | _, Node(lt, y, rt) -> member2 x lt || member2 x rt


(*----------------------------------------------------------------------------*]
 Funkcija [succ] vrne naslednjika korena danega drevesa, če obstaja. Za drevo
 oblike [bst = Node(l, x, r)] vrne najmanjši element drevesa [bst], ki je večji
 od korena [x].
 Funkcija [pred] simetrično vrne največji element drevesa, ki je manjši od
 korena, če obstaja.
 - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
 # succ test_tree;;
 - : int option = Some 6
 # pred (Node(Empty, 5, leaf 7));;
 - : int option = None
[*----------------------------------------------------------------------------*)
let rec bst_najmanjsi = function
     | Empty -> None
     | Node(Empty, x, _) -> Some x
     | Node (lt, x, rt) -> bst_najmanjsi lt
     
let rec bst_najvecji = function
     | Empty -> None
     | Node(_, x, Empty) -> Some x
     | Node(lt, x, rt) -> bst_najvecji rt

let rec succ = function
     | Empty -> None
     | Node(Empty, x, Empty) -> None
     | Node(_, _, rt) -> bst_najmanjsi rt

let rec pred = function
     | Empty -> None
     | Node(Empty, _, Empty) -> None
     | Node(lt, _, _) -> bst_najvecji lt
(*----------------------------------------------------------------------------*]
 Na predavanjih ste omenili dva načina brisanja elementov iz drevesa. Prvi 
 uporablja [succ], drugi pa [pred]. Funkcija [delete x bst] iz drevesa [bst] 
 izbriše element [x], če ta v drevesu obstaja. Za vajo lahko implementirate
 oba načina brisanja elementov.
 - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
 # (*<< Za [delete] definiran s funkcijo [succ]. >>*)
 # delete 7 test_tree;;
 - : int tree =
 Node (Node (Node (Empty, 0, Empty), 2, Empty), 5,
 Node (Node (Empty, 6, Empty), 11, Empty))
[*----------------------------------------------------------------------------*)


let integerize = function
     | Some x -> x

let drugo_drevo = Node(test_tree, 20 , Node(Node(Empty, 23, Empty), 25, Node(Empty, 77, Empty)))

let rec delete x bst =
     match x, bst with
     | x, _ when (member x bst) = false -> bst
     | x, Node(lt, y, rt) when  x > y -> Node(lt, y, (delete x rt))
     | x, Node(lt, y, rt) when  x < y -> Node((delete x lt), y, rt)
     | x, Node(Empty, y, Empty) when x = y -> Empty
     | x, Node(Empty, y, rt) when x = y -> rt
     | x, Node(lt, y, Empty) when x = y -> lt
     | x, Node(lt, y, rt) when x = y -> Node(lt, (integerize (bst_najmanjsi rt)), (delete (integerize (bst_najmanjsi rt)) rt))

(*
let rec delete x tree =
     match tree with
     | Empty -> Empty
     | Node(Empty, y, Empty) when x = y -> Empty
     | Node(Empty, y, rt) when x = y -> rt
     | Node(lt, y, Empty) when x = y -> lt
     | Node(lt, y, rt) when x <> y -> 
          if x > y then
               Node(lt, y, delete x rt)
          else
               Node(delete x lt, y, rt)
     | Node(lt, y, rt) ->
          match succ tree with
          | None -> failwith "HOW IS THIS POSSIBLE!??"
          | Some z -> Node(lt, z, delete z rt)
*)
(*-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*]
 SLOVARJI

 S pomočjo BST lahko (zadovoljivo) učinkovito definiramo slovarje. V praksi se
 slovarje definira s pomočjo hash tabel, ki so še učinkovitejše. V nadaljevanju
 pa predpostavimo, da so naši slovarji [dict] binarna iskalna drevesa, ki v
 vsakem vozlišču hranijo tako ključ kot tudi pripadajočo vrednost, in imajo BST
 strukturo glede na ključe. Ker slovar potrebuje parameter za tip ključa in tip
 vrednosti, ga parametriziramo kot [('key, 'value) dict].
[*-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*)


(*----------------------------------------------------------------------------*]
 Napišite testni primer [test_dict]:
      "b":1
      /    \
  "a":0  "d":2
         /
     "c":-2
[*----------------------------------------------------------------------------*)
let test_dict = Node(Node(Empty, ("a", 0), Empty), ("b", 1), Node(Node(Empty, ("c", -2), Empty), ("d", 2), Empty))

(*----------------------------------------------------------------------------*]
 Funkcija [dict_get key dict] v slovarju poišče vrednost z ključem [key]. Ker
 slovar vrednosti morda ne vsebuje, vrne [option] tip.
 - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
 # dict_get "banana" test_dict;;
 - : 'a option = None
 # dict_get "c" test_dict;;
 - : int option = Some (-2)
[*----------------------------------------------------------------------------*)

let rec dict_member key dict_tree = 
     match key, dict_tree with 
     | _, Empty -> false
     | k, Node(lt, (c, d), rt) when k == c -> true
     | k, Node(lt, (c, d), rt) when k < c -> dict_member key lt
     | k, Node(lt, (c, d), rt) when k > c -> dict_member key rt
     | _, Node(_, _, _) -> false (* Dodal, da se program ne bi jezil, da funkcija ni dovolj izčrpna. *) 

let rec dict_get key dict_tree =
     match dict_tree with
     | Empty -> None
     | Node(_, _, _) when (dict_member key dict_tree) = false -> None
     | Node(lt, (y, z), rt) when key = y -> z
     | Node(lt, (y, z), rt) when key > y -> dict_get key rt
     | Node(lt, (y, z), rt) when key < y -> dict_get key lt

(*----------------------------------------------------------------------------*]
 Funkcija [print_dict] sprejme slovar s ključi tipa [string] in vrednostmi tipa
 [int] in v pravilnem vrstnem redu izpiše vrstice "ključ : vrednost" za vsa
 vozlišča slovarja.
 Namig: Uporabite funkciji [print_string] in [print_int]. Nize združujemo z
 operatorjem [^]. V tipu funkcije si oglejte, kako uporaba teh funkcij določi
 parametra za tip ključev in vrednosti v primerjavi s tipom [dict_get].
 - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
 # print_dict test_dict;;
 a : 0
 b : 1
 c : -2
 d : 2
 - : unit = ()
[*----------------------------------------------------------------------------*)


(*----------------------------------------------------------------------------*]
 Funkcija [dict_insert key value dict] v slovar [dict] pod ključ [key] vstavi
 vrednost [value]. Če za nek ključ vrednost že obstaja, jo zamenja.
 - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
 # dict_insert "1" 14 test_dict |> print_dict;;
 1 : 14
 a : 0
 b : 1
 c : -2
 d : 2
 - : unit = ()
 # dict_insert "c" 14 test_dict |> print_dict;;
 a : 0
 b : 1
 c : 14
 d : 2
 - : unit = ()
[*----------------------------------------------------------------------------*)