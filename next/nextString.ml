include String

let split_on_char_n n char s =
  let rec split_on_char_n acc n ~from_ =
    if n <= 0 then List.rev (sub s from_ (length s - from_) :: acc)
    else
      match index_from_opt s from_ char with
      | None -> failwith "ExtString.split_on_char_n"
      | Some i -> split_on_char_n (sub s from_ (i - from_) :: acc) (n - 1) ~from_:(i + 1)
  in
  if n <= 0 then invalid_arg "ExtString.split_on_char_n"
  else split_on_char_n [] (n - 1) ~from_:0

let%test_module _ = (module struct
  let s = "foo bar baz"

  let%test _ = split_on_char_n 1 ' ' s = ["foo bar baz"]
  let%test _ = split_on_char_n 2 ' ' s = ["foo"; "bar baz"]
  let%test _ = split_on_char_n 3 ' ' s = ["foo"; "bar"; "baz"]

  let%test _ =
    try ignore (split_on_char_n 0 ' ' s); false
    with Invalid_argument _ -> true

  let%test _ =
    try ignore (split_on_char_n 4 ' ' s); false
    with Failure _ -> true

  let%test _ = split_on_char_n 2 ' ' " foo " = [""; "foo "]
  let%test _ = split_on_char_n 3 ' ' " foo " = [""; "foo"; ""]
end)
