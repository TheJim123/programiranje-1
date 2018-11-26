(* -------- 1 -------- *)
let rec vsota_seznama list =
  let rec vsota' acc list =
    match list with
    | [] -> acc
    | x :: xs -> vsota' (x + acc) xs
  in vsota' 0 list

(* -------- 2 -------- *)

let rec je_urejen = function
  | [] -> true
  | x :: [] -> true
  | x :: y :: [] -> x <= y
  | x :: (y :: xs) -> je_urejen (x :: y :: []) && je_urejen (y :: xs)   

(* -------- 3 -------- *)
(* Predpostavljam, da je vsak vstavljeni seznam že urejen *)

let rec vstavi k list =
  let rec vstavi_aux acc k list =
    match k, list with
    | k, [] -> acc @ (k :: [])
    | k, (x :: xs) when k <= x -> acc @ (k :: x :: xs)
    | k, (x :: xs) when k > x -> vstavi_aux (acc @ (x :: [])) k xs 
  in vstavi_aux [] k list

let rec uredi list =
    let rec uredi' acc list =
      match list with
      | [] -> acc
      | x :: [] -> (x :: acc)
      | x :: xs -> uredi' (vstavi x acc) xs
    in uredi' [] list

(* -------- 4 -------- *)
let rec novi_vstavi k list cmp =
  let rec novi_vstavi_aux acc k list cmp =
    match k, list with
    | k, [] -> acc @ (k :: [])
    | k, (x :: xs) when (cmp k x) -> acc @ (k :: x :: xs)
    | k, (x :: xs) when (cmp x k) -> novi_vstavi_aux (acc @ (x :: [])) k xs 
  in novi_vstavi_aux [] k list

  let rec novi_uredi list cmp =
    let rec novi_uredi' acc list cmp =
      match list with
      | [] -> acc
      | x :: [] -> (x :: acc)
      | x :: xs -> novi_uredi' (novi_vstavi x acc cmp) xs cmp
    in novi_uredi' [] list cmp

(* -------- 5 -------- *)

(* type flyer = { status : status ; name : string }

let flyers = [ {status = Staff; name = "Quinn"}
             ; {status = Passenger (Group 0); name = "Xiao"}
             ; {status = Passenger Top; name = "Jaina"}
             ; {status = Passenger (Group 1000); name = "Aleks"}
             ; {status = Passenger (Group 1000); name = "Robin"}
             ; {status = Staff; name = "Alan"}
             ]

*)


(* -------- 6 -------- *)


(* -------- 7 -------- *)

