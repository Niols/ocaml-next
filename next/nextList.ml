include List

let union_sorted compare l1 l2 =
  let rec union_sorted acc l1 l2 =
    match l1, l2 with
    | [], [] -> rev acc
    |  _, [] -> rev_append acc l1
    | [],  _ -> rev_append acc l2
    | h1 :: t1, h2 :: t2 ->
      let c = compare h1 h2 in
      if c < 0 then
        union_sorted (h1::acc) t1 l2
      else if c > 0 then
        union_sorted (h2::acc) l1 t2
      else
        union_sorted (h1::acc) t1 t2
  in
  union_sorted [] l1 l2

let%test_module _ = (module struct
  let union_sorted = union_sorted Int.compare

  let l1 = [1; 3; 6]
  let l2 = [1; 2; 4; 5]
  let l12 = [1; 2; 3; 4; 5; 6]

  let%test _ = union_sorted [] [] = []
  let%test _ = union_sorted l1 [] = l1
  let%test _ = union_sorted [] l1 = l1
  let%test _ = union_sorted l1 l1 = l1
  let%test _ = union_sorted l1 l2 = l12
  let%test _ = union_sorted l2 l1 = l12
end)

let inter_sorted compare l1 l2 =
  let rec inter_sorted acc l1 l2 =
    match l1, l2 with
    | _, [] | [], _ -> rev acc
    | h1 :: t1, h2 :: t2 ->
      let c = compare h1 h2 in
      if c < 0 then
        inter_sorted acc t1 l2
      else if c > 0 then
        inter_sorted acc l1 t2
      else
        inter_sorted (h1::acc) t1 t2
  in
  inter_sorted [] l1 l2

let%test_module _ = (module struct
  let f = inter_sorted Int.compare
  let l1 = [1; 3; 4; 6]
  let l2 = [1; 2; 4; 5]
  let l12 = [1; 4]

  let%test _ = f [] [] = []
  let%test _ = f l1 [] = []
  let%test _ = f [] l1 = []
  let%test _ = f l1 l1 = l1
  let%test _ = f l1 l2 = l12
  let%test _ = f l2 l1 = l12
end)

let diff_sorted compare l1 l2 =
  let rec diff_sorted acc l1 l2 =
    match l1, l2 with
    | [], _ -> rev acc
    | l1, [] -> rev_append acc l1
    | h1 :: t1, h2 :: t2 ->
      let c = compare h1 h2 in
      if c < 0 then
        diff_sorted (h1::acc) t1 l2
      else if c > 0 then
        diff_sorted acc l1 t2
      else
        diff_sorted acc t1 l2
  in
  diff_sorted [] l1 l2

let%test_module _ = (module struct
  let f = diff_sorted Int.compare
  let l1 = [1; 3; 4; 6]
  let l2 = [1; 2; 4; 5]
  let l12 = [3; 6]
  let l21 = [2; 5]

  let%test _ = f [] [] = []
  let%test _ = f l1 [] = l1
  let%test _ = f [] l1 = []
  let%test _ = f l1 l1 = []
  let%test _ = f l1 l2 = l12
  let%test _ = f l2 l1 = l21
end)

let symdiff_sorted compare l1 l2 =
  let rec symdiff_sorted acc l1 l2 =
    match l1, l2 with
    | [], l2 -> rev_append acc l2
    | l1, [] -> rev_append acc l1
    | h1 :: t1, h2 :: t2 ->
      let c = compare h1 h2 in
      if c < 0 then
        symdiff_sorted (h1::acc) t1 l2
      else if c > 0 then
        symdiff_sorted (h2::acc) l1 t2
      else
        symdiff_sorted acc t1 t2
  in
  symdiff_sorted [] l1 l2

let%test_module _ = (module struct
  let f = symdiff_sorted Int.compare
  let l1 = [1; 3; 4; 6]
  let l2 = [1; 2; 4; 5]
  let l12 = [2; 3; 5; 6]

  let%test _ = f [] [] = []
  let%test _ = f l1 [] = l1
  let%test _ = f [] l1 = l1
  let%test _ = f l1 l1 = []
  let%test _ = f l1 l2 = l12
  let%test _ = f l2 l1 = l12
end)

