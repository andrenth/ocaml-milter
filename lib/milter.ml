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

let _ = Callback.register_exception "Milter.Milter_error" (Milter_error "")

external opensocket : bool -> unit = "caml_milter_opensocket"

external milter_register : descriptor -> unit = "caml_milter_register"

let maybe f = function
  | None -> ()
  | Some x -> f x

let register descr =
  maybe (Callback.register "milter_connect") descr.connect;
  maybe (Callback.register "milter_helo") descr.helo;
  maybe (Callback.register "milter_envfrom") descr.envfrom;
  maybe (Callback.register "milter_envrcpt") descr.envrcpt;
  maybe (Callback.register "milter_header") descr.header;
  maybe (Callback.register "milter_eoh") descr.eoh;
  maybe (Callback.register "milter_body") descr.body;
  maybe (Callback.register "milter_eom") descr.eom;
  maybe (Callback.register "milter_abort") descr.abort;
  maybe (Callback.register "milter_close") descr.close;
  maybe (Callback.register "milter_unknown") descr.unknown;
  maybe (Callback.register "milter_data") descr.data;
  maybe (Callback.register "milter_negotiate") descr.negotiate;
  milter_register descr

external setconn : string -> unit = "caml_milter_setconn"
external settimeout : int -> unit = "caml_milter_settimeout"
external setbacklog : int -> unit = "caml_milter_setbacklog"
external setdbg : int -> unit = "caml_milter_setdbg"
external stop : unit -> unit = "caml_milter_stop"
external main : unit -> unit = "caml_milter_main"

external getsymval : context -> string -> string option =
  "caml_milter_getsymval"
external getpriv : context -> 'a option =
  "caml_milter_getpriv"
external setpriv : context -> 'a -> unit =
  "caml_milter_setpriv"
external setreply : context -> string -> string option -> string option
                -> unit = "caml_milter_setreply"
external setmlreply : context -> string -> string option -> string list
                   -> unit = "caml_milter_setmlreply"

external addheader : context -> string -> string -> unit =
  "caml_milter_addheader"
external chgheader : context -> string -> int -> string -> unit =
  "caml_milter_chgheader"
external insheader : context -> int -> string -> string -> unit =
  "caml_milter_insheader"
external chgfrom : context -> string -> string -> unit =
  "caml_milter_chgfrom"
external addrcpt : context -> string -> unit =
  "caml_milter_addrcpt"
external addrcpt_par : context -> string -> string -> unit =
  "caml_milter_addrcpt_par"
external delrcpt : context -> string -> unit =
  "caml_milter_delrcpt"
external replacebody : context -> bytes -> unit =
  "caml_milter_replacebody"
external progress : context -> unit =
  "caml_milter_progress"
external quarantine : context -> string -> unit =
  "caml_milter_quarantine"
external version : unit -> int * int * int =
  "caml_milter_version"
external setsymlist : context -> stage -> string -> unit =
  "caml_milter_setsymlist"

external milter_version_code : unit -> int = "caml_milter_version_code"

let version_code =
  milter_version_code ()
