#ifndef ABSYN_HEADER
#define ABSYN_HEADER

/* C++ Abstract Syntax Interface generated by the BNF Converter.*/

/********************   TypeDef Section    ********************/
typedef int Integer;
typedef char Char;
typedef double Double;
typedef char* String;
typedef char* Ident;
typedef char* Id;


/********************   Forward Declarations    ********************/

struct ListDef_;
typedef struct ListDef_ *ListDef;
struct ListArg_;
typedef struct ListArg_ *ListArg;
struct ListStm_;
typedef struct ListStm_ *ListStm;
struct ListSwitchCase_;
typedef struct ListSwitchCase_ *ListSwitchCase;
struct ListExp_;
typedef struct ListExp_ *ListExp;
struct ListType_;
typedef struct ListType_ *ListType;
struct Program_;
typedef struct Program_ *Program;
struct Def_;
typedef struct Def_ *Def;
struct Arg_;
typedef struct Arg_ *Arg;
struct Stm_;
typedef struct Stm_ *Stm;
struct IdMaybeTyped_;
typedef struct IdMaybeTyped_ *IdMaybeTyped;
struct IfCond_;
typedef struct IfCond_ *IfCond;
struct SwitchCase_;
typedef struct SwitchCase_ *SwitchCase;
struct Else_;
typedef struct Else_ *Else;
struct Case_;
typedef struct Case_ *Case;
struct Exp_;
typedef struct Exp_ *Exp;
struct Assertion_;
typedef struct Assertion_ *Assertion;
struct Type_;
typedef struct Type_ *Type;
struct CoreType_;
typedef struct CoreType_ *CoreType;
struct Generics_;
typedef struct Generics_ *Generics;
struct BaseType_;
typedef struct BaseType_ *BaseType;


/********************   Abstract Syntax Classes    ********************/

struct Program_
{
  enum { is_ProgramDefs } kind;
  union
  {
    struct { ListDef listdef_; } programdefs_;
  } u;
};

Program make_ProgramDefs(ListDef p0);

struct ListDef_
{
  Def def_;
  ListDef listdef_;
};

ListDef make_ListDef(Def p1, ListDef p2);
struct Def_
{
  enum { is_DefFun, is_DefFunExposed, is_DefTypedef } kind;
  union
  {
    struct { Id id_; ListArg listarg_; ListStm liststm_; Type type_; } deffun_;
    struct { Id id_; ListArg listarg_; ListStm liststm_; Type type_; } deffunexposed_;
    struct { Ident ident_; Type type_1, type_2; } deftypedef_;
  } u;
};

Def make_DefFun(Id p0, ListArg p1, Type p2, ListStm p3);
Def make_DefFunExposed(Id p0, ListArg p1, Type p2, ListStm p3);
Def make_DefTypedef(Ident p0, Type p1, Type p2);

struct ListArg_
{
  Arg arg_;
  ListArg listarg_;
};

ListArg make_ListArg(Arg p1, ListArg p2);
struct ListStm_
{
  Stm stm_;
  ListStm liststm_;
};

ListStm make_ListStm(Stm p1, ListStm p2);
struct Arg_
{
  enum { is_ArgDecl } kind;
  union
  {
    struct { Id id_; Type type_; } argdecl_;
  } u;
};

Arg make_ArgDecl(Id p0, Type p1);

struct Stm_
{
  enum { is_StmInit, is_StmSplit, is_StmIfElse, is_StmSwitch, is_StmReturn, is_StmAssert } kind;
  union
  {
    struct { Exp exp_; IdMaybeTyped idmaybetyped_; } stminit_;
    struct { Exp exp_; IdMaybeTyped idmaybetyped_1, idmaybetyped_2; } stmsplit_;
    struct { Else else_; IfCond ifcond_; ListStm liststm_; } stmifelse_;
    struct { Exp exp_; ListSwitchCase listswitchcase_; } stmswitch_;
    struct { Exp exp_; } stmreturn_;
    struct { Assertion assertion_; } stmassert_;
  } u;
};

