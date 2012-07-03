type context

type stat
  = Continue
  | Reject
  | Discard
  | Accept
  | Tempfail
  | No_reply
  | Skip
  | All

type flag
  = ADDHRDS
  | CHGHDRS
  | CHGBODY
  | ADDRCPT
  | ADDRCPT_PAR
  | DELRCPT
  | QUARANTINE
  | CHGFROM
  | SETSYMLIST

type stage
  = FIRST
  | CONNECT
  | HELO
  | ENVFROM
  | ENVRCPT
  | DATA
  | EOM
  | EOH

type descriptor =
  { name      : string
  ; version   : int
  ; flags     : flag list
  ; connect   : (context -> string -> Unix.sockaddr -> stat)
  ; helo      : (context -> string -> stat)
  ; envfrom   : (context -> string list -> stat)
  ; envrcpt   : (context -> string list -> stat)
  ; header    : (context -> string -> string -> stat)
  ; eoh       : (context -> stat)
  ; body      : (context -> string -> int -> stat)
  ; eom       : (context -> stat)
  ; abort     : (context -> stat)
  ; close     : (context -> stat)
  ; unknown   : (context -> string -> stat)
  ; data      : (context -> stat)
  ; negotiate : (context -> int -> int -> int -> int
                  -> stat * int * int * int * int)
  }

type bytes =
  (char, Bigarray.int8_unsigned_elt, Bigarray.c_layout) Bigarray.Array1.t

val opensocket : bool -> unit
val register : descriptor -> unit
val setconn : string -> unit
val settimeout : int -> unit
val setbacklog : int -> unit
val setdbg : int -> unit
val stop : unit -> unit
val main : unit -> unit

val getsymval : context -> string -> string
val getpriv : context -> 'a option
val setpriv : context -> 'a -> unit
val setreply : context -> string -> string option -> string option -> unit
val setreply : context -> string -> string option -> string list -> unit

val addheader : context -> string -> string -> unit
val chgheader : context -> string -> int -> string -> unit
val insheader : context -> int -> string -> string -> unit
val chgfrom : context -> string -> string -> unit
val addrcpt : context -> string -> unit
val addrcpt_par : context -> string -> string -> unit
val delrcpt : context -> string -> unit
val replacebody : context -> bytes -> unit
val progress : context -> unit
val quarantine : context -> string -> unit
val version : unit -> int * int * int
val setsymlist : context -> stage -> string -> unit
