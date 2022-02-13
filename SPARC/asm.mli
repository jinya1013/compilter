type id_or_imm = V of Id.t | C of int
type t =
  | Ans of exp * Syntax.pos
  | Let of (Id.t * Type.t) * exp * t * Syntax.pos
and exp =
  | Nop
  | Set of int
  | SetL of Id.l
  | Mov of Id.t
  | Neg of Id.t
  | Add of Id.t * id_or_imm
  | Sub of Id.t * id_or_imm
  | SLL of Id.t * id_or_imm
  | Ld of Id.t * int
  | St of Id.t * Id.t * int
  | FMovD of Id.t
  | FNegD of Id.t
  | FSqrtD of Id.t
  | FloorD of Id.t
  | FAddD of Id.t * Id.t
  | FSubD of Id.t * Id.t
  | FMulD of Id.t * Id.t
  | FDivD of Id.t * Id.t
  | LdDF of Id.t * int
  | StDF of Id.t * Id.t * int
  | Comment of string
  (* virtual instructions *)
  | IfEq of Id.t * id_or_imm * t * t
  | IfLE of Id.t * id_or_imm * t * t
  | IfGE of Id.t * id_or_imm * t * t
  | IfFEq of Id.t * Id.t * t * t
  | IfFLE of Id.t * Id.t * t * t
  (* closure address, integer arguments, and float arguments *)
  | CallCls of Id.t * Id.t list * Id.t list
  | CallDir of Id.l * Id.t list * Id.t list
  | Save of Id.t * Id.t (* レジスタ変数の値をスタック変数へ保存 *)
  | Restore of Id.t (* スタック変数から値を復元 *)
type fundef = { name : Id.l; args : Id.t list; fargs : Id.t list; body : t; ret : Type.t }
type prog = Prog of (int * float) list * fundef list * t

val fletd : Id.t * exp * t * Syntax.pos-> t (* shorthand of Let for float *)
val seq : exp * t * Syntax.pos -> t (* shorthand of Let for unit *)

val regs : Id.t array
val fregs : Id.t array
val allregs : Id.t list
val allfregs : Id.t list
val zero_reg : Id.t
val reg_cl : Id.t
val reg_sw : Id.t
val reg_fsw : Id.t
val reg_ra : Id.t
val reg_hp : Id.t
val reg_sp : Id.t
val reg_ftp : Id.t
val is_reg : Id.t -> bool
val fv : t -> Id.t list
val concat : t -> Id.t * Type.t -> t -> t

val align : int -> int

val pos_of_t : t -> Syntax.pos

val output_t : out_channel -> int -> t -> unit
val output_exp : out_channel -> int -> Syntax.pos -> exp -> unit
val output_func : out_channel -> int -> fundef -> unit
val output_prog : out_channel -> prog -> unit