Stm make_StmInit(IdMaybeTyped p0, Exp p1);
Stm make_StmSplit(IdMaybeTyped p0, IdMaybeTyped p1, Exp p2);
Stm make_StmIfElse(IfCond p0, ListStm p1, Else p2);
Stm make_StmSwitch(Exp p0, ListSwitchCase p1);
Stm make_StmReturn(Exp p0);
Stm make_StmAssert(Assertion p0);

struct IdMaybeTyped_
{
  enum { is_IdMaybeTypedNotTyped, is_IdMaybeTypedTyped } kind;
  union
  {
    struct { Id id_; } idmaybetypednottyped_;
    struct { Id id_; Type type_; } idmaybetypedtyped_;
  } u;
};

IdMaybeTyped make_IdMaybeTypedNotTyped(Id p0);
IdMaybeTyped make_IdMaybeTypedTyped(Id p0, Type p1);

struct IfCond_
{
  enum { is_IfCondCase, is_IfCondBool, is_IfCondUnfold } kind;
  union
  {
    struct { Case case_; Exp exp_; IdMaybeTyped idmaybetyped_; } ifcondcase_;
    struct { Exp exp_; } ifcondbool_;
    struct { Exp exp_; IdMaybeTyped idmaybetyped_1, idmaybetyped_2; } ifcondunfold_;
  } u;
};

IfCond make_IfCondCase(IdMaybeTyped p0, Case p1, Exp p2);
IfCond make_IfCondBool(Exp p0);
IfCond make_IfCondUnfold(IdMaybeTyped p0, IdMaybeTyped p1, Exp p2);

struct SwitchCase_
{
  enum { is_SwitchCaseDefault } kind;
  union
  {
    struct { Case case_; IdMaybeTyped idmaybetyped_; ListStm liststm_; } switchcasedefault_;
  } u;
};

SwitchCase make_SwitchCaseDefault(IdMaybeTyped p0, Case p1, ListStm p2);

struct ListSwitchCase_
{
  SwitchCase switchcase_;
  ListSwitchCase listswitchcase_;
};

ListSwitchCase make_ListSwitchCase(SwitchCase p1, ListSwitchCase p2);
struct Else_
{
  enum { is_ElseNone, is_ElseStms } kind;
  union
  {
    struct { ListStm liststm_; } elsestms_;
  } u;
};

Else make_ElseNone();
Else make_ElseStms(ListStm p0);

struct Case_
{
  enum { is_Case_inl, is_Case_inr } kind;
  //removed empty union due to swift incompatability
};

Case make_Case_inl();
Case make_Case_inr();

struct Exp_
{
  enum { is_ExpInt, is_ExpDouble, is_ExpUnit, is_ExpTrue, is_ExpFalse, is_ExpOption, is_ExpNothing, is_ExpId, is_ExpPair, is_ExpSum, is_ExpList, is_ExpRef, is_ExpApp, is_ExpNoising, is_ExpNegative, is_ExpNot, is_ExpTimes, is_ExpDiv, is_ExpPlus, is_ExpMinus, is_ExpLt, is_ExpGt, is_ExpLtEq, is_ExpGtEq, is_ExpEq, is_ExpNeq } kind;
  union
  {
    struct { Integer integer_; } expint_;
    struct { Double double_; } expdouble_;
    struct { Exp exp_; } expoption_;
    struct { Id id_; } expid_;
    struct { Exp exp_1, exp_2; } exppair_;
    struct { Case case_; Exp exp_; Ident ident_; } expsum_;
    struct { ListExp listexp_; } explist_;
    struct { Type type_; } expref_;
    struct { Id id_; ListExp listexp_; } expapp_;
    struct { Exp exp_; } expnoising_;
    struct { Exp exp_; } expnegative_;
    struct { Exp exp_; } expnot_;
    struct { Exp exp_1, exp_2; } exptimes_;
    struct { Exp exp_1, exp_2; } expdiv_;
    struct { Exp exp_1, exp_2; } expplus_;
    struct { Exp exp_1, exp_2; } expminus_;
    struct { Exp exp_1, exp_2; } explt_;
    struct { Exp exp_1, exp_2; } expgt_;
    struct { Exp exp_1, exp_2; } explteq_;
    struct { Exp exp_1, exp_2; } expgteq_;
    struct { Exp exp_1, exp_2; } expeq_;
    struct { Exp exp_1, exp_2; } expneq_;
  } u;
};

