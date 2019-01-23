(* ========== Vaja 3: Definicije Tipov  ========== *)

(*-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*]
 Pri modeliranju denarja ponavadi uporabljamo racionalna števila. Problemi se
 pojavijo, ko uvedemo različne valute.
 Oglejmo si dva pristopa k izboljšavi varnosti pri uporabi valut.
[*-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*)

(*----------------------------------------------------------------------------*]
 Definirajte tipa [euro] in [dollar], kjer ima vsak od tipov zgolj en
 konstruktor, ki sprejme racionalno število.
 Nato napišite funkciji [euro_to_dollar] in [dollar_to_euro], ki primerno
 pretvarjata valuti (točne vrednosti pridobite na internetu ali pa si jih
 izmislite).

 Namig: Občudujte informativnost tipov funkcij.
 - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
 # dollar_to_euro;;
 - : dollar -> euro = <fun>
 # dollar_to_euro (Dollar 0.5);;
 - : euro = Euro 0.4305
[*----------------------------------------------------------------------------*)
type euro = Euro of float

type dollar = Dollar of float

let dollar_to_euro = function
       | Dollar y -> Dollar (y *. 0.861)

let euro_to_dollar = function
       | Euro x -> Euro (x *. 1.161)


(*----------------------------------------------------------------------------*]
 Definirajte tip [currency] kot en vsotni tip z konstruktorji za jen, funt
 in švedsko krono. Nato napišite funkcijo [to_pound], ki primerno pretvori
 valuto tipa [currency] v funte.

 Namig: V tip dodajte še švicarske franke in se navdušite nad dejstvom, da vas
        Ocaml sam opozori, da je potrebno popraviti funkcijo [to_pound].
 - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
 # to_pound (Yen 1.);;
 Prej je bilo :  # to_pound (Yen 100.);;, kar pa vrne 0.7, saj je 1 Yen = 0.007 Pound sterling (GBP)
 - : currency = Pound 0.007
[*----------------------------------------------------------------------------*)
type currency =
       | Yen of float
       | Pound of float
       | Krona of float
       | Frank of float

let to_pound = function
       | Krona x -> Pound (x *. 0.085)
       | Pound x -> Pound x
       | Yen x -> Pound (x *. 0.007)
       | Frank x -> Pound (x *. 0.77)

(*-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*]
 Želimo uporabljati sezname, ki hranijo tako cela števila kot tudi logične
 vrednosti. To bi lahko rešili tako da uvedemo nov tip, ki predstavlja celo
 število ali logično vrednost, v nadaljevanju pa bomo raje konstruirali nov tip
 seznamov.

 Spomnimo se, da lahko tip [list] predstavimo s konstruktorjem za prazen seznam
 [Nil] (oz. [] v Ocamlu) in pa konstruktorjem za člen [Cons(x, xs)] (oz.
 x :: xs v Ocamlu).
[*-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*)

(*----------------------------------------------------------------------------*]
 Definirajte tip [intbool_list] z konstruktorji za:
  1.) prazen seznam,
  2.) člen z celoštevilsko vrednostjo,
  3.) člen z logično vrednostjo.

 Nato napišite testni primer, ki bi predstavljal "[5; true; false; 7]".
[*----------------------------------------------------------------------------*)
type intbool_list =
       | Empty
       | Intbool_list of int * intbool_list
       | Boolint_list of bool * intbool_list

let testni_primer = Intbool_list(5, Boolint_list(true, Boolint_list(false, Intbool_list(7, Empty))))
(*----------------------------------------------------------------------------*]
 Funkcija [intbool_map f_int f_bool ib_list] preslika vrednosti [ib_list] v nov
 [intbool_list] seznam, kjer na elementih uporabi primerno od funkcij [f_int]
 oz. [f_bool].
[*----------------------------------------------------------------------------*)

let rec intbool_map f_int f_bool ib_list = 
       match ib_list with
       | Empty -> Empty
       | Intbool_list (y, intboole_list') -> Intbool_list ((f_int y), intbool_map f_int f_bool intboole_list')
       | Boolint_list (boole, intboole_list') -> Boolint_list ((f_bool boole), intbool_map f_int f_bool intboole_list')

(*----------------------------------------------------------------------------*]
 Funkcija [intbool_reverse] obrne vrstni red elementov [intbool_list] seznama.
 Funkcija je repno rekurzivna.
[*----------------------------------------------------------------------------*)

