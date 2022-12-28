(** {1 Next List} *)

include module type of List

val union_sorted : ('a -> 'a -> int) -> 'a list -> 'a list -> 'a list
(** Returns the union of two sorted lists seen as sets. [union_sorted cmp l1 l2]
   is equivalent to [sort_uniq cmp (l1 @ l2)] except faster. *)

val inter_sorted : ('a -> 'a -> int) -> 'a list -> 'a list -> 'a list
(** Returns the intersection of two sorted lists seen as sets. [inter_sorted cmp
    l1 l2] is equivalent to [filter (fun x1 -> exists (fun x2 -> cmp x1 x2 = 0)
    l2) l1] except much faster. *)

val diff_sorted : ('a -> 'a -> int) -> 'a list -> 'a list -> 'a list
(** Returns the difference of two sorted lists seen as sets. [diff_sorted cmp l1
   l2] is equivalent to [filter (fun x1 -> not (exists (fun x2 -> cmp x1 x2 = 0)
   l2)) l1] except much faster. *)

val symdiff_sorted : ('a -> 'a -> int) -> 'a list -> 'a list -> 'a list
(** Returns the symmetric difference of two sorted lists seen as sets.
   [symdiff_sorted cmp l1 l2] is equivalent to [union_sorted (diff_sorted l1 l2)
   (diff_sorted l2 l1)] except faster. *)

val hdn : int -> 'a list -> 'a list
(** [hdn n l] returns the [n] first elements of [l] in a list. If [n] is bigger
   than the size of [l], returns [l]. *)

val bd : 'a list -> 'a list

val ft : 'a list -> 'a

val init_until : (int -> 'a option) -> 'a list
(** [init_until f] initialises a list by calling [f] until it returns [None]. *)

val sub : 'a list -> int -> int -> 'a list
(** [sub l pos len] is a list of length [len], containing the sublist of [l]
    that starts at position [pos] and has length [len].

    @raise Invalid_argument if [pos] and [len] do not designate a valid sublist
      of [l]. *)

val take : int -> 'a list -> 'a list
(** [take n l] returns the prefix of [l] of length [n]. It is the same as [sub l
    0 n]. For all [n] between [0] and [length l], [l = take n l @ drop n l].

    @raise Invalid_argument if [n] is negative or bigger than [length l]. *)

val drop : int -> 'a list -> 'a list
(** [drop n l] returns the suffix of [l] after the [n] first elements. It is the
    same as [sub l n (length l - n)]. For all [n] between [0] and [length l], [l
    = take n l @ drop n l].

    @raise Invalid_argument if [n] is negative or bigger than [length l]. *)

val count : ('a -> bool) -> 'a list -> int
(** Counts the number of elements in the list that respect the given predicate.
    This is the same as {!filter} followed by {!length}, but faster. *)

val singleton : 'a -> 'a list

val update_nth : int -> ('a -> 'a) -> 'a list -> 'a list

val prefix_until_inclusive : ('a -> bool) -> 'a list -> 'a list
(** Returns the prefix consisting in a bunch of elements not satisfying the
    given predicate, followed by the first elements satisfying the given
    predicate, if there is one. *)
