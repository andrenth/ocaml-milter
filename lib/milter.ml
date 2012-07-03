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

external opensocket : bool -> unit = "caml_milter_opensocket"

external milter_register : descriptor -> unit = "caml_milter_register"

let register descr =
  Callback.register "milter_connect" descr.connect;
  Callback.register "milter_helo" descr.helo;
  Callback.register "milter_envfrom" descr.envfrom;
  Callback.register "milter_envrcpt" descr.envrcpt;
  Callback.register "milter_header" descr.header;
  Callback.register "milter_eoh" descr.eoh;
  Callback.register "milter_body" descr.body;
  Callback.register "milter_eom" descr.eom;
  Callback.register "milter_abort" descr.abort;
  Callback.register "milter_close" descr.close;
  Callback.register "milter_unknown" descr.unknown;
  Callback.register "milter_data" descr.data;
  Callback.register "milter_negotiate" descr.negotiate;
  milter_register descr

external setconn : string -> unit = "caml_milter_setconn"
external settimeout : int -> unit = "caml_milter_settimeout"
external setbacklog : int -> unit = "caml_milter_setbacklog"
external setdbg : int -> unit = "caml_milter_setdbg"
external stop : unit -> unit = "caml_milter_stop"
external main : unit -> unit = "caml_milter_stop"

external getsymval : context -> string -> string = "caml_milter_getsymval"
external getpriv : context -> 'a option = "caml_milter_getpriv"
external setpriv : context -> 'a -> unit = "caml_milter_setpriv"
external setreply : context -> string -> string option -> string option
                -> unit = "caml_milter_setpriv"
external setreply : context -> string -> string option -> string list
                -> unit = "caml_milter_setpriv"

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