let%test_module _ = (module struct
  (* tests by comparing to specs *)

  let gen ~max size =
    init size (fun _ -> Random.int (max + 1))
    |> sort_uniq Int.compare

  let rec test ~repeat ~max s1 s2 f g =
    if repeat <= 0 then true
    else
      let l1 = gen ~max s1 in
      let l2 = gen ~max s2 in
      (f Int.compare l1 l2 = g Int.compare l1 l2)
      && test ~repeat:(repeat - 1) ~max s1 s2 f g

  (* union_sorted cmp l1 l2
     <=> sort_uniq cmp (l1 @ l2) *)

  let f = union_sorted
  let g cmp l1 l2 = sort_uniq cmp (l1 @ l2)

  let%test _ = test ~repeat:100 ~max:10 20 18 f g
  let%test _ = test ~repeat:100 ~max:10 18 20 f g
  let%test _ = test ~repeat:100 ~max:100 200 180 f g
  let%test _ = test ~repeat:100 ~max:100_000_000 1_800 2_000 f g

  (* inter_sorted cmp l1 l2
     <=> filter (fun x1 -> exists (fun x2 -> cmp x1 x2 = 0) l2) l1 *)

  let f = inter_sorted
  let g cmp l1 l2 = filter (fun x1 -> exists (fun x2 -> cmp x1 x2 = 0) l2) l1

  let%test _ = test ~repeat:100 ~max:10 20 18 f g
  let%test _ = test ~repeat:100 ~max:10 18 20 f g
  let%test _ = test ~repeat:100 ~max:100 200 180 f g
  let%test _ = test ~repeat:100 ~max:100_000_000 1_800 2_000 f g

  (* diff_sorted cmp l1 l2
     <=> filter (fun x1 -> not (exists (fun x2 -> cmp x1 x2 = 0) l2) l1 *)

  let f = diff_sorted
  let g cmp l1 l2 = filter (fun x1 -> not (exists (fun x2 -> cmp x1 x2 = 0) l2)) l1

  let%test _ = test ~repeat:100 ~max:10 20 18 f g
  let%test _ = test ~repeat:100 ~max:10 18 20 f g
  let%test _ = test ~repeat:100 ~max:100 200 180 f g
  let%test _ = test ~repeat:100 ~max:100_000_000 1_800 2_000 f g

  (* symdiff_sorted cmp l1 l2
     <=> union_sorted (diff_sorted l1 l2) (diff_sorted l2 l1) *)

  let f = symdiff_sorted
  let g cmp l1 l2 = union_sorted cmp (diff_sorted cmp l1 l2) (diff_sorted cmp l2 l1)

  let%test _ = test ~repeat:100 ~max:10 20 18 f g
  let%test _ = test ~repeat:100 ~max:10 18 20 f g
  let%test _ = test ~repeat:100 ~max:100 200 180 f g
  let%test _ = test ~repeat:100 ~max:100_000_000 1_800 2_000 f g
end)

let rec hdn n l =
  if n = 0 then []
  else match l with
    | [] -> []
    | h::q -> h :: hdn (n-1) q

let%test_module _ = (module struct
  let%test _ = hdn 0 [1; 2; 3; 4; 5] = []
  let%test _ = hdn 1 [1; 2; 3; 4; 5] = [1]
  let%test _ = hdn 3 [1; 2; 3; 4; 5] = [1; 2; 3]
  let%test _ = hdn 5 [1; 2; 3; 4; 5] = [1; 2; 3; 4; 5]
  let%test _ = hdn 6 [1; 2; 3; 4; 5] = [1; 2; 3; 4; 5]
end)

let rec bd = function
  | [] -> failwith "ExtList.bd"
  | [_] -> []
  | x :: l -> x :: bd l

let rec ft = function
  | [] -> failwith "ExtList.ft"
  | [e] -> e
  | _ :: l -> ft l

let init_until f =
  let rec aux i acc =
    match f i with
    | None -> acc
    | Some x -> aux (i+1) (x::acc)
  in
  rev @@ aux 0 []

let sub l pos len =
  if pos < 0 || len < 0 then
    invalid_arg "ExtList.sub";
  let rec go_to_pos i = function
    | xs when i = pos -> gather_len 0 [] xs
    | [] -> invalid_arg "ExtList.sub"
    | _::xs -> go_to_pos (i+1) xs
  and gather_len j acc = function
    | _ when j = len -> List.rev acc
    | [] -> invalid_arg "ExtList.sub"
    | x::xs -> gather_len (j+1) (x::acc) xs
  in
  go_to_pos 0 l

let take n l = sub l 0 n
let drop n l = sub l n (length l - n)

let%test_module _ = (module struct
  let%test _ = sub [1; 2; 3; 4; 5] 3 0 = []
  let%test _ = sub [1; 2; 3; 4; 5] 0 3 = [1; 2; 3]
  let%test _ = sub [1; 2; 3; 4; 5] 2 2 = [3; 4]
  let%test _ = sub [1; 2; 3; 4; 5] 1 4 = [2; 3; 4; 5]
  let%test _ = sub [1; 2; 3; 4; 5] 0 5 = [1; 2; 3; 4; 5]
end)

let count p l =
  let rec count i = function
    | [] -> i
    | x :: l -> count (if p x then i + 1 else i) l
  in
  count 0 l

let singleton x = [x]

let rec update_nth n f = function
  | [] -> failwith "ExtRead.update_nth"
  | x::xs when n=0 -> f x :: xs
  | x::xs -> x :: update_nth (n-1) f xs

let rec prefix_until_inclusive p = function
  | [] -> []
  | x :: _ when p x -> [x]
  | x :: xs -> x :: prefix_until_inclusive p xs