let intbool_reverse intbool_list = 
       let rec intbool_reverse' intbool_list acc =
              match intbool_list with
              | Empty -> acc
              | Intbool_list (y, intbool_list') -> intbool_reverse' intbool_list' (Intbool_list (y, acc))
              | Boolint_list (boole, intbool_list') -> intbool_reverse' intbool_list' (Boolint_list (boole, acc))
       in intbool_reverse' intbool_list Empty

(*----------------------------------------------------------------------------*]
 Funkcija [intbool_separate ib_list] loči vrednosti [ib_list] v par [list]
 seznamov, kjer prvi vsebuje vse celoštevilske vrednosti, drugi pa vse logične
 vrednosti. Funkcija je repno rekurzivna in ohranja vrstni red elementov.
[*----------------------------------------------------------------------------*)
let rec list_reverse acc seznam = 
  match seznam with
  | [] -> acc
  | x :: [] -> x :: acc
  | x :: xs -> list_reverse (x :: acc) xs 

let intbool_separate ib_list =
       let rec intbool_separate' ib_list int_acc bool_acc =
              match ib_list with
              | Empty -> (int_acc, bool_acc)
              | Intbool_list (y, ib_list') -> intbool_separate' ib_list' (y :: int_acc) bool_acc
              | Boolint_list (boole, ib_list') -> intbool_separate' ib_list' int_acc (boole :: bool_acc)
       in intbool_separate' ib_list [] []


(*-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*]
 Določeni ste bili za vzdrževalca baze podatkov za svetovno priznano čarodejsko
 akademijo "Effemef". Vaša naloga je konstruirati sistem, ki bo omogočil
 pregledno hranjenje podatkov.
[*-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*)

(*----------------------------------------------------------------------------*]
 Čarodeje razvrščamo glede na vrsto magije, ki se ji posvečajo. Definirajte tip
 [magic], ki loči med magijo ognja, magijo ledu in magijo arkane oz. fire,
 frost in arcane.

 Ko se čarodej zaposli na akademiji, se usmeri v zgodovino, poučevanje ali
 raziskovanje oz. historian, teacher in researcher. Definirajte tip
 [specialisation], ki loči med temi zaposlitvami.
[*----------------------------------------------------------------------------*)
type magic =
       | Fire 
       | Frost
       | Arcane

type specialisation =
       | Historian
       | Teacher
       | Researcher


(*----------------------------------------------------------------------------*]
 Vsak od čarodejev začne kot začetnik, nato na neki točki postane študent,
 na koncu pa SE lahko tudi zaposli.
 Definirajte tip [status], ki določa ali je čarodej:
  a.) začetnik [Newbie],
  b.) študent [Student] (in kateri vrsti magije pripada in koliko časa študira),
  c.) zaposlen [Employed] (in vrsto magije in specializacijo).

 Nato definirajte zapisni tip [wizard] z poljem za ime in poljem za trenuten
 status.
 - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
 # professor;;
 - : wizard = {name = "Matija"; status = Employed (Fire, Teacher)}
[*----------------------------------------------------------------------------*)
type status =
       | Newbie
       | Student of magic * int 
       | Employed of magic * specialisation

type wizard = {name : string ; status : status}

let professor = {name = "Matija"; status = Employed (Fire, Teacher)}

(*----------------------------------------------------------------------------*]
 Želimo prešteti koliko uporabnikov posamezne od vrst magije imamo na akademiji.
 Definirajte zapisni tip [magic_counter], ki v posameznem polju hrani število
 uporabnikov magije.
 Nato definirajte funkcijo [update counter magic], ki vrne nov števec s
 posodobljenim poljem glede na vrednost [magic].
 - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
 # update {fire = 1; frost = 1; arcane = 1} Arcane;;
 - : magic_counter = {fire = 1; frost = 1; arcane = 2}
[*----------------------------------------------------------------------------*)
type magic_counter = {fire : int; frost : int; arcane : int}

let update magic_counter magic =
       match magic_counter, magic with
       | {fire = x; frost = y; arcane = z}, Fire -> {fire = (x + 1); frost = y; arcane = z}
       | {fire = x; frost = y; arcane = z}, Frost -> {fire = x; frost = (y + 1); arcane = z}
       | {fire = x; frost = y; arcane = z}, Arcane -> {fire = x; frost = y; arcane = (z + 1)}


(*----------------------------------------------------------------------------*]
 Funkcija [count_magic] sprejme seznam čarodejev in vrne števec uporabnikov
 različnih vrst magij.
 - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
 # count_magic [professor; professor; professor];;
 - : magic_counter = {fire = 3; frost = 0; arcane = 0}
[*----------------------------------------------------------------------------*)

let count_magic prof_list = 
       let rec count_magic' prof_list acc = 
              match prof_list with
              | [] -> acc
              | {name = str; status = Employed (magic, Teacher)} :: profs -> count_magic' profs (update acc magic)
              | {name = str; status = statuse} :: profs -> failwith "Tole pa ni profesor!"
       in count_magic' prof_list {fire = 0; frost = 0; arcane = 0}
(*----------------------------------------------------------------------------*]
 Želimo poiskati primernega kandidata za delovni razpis. Študent lahko postane
 zgodovinar po vsaj treh letih študija, raziskovalec po vsaj štirih letih
 študija in učitelj po vsaj petih letih študija.
 Funkcija [find_candidate magic specialisation wizard_list] poišče prvega
 primernega kandidata na seznamu čarodejev in vrne njegovo ime, čim ustreza
 zahtevam za [specialisation] in študira vrsto [magic]. V primeru, da ni
 primernega kandidata, funkcija vrne [None].
 - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
 # let jaina = {name = "Jaina"; status = Student (Frost, 4)};;
 # find_candidate Frost Researcher [professor; jaina];;
 - : string option = Some "Jaina"
[*----------------------------------------------------------------------------*)



let rec find_candidate magic specialisation wizard_list = 
       let zgodovinar = 3 in
       let raziskovalec = 4 in
       let ucitelj = 5 in
       match wizard_list with
       | [] -> None 
       | {name = str; status = Student (magic, yrs)} :: wizards ->
              if specialisation = Historian then
                     if yrs >= zgodovinar then
                            Some str 
                     else
                            find_candidate magic specialisation wizards
              else if specialisation = Researcher then
                     if yrs >= raziskovalec then
                            Some str 
                     else
                            find_candidate magic specialisation wizards
              else
                     if yrs >= ucitelj then
                            Some str 
                     else
                            find_candidate magic specialisation wizards
       | {name = str; status = Employed (magic, spec)} :: wizards -> find_candidate magic specialisation wizards
       | {name = str; status = Newbie} :: wizards -> find_candidate magic specialisation wizards

