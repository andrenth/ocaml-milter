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
  ; connect   : (context -> string -> Unix.sockaddr -> stat) option
  ; helo      : (context -> string option -> stat) option
  ; envfrom   : (context -> string -> string list -> stat) option
  ; envrcpt   : (context -> string -> string list -> stat) option
  ; header    : (context -> string -> string -> stat) option
  ; eoh       : (context -> stat) option
  ; body      : (context -> string -> int -> stat) option
  ; eom       : (context -> stat) option
  ; abort     : (context -> stat) option
  ; close     : (context -> stat) option
  ; unknown   : (context -> string -> stat) option
  ; data      : (context -> stat) option
  ; negotiate : (context -> flag list -> step list
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

val getsymval : context -> string -> string option
val getpriv : context -> 'a option
val setpriv : context -> 'a -> unit
val setreply : context -> string -> string option -> string option -> unit
val setmlreply : context -> string -> string option -> string list -> unit

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

val version_code : int