Exp make_ExpInt(Integer p0);
Exp make_ExpDouble(Double p0);
Exp make_ExpUnit();
Exp make_ExpTrue();
Exp make_ExpFalse();
Exp make_ExpOption(Exp p0);
Exp make_ExpNothing();
Exp make_ExpId(Id p0);
Exp make_ExpPair(Exp p0, Exp p1);
Exp make_ExpSum(Ident p0, Case p1, Exp p2);
Exp make_ExpList(ListExp p0);
Exp make_ExpRef(Type p0);
Exp make_ExpApp(Id p0, ListExp p1);
Exp make_ExpNoising(Exp p0);
Exp make_ExpNegative(Exp p0);
Exp make_ExpNot(Exp p0);
Exp make_ExpTimes(Exp p0, Exp p1);
Exp make_ExpDiv(Exp p0, Exp p1);
Exp make_ExpPlus(Exp p0, Exp p1);
Exp make_ExpMinus(Exp p0, Exp p1);
Exp make_ExpLt(Exp p0, Exp p1);
Exp make_ExpGt(Exp p0, Exp p1);
Exp make_ExpLtEq(Exp p0, Exp p1);
Exp make_ExpGtEq(Exp p0, Exp p1);
Exp make_ExpEq(Exp p0, Exp p1);
Exp make_ExpNeq(Exp p0, Exp p1);

struct ListExp_
{
  Exp exp_;
  ListExp listexp_;
};

ListExp make_ListExp(Exp p1, ListExp p2);
struct Assertion_
{
  enum { is_AssertionTypeEqual } kind;
  union
  {
    struct { Id id_; Type type_; } assertiontypeequal_;
  } u;
};

Assertion make_AssertionTypeEqual(Id p0, Type p1);

struct Type_
{
  enum { is_TypeInitDouble, is_TypeInitInt, is_TypeExponential } kind;
  union
  {
    struct { CoreType coretype_; Double double_; } typeinitdouble_;
    struct { CoreType coretype_; Integer integer_; } typeinitint_;
    struct { CoreType coretype_; } typeexponential_;
  } u;
};

Type make_TypeInitDouble(CoreType p0, Double p1);
Type make_TypeInitInt(CoreType p0, Integer p1);
Type make_TypeExponential(CoreType p0);

struct CoreType_
{
  enum { is_CoreTypeBase, is_CoreTypeMulPair, is_CoreTypeSum, is_CoreTypeList, is_CoreTypeNamed, is_CoreTypeFunction } kind;
  union
  {
    struct { BaseType basetype_; } coretypebase_;
    struct { Type type_1, type_2; } coretypemulpair_;
    struct { Type type_1, type_2; } coretypesum_;
    struct { Type type_; } coretypelist_;
    struct { Generics generics_; Ident ident_; } coretypenamed_;
    struct { ListType listtype_; Type type_; } coretypefunction_;
  } u;
};

CoreType make_CoreTypeBase(BaseType p0);
CoreType make_CoreTypeMulPair(Type p0, Type p1);
CoreType make_CoreTypeSum(Type p0, Type p1);
CoreType make_CoreTypeList(Type p0);
CoreType make_CoreTypeNamed(Ident p0, Generics p1);
CoreType make_CoreTypeFunction(ListType p0, Type p1);

struct Generics_
{
  enum { is_GenericsNone, is_GenericsType } kind;
  union
  {
    struct { Type type_; } genericstype_;
  } u;
};

Generics make_GenericsNone();
Generics make_GenericsType(Type p0);

struct ListType_
{
  Type type_;
  ListType listtype_;
};

ListType make_ListType(Type p1, ListType p2);
struct BaseType_
{
  enum { is_BaseType_Int, is_BaseType_Unit, is_BaseTypeDouble } kind;
  //removed empty union due to swift incompatability
};

BaseType make_BaseType_Int();
BaseType make_BaseType_Unit();
BaseType make_BaseTypeDouble();



#endif
