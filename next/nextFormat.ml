include Format

let pp_multiline_sensible fmt s =
  let rec remove_empty_first_lines = function
    | [] -> []
    | "" :: lines -> remove_empty_first_lines lines
    | lines -> lines
  in
  let rec remove_empty_last_lines = function
    | [] -> []
    | "" :: lines ->
      (
        match remove_empty_last_lines lines with
        | [] -> []
        | lines -> "" :: lines
      )
    | line :: lines ->
      line :: remove_empty_last_lines lines
  in
  s
  |> String.split_on_char '\n'
  |> remove_empty_first_lines
  |> remove_empty_last_lines
  |> (function [] -> ["(empty)"] | s -> s)
  |> (function
      | [] -> assert false
      | [line] -> fprintf fmt "%s" line
      | line :: lines ->
        fprintf fmt "%s" line;
        List.iter (fprintf fmt "@\n%s") lines
    )
