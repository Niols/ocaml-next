(lang dune 2.8)

(generate_opam_files true)

(authors "Nicolas “Niols” Jeannerod")
(maintainers "Nicolas “Niols” Jeannerod <niols@niols.fr>")

(source (github niols/ocaml-next))

(package
 (name next)
 (synopsis "Niols's Extended Standard Library (yet another one)")
 (depends
  (ppx_inline_test (or :build :with-test))))
