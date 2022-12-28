(** {1 Next String} *)

include module type of String

val split_on_char_n : int -> char -> string -> string list
(** [split_on_char_n n c s] splits [s] into [n] chunks separated by the
   character [c]. If there are more occurrences of [c] in [s], they are all
   contained in the last chunk. If there are less occurrences of [c] in [s],
   this raises [Failure _]. If [n] is zero or negative, this raises
   [Invalid_argument _]. *)
