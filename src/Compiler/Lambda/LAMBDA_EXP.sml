(*$LAMBDA_EXP*)
signature LAMBDA_EXP =
  sig

    (* The lambda language is typed and functions are allowed to
     * accept and return multiple arguments. This is done by allowing
     * two kinds of records: boxed and unboxed. Unboxed records are
     * supposed to be represented in registers.
     *
     * Value and exceptions constructors are supposed to be
     * distinct. This must be ensured by the compiler.
     *
     * The language is supposed to be used as follows: First, the
     * high-level abstract syntax tree of the compiler is translated
     * into this language. Second, simple optimizations are performed
     * (OptLambda, e.g.). Finally, boxing analysis is performed as a
     * source-to-source transformation on the language. -- martin *)


    type lvar
    type con
    type excon
    type TyName

    eqtype tyvar 
    val fresh_tyvar : unit -> tyvar
    val fresh_eqtyvar : unit -> tyvar
    val pr_tyvar : tyvar -> string
    val lt_tyvar : tyvar * tyvar -> bool
    val equality_tyvar : tyvar -> bool
    val reset : unit -> unit
    val commit : unit -> unit

    datatype Type =
        TYVARtype   of tyvar
      | ARROWtype   of Type list * Type list
      | CONStype    of Type list * TyName
      | RECORDtype  of Type list

    val boolType: Type
    val unitType: Type
    val exnType : Type
    val intType : Type
    val realType: Type
    val stringType: Type

    datatype TypeList =                               (* To allow the result of a declaration *)  
        Types of Type list                            (* to be a raised Bind exception. *)
      | Frame of {declared_lvars: {lvar : lvar, tyvars: tyvar list, Type: Type} list,
		  declared_excons: (excon * Type Option) list}
      | RaisedExnBind


    datatype 'Type prim =                             (* The primitives are always fully applied ! *)
        CONprim of {con : con, instances : 'Type list}
      | DECONprim of {con : con, instances : 'Type list}
      | EXCONprim of excon
      | DEEXCONprim of excon
      | RECORDprim 
      | SELECTprim of int        
      | UB_RECORDprim                                 (* Unboxed record. *)
      | NOTprim                                       (* Pervasives, Definition p. 75. *)
      | NEG_INTprim 
      | NEG_REALprim
      | ABS_INTprim
      | ABS_REALprim
      | FLOORprim
      | REALprim
      | SQRTprim
      | SINprim
      | COSprim
      | ARCTANprim
      | EXPprim
      | LNprim
      | SIZEprim
      | CHRprim
      | EXPLODEprim
      | IMPLODEprim
      | DEREFprim of {instance: 'Type}
      | REFprim of {instance: 'Type}
      | ASSIGNprim of {instance: 'Type}
      | DIV_REALprim                
      | DIV_INTprim
      | MODprim
      | MUL_REALprim
      | MUL_INTprim
      | PLUS_REALprim
      | PLUS_INTprim
      | MINUS_REALprim
      | MINUS_INTprim
      | STRING_CONCATprim
      | EQUALprim of {instance: 'Type}
      | NOTEQUALprim of {instance: 'Type}
      | LESS_REALprim
      | LESS_INTprim
      | GREATER_REALprim
      | GREATER_INTprim
      | LESSEQ_REALprim
      | LESSEQ_INTprim
      | GREATEREQ_REALprim
      | GREATEREQ_INTprim
      | OPEN_INprim                                   (* I/O *)
      | OPEN_OUTprim
      | INPUTprim
      | LOOKAHEADprim
      | CLOSE_INprim
      | END_OF_STREAMprim
      | OUTPUTprim
      | CLOSE_OUTprim
      | USEprim                                       (* NOT Standard ML *)
      | FLUSH_OUTprim                                 (* NOT Standard ML *)
      | STD_INprim
      | STD_OUTprim
      | CCALLprim of string * {instance : 'Type}      (* NOT Standard ML *)
      | RESET_REGIONSprim of {instance: 'Type}        (* NOT Standard ML, for programmer-directed, but safe, resetting of
						       * regions *)
      | FORCE_RESET_REGIONSprim of {instance: 'Type}  (* NOT Standard ML, for programmer-controlled, unsafe resetting of
						       * regions *)

    datatype LambdaPgm = PGM of datbinds * LambdaExp

    and datbinds = DATBINDS of (tyvar list * TyName * (con * Type Option) list) list list
      (* list of mutual recursive datatype declarations *)

    and LambdaExp =
        VAR      of {lvar: lvar, instances : Type list}
      | INTEGER  of int			
      | STRING   of string
      | REAL     of real
      | FN       of {pat : (lvar * Type) list, body : LambdaExp}
      | LET      of {pat : (lvar * tyvar list * Type) list,
		     bind : LambdaExp,
		     scope: LambdaExp}
      | FIX      of {functions : {lvar : lvar, 
				  tyvars : tyvar list,
				  Type : Type,
				  bind : LambdaExp} list,
		     scope : LambdaExp}
      | APP      of LambdaExp * LambdaExp
      | EXCEPTION of excon * Type Option * LambdaExp
      | RAISE    of LambdaExp * TypeList
      | HANDLE   of LambdaExp * LambdaExp
      | SWITCH_I of int Switch
      | SWITCH_S of string Switch
      | SWITCH_C of con Switch
      | SWITCH_E of excon Switch
      | PRIM     of Type prim * LambdaExp list
      | FRAME    of {declared_lvars: {lvar : lvar, tyvars: tyvar list, Type: Type} list,
                     declared_excons: (excon * Type Option) list}
                       (* a frame is the result of a structure-level
                        * declaration. 
			*)

    and 'a Switch = SWITCH of LambdaExp * ('a * LambdaExp) list * LambdaExp Option

    val size: LambdaExp -> int
    val size_incl_types: LambdaExp -> int

    type StringTree
    val layoutLambdaPgm: LambdaPgm -> StringTree
    val layoutLambdaExp: LambdaExp -> StringTree
    val layoutType     : Type -> StringTree
    val layoutTypeList : TypeList -> StringTree
    val layoutPrim     : ('Type -> StringTree) -> 'Type prim -> StringTree
  end
