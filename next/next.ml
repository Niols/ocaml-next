module Format = NextFormat
module List = NextList
module String = NextString

module GRead = NextGRead
module GWrite = NextGWrite

let pf = Format.printf
let epf = Format.eprintf
let fpf = Format.fprintf
let spf = Format.sprintf

let soi = string_of_int
let ios = int_of_string
let foi = float_of_int
let iof = int_of_float

let (||>) f g x = f x |> g

let curry f = fun a b -> f (a, b)
let uncurry f = fun (a, b) -> f a b

let flip f x y = f y x
