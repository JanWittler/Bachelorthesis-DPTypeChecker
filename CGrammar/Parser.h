#ifndef PARSER_HEADER_FILE
#define PARSER_HEADER_FILE

#include "Absyn.h"

typedef union
{
  int int_;
  char char_;
  double double_;
  char* string_;
  Program program_;
  ListDef listdef_;
  Def def_;
  ListArg listarg_;
  ListStm liststm_;
  Arg arg_;
  Stm stm_;
  IdMaybeTyped idmaybetyped_;
  IfCond ifcond_;
  SwitchCase switchcase_;
  ListSwitchCase listswitchcase_;
  Else else_;
  Case case_;
  ListExp listexp_;
  Exp exp_;
  Assertion assertion_;
  Type type_;
  CoreType coretype_;
  Generics generics_;
  ListType listtype_;
  BaseType basetype_;
} YYSTYPE;

#define _ERROR_ 258
#define _SYMB_0 259
#define _SYMB_1 260
#define _SYMB_2 261
#define _SYMB_3 262
#define _SYMB_4 263
#define _SYMB_5 264
#define _SYMB_6 265
#define _SYMB_7 266
#define _SYMB_8 267
#define _SYMB_9 268
#define _SYMB_10 269
#define _SYMB_11 270
#define _SYMB_12 271
#define _SYMB_13 272
#define _SYMB_14 273
#define _SYMB_15 274
#define _SYMB_16 275
#define _SYMB_17 276
#define _SYMB_18 277
#define _SYMB_19 278
#define _SYMB_20 279
#define _SYMB_21 280
#define _SYMB_22 281
#define _SYMB_23 282
#define _SYMB_24 283
#define _SYMB_25 284
#define _SYMB_26 285
#define _SYMB_27 286
#define _SYMB_28 287
#define _SYMB_29 288
#define _SYMB_30 289
#define _SYMB_31 290
#define _SYMB_32 291
#define _SYMB_33 292
#define _SYMB_34 293
#define _SYMB_35 294
#define _SYMB_36 295
#define _SYMB_37 296
#define _SYMB_38 297
#define _SYMB_39 298
#define _SYMB_40 299
#define _SYMB_41 300
#define _SYMB_42 301
#define _SYMB_43 302
#define _SYMB_44 303
#define _SYMB_45 304
#define _SYMB_46 305
#define _INTEGER_ 306
#define _DOUBLE_ 307
#define _IDENT_ 308

extern YYSTYPE yylval;
Program pProgram(FILE *inp);
ListDef pListDef(FILE *inp);
Def pDef(FILE *inp);
ListArg pListArg(FILE *inp);
ListStm pListStm(FILE *inp);
Arg pArg(FILE *inp);
Stm pStm(FILE *inp);
IdMaybeTyped pIdMaybeTyped(FILE *inp);
IfCond pIfCond(FILE *inp);
SwitchCase pSwitchCase(FILE *inp);
ListSwitchCase pListSwitchCase(FILE *inp);
Else pElse(FILE *inp);
Case pCase(FILE *inp);
ListExp pListExp(FILE *inp);
Exp pExp(FILE *inp);
Assertion pAssertion(FILE *inp);
Type pType(FILE *inp);
CoreType pCoreType(FILE *inp);
Generics pGenerics(FILE *inp);
ListType pListType(FILE *inp);
BaseType pBaseType(FILE *inp);


#endif
