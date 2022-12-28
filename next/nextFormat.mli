(** {1 Next Format} *)

include module type of Format

val pp_multiline_sensible : formatter -> string -> unit
(** Prints the string after removing initial and final spaces, and by replacing
   [\n] with [@\n]. *)
