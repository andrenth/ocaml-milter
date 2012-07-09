type ctx

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
  = ADDHDRS
  | CHGHDRS
  | CHGBODY
  | ADDRCPT
  | ADDRCPT_PAR
  | DELRCPT
  | QUARANTINE
  | CHGFROM
  | SETSYMLIST

type stage
  = CONNECT
  | HELO
  | ENVFROM
  | ENVRCPT
  | DATA
  | EOM
  | EOH

type step
  = NOCONNECT
  | NOHELO
  | NOMAIL
  | NORCPT
  | NOBODY
  | NOHDRS
  | NOEOH
  | NR_HDR
  | NOUNKNOWN
  | NODATA
  | SKIP
  | RCPT_REJ
  | NR_CONN
  | NR_HELO
  | NR_MAIL
  | NR_RCPT
  | NR_DATA
  | NR_UNKN
  | NR_EOH
  | NR_BODY
  | HDR_LEADSPC
  | MDS_256K
  | MDS_1M

type descriptor =
  { name      : string
  ; version   : int
  ; flags     : flag list
  ; connect   : (ctx -> string option -> Unix.sockaddr option -> stat) option
  ; helo      : (ctx -> string option -> stat) option
  ; envfrom   : (ctx -> string -> string list -> stat) option
  ; envrcpt   : (ctx -> string -> string list -> stat) option
  ; header    : (ctx -> string -> string -> stat) option
  ; eoh       : (ctx -> stat) option
  ; body      : (ctx -> string -> int -> stat) option
  ; eom       : (ctx -> stat) option
  ; abort     : (ctx -> stat) option
  ; close     : (ctx -> stat) option
  ; unknown   : (ctx -> string -> stat) option
  ; data      : (ctx -> stat) option
  ; negotiate : (ctx -> flag list -> step list
                  -> stat * flag list * step list) option
  }

type bytes =
  (char, Bigarray.int8_unsigned_elt, Bigarray.c_layout) Bigarray.Array1.t

exception Milter_error of string

val opensocket : bool -> unit
val register : descriptor -> unit
val setconn : string -> unit
val settimeout : int -> unit
val setbacklog : int -> unit
val setdbg : int -> unit
val stop : unit -> unit
val main : unit -> unit

val getsymval : ctx -> string -> string option
val getpriv : ctx -> 'a option
val setpriv : ctx -> 'a -> unit
val setreply : ctx -> string -> string option -> string option -> unit
val setmlreply : ctx -> string -> string option -> string list -> unit

val addheader : ctx -> string -> string -> unit
val chgheader : ctx -> string -> int -> string -> unit
val insheader : ctx -> int -> string -> string -> unit
val chgfrom : ctx -> string -> string -> unit
val addrcpt : ctx -> string -> unit
val addrcpt_par : ctx -> string -> string -> unit
val delrcpt : ctx -> string -> unit
val replacebody : ctx -> bytes -> unit
val progress : ctx -> unit
val quarantine : ctx -> string -> unit
val version : unit -> int * int * int
val setsymlist : ctx -> stage -> string -> unit

val version_code : int
