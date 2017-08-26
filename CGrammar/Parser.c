/* A Bison parser, made by GNU Bison 2.3.  */

/* Skeleton implementation for Bison's Yacc-like parsers in C

   Copyright (C) 1984, 1989, 1990, 2000, 2001, 2002, 2003, 2004, 2005, 2006
   Free Software Foundation, Inc.

   This program is free software; you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation; either version 2, or (at your option)
   any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program; if not, write to the Free Software
   Foundation, Inc., 51 Franklin Street, Fifth Floor,
   Boston, MA 02110-1301, USA.  */

/* As a special exception, you may create a larger work that contains
   part or all of the Bison parser skeleton and distribute that work
   under terms of your choice, so long as that work isn't itself a
   parser generator using the skeleton or a modified version thereof
   as a parser skeleton.  Alternatively, if you modify or redistribute
   the parser skeleton itself, you may (at your option) remove this
   special exception, which will cause the skeleton and the resulting
   Bison output files to be licensed under the GNU General Public
   License without this special exception.

   This special exception was added by the Free Software Foundation in
   version 2.2 of Bison.  */

/* C LALR(1) parser skeleton written by Richard Stallman, by
   simplifying the original so-called "semantic" parser.  */

/* All symbols defined below should begin with yy or YY, to avoid
   infringing on user name space.  This should be done even for local
   variables, as they might otherwise be expanded by user macros.
   There are some unavoidable exceptions within include files to
   define necessary library symbols; they are noted "INFRINGES ON
   USER NAME SPACE" below.  */

/* Identify Bison output.  */
#define YYBISON 1

/* Bison version.  */
#define YYBISON_VERSION "2.3"

/* Skeleton name.  */
#define YYSKELETON_NAME "yacc.c"

/* Pure parsers.  */
#define YYPURE 0

/* Using locations.  */
#define YYLSP_NEEDED 0

/* Substitute the variable and function names.  */
#define yyparse Grammarparse
#define yylex   Grammarlex
#define yyerror Grammarerror
#define yylval  Grammarlval
#define yychar  Grammarchar
#define yydebug Grammardebug
#define yynerrs Grammarnerrs


/* Tokens.  */
#ifndef YYTOKENTYPE
# define YYTOKENTYPE
   /* Put the tokens into the symbol table, so that GDB and other debuggers
      know about them.  */
   enum yytokentype {
     _ERROR_ = 258,
     _SYMB_0 = 259,
     _SYMB_1 = 260,
     _SYMB_2 = 261,
     _SYMB_3 = 262,
     _SYMB_4 = 263,
     _SYMB_5 = 264,
     _SYMB_6 = 265,
     _SYMB_7 = 266,
     _SYMB_8 = 267,
     _SYMB_9 = 268,
     _SYMB_10 = 269,
     _SYMB_11 = 270,
     _SYMB_12 = 271,
     _SYMB_13 = 272,
     _SYMB_14 = 273,
     _SYMB_15 = 274,
     _SYMB_16 = 275,
     _SYMB_17 = 276,
     _SYMB_18 = 277,
     _SYMB_19 = 278,
     _SYMB_20 = 279,
     _SYMB_21 = 280,
     _SYMB_22 = 281,
     _SYMB_23 = 282,
     _SYMB_24 = 283,
     _SYMB_25 = 284,
     _SYMB_26 = 285,
     _SYMB_27 = 286,
     _SYMB_28 = 287,
     _SYMB_29 = 288,
     _SYMB_30 = 289,
     _SYMB_31 = 290,
     _SYMB_32 = 291,
     _SYMB_33 = 292,
     _SYMB_34 = 293,
     _SYMB_35 = 294,
     _SYMB_36 = 295,
     _SYMB_37 = 296,
     _SYMB_38 = 297,
     _SYMB_39 = 298,
     _SYMB_40 = 299,
     _SYMB_41 = 300,
     _SYMB_42 = 301,
     _SYMB_43 = 302,
     _SYMB_44 = 303,
     _SYMB_45 = 304,
     _SYMB_46 = 305,
     _INTEGER_ = 306,
     _DOUBLE_ = 307,
     _IDENT_ = 308
   };
#endif
/* Tokens.  */
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




/* Copy the first part of user declarations.  */
#line 2 "Grammar.y"

#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include "Absyn.h"
#define initialize_lexer Grammar_initialize_lexer
extern int yyparse(void);
extern int yylex(void);
int yy_mylinenumber;
extern int initialize_lexer(FILE * inp);
void yyerror(const char *str)
{
  extern char *Grammartext;
  fprintf(stderr,"error: line %d: %s at %s\n",
    yy_mylinenumber + 1, str, Grammartext);
}

Program YY_RESULT_Program_ = 0;
Program pProgram(FILE *inp)
{
  initialize_lexer(inp);
  if (yyparse())
  { /* Failure */
    return 0;
  }
  else
  { /* Success */
    return YY_RESULT_Program_;
  }
}

ListDef YY_RESULT_ListDef_ = 0;
ListDef pListDef(FILE *inp)
{
  initialize_lexer(inp);
  if (yyparse())
  { /* Failure */
    return 0;
  }
  else
  { /* Success */
    return YY_RESULT_ListDef_;
  }
}

Def YY_RESULT_Def_ = 0;
Def pDef(FILE *inp)
{
  initialize_lexer(inp);
  if (yyparse())
  { /* Failure */
    return 0;
  }
  else
  { /* Success */
    return YY_RESULT_Def_;
  }
}

ListArg YY_RESULT_ListArg_ = 0;
ListArg pListArg(FILE *inp)
{
  initialize_lexer(inp);
  if (yyparse())
  { /* Failure */
    return 0;
  }
  else
  { /* Success */
    return YY_RESULT_ListArg_;
  }
}

ListStm YY_RESULT_ListStm_ = 0;
ListStm pListStm(FILE *inp)
{
  initialize_lexer(inp);
  if (yyparse())
  { /* Failure */
    return 0;
  }
  else
  { /* Success */
    return YY_RESULT_ListStm_;
  }
}

Arg YY_RESULT_Arg_ = 0;
Arg pArg(FILE *inp)
{
  initialize_lexer(inp);
  if (yyparse())
  { /* Failure */
    return 0;
  }
  else
  { /* Success */
    return YY_RESULT_Arg_;
  }
}

Stm YY_RESULT_Stm_ = 0;
Stm pStm(FILE *inp)
{
  initialize_lexer(inp);
  if (yyparse())
  { /* Failure */
    return 0;
  }
  else
  { /* Success */
    return YY_RESULT_Stm_;
  }
}

IdMaybeTyped YY_RESULT_IdMaybeTyped_ = 0;
IdMaybeTyped pIdMaybeTyped(FILE *inp)
{
  initialize_lexer(inp);
  if (yyparse())
  { /* Failure */
    return 0;
  }
  else
  { /* Success */
    return YY_RESULT_IdMaybeTyped_;
  }
}

IfCond YY_RESULT_IfCond_ = 0;
IfCond pIfCond(FILE *inp)
{
  initialize_lexer(inp);
  if (yyparse())
  { /* Failure */
    return 0;
  }
  else
  { /* Success */
    return YY_RESULT_IfCond_;
  }
}

SwitchCase YY_RESULT_SwitchCase_ = 0;
SwitchCase pSwitchCase(FILE *inp)
{
  initialize_lexer(inp);
  if (yyparse())
  { /* Failure */
    return 0;
  }
  else
  { /* Success */
    return YY_RESULT_SwitchCase_;
  }
}

ListSwitchCase YY_RESULT_ListSwitchCase_ = 0;
ListSwitchCase pListSwitchCase(FILE *inp)
{
  initialize_lexer(inp);
  if (yyparse())
  { /* Failure */
    return 0;
  }
  else
  { /* Success */
    return YY_RESULT_ListSwitchCase_;
  }
}

Else YY_RESULT_Else_ = 0;
Else pElse(FILE *inp)
{
  initialize_lexer(inp);
  if (yyparse())
  { /* Failure */
    return 0;
  }
  else
  { /* Success */
    return YY_RESULT_Else_;
  }
}

Case YY_RESULT_Case_ = 0;
Case pCase(FILE *inp)
{
  initialize_lexer(inp);
  if (yyparse())
  { /* Failure */
    return 0;
  }
  else
  { /* Success */
    return YY_RESULT_Case_;
  }
}

Exp YY_RESULT_Exp_ = 0;
Exp pExp(FILE *inp)
{
  initialize_lexer(inp);
  if (yyparse())
  { /* Failure */
    return 0;
  }
  else
  { /* Success */
    return YY_RESULT_Exp_;
  }
}

ListExp YY_RESULT_ListExp_ = 0;
ListExp pListExp(FILE *inp)
{
  initialize_lexer(inp);
  if (yyparse())
  { /* Failure */
    return 0;
  }
  else
  { /* Success */
    return YY_RESULT_ListExp_;
  }
}

Assertion YY_RESULT_Assertion_ = 0;
Assertion pAssertion(FILE *inp)
{
  initialize_lexer(inp);
  if (yyparse())
  { /* Failure */
    return 0;
  }
  else
  { /* Success */
    return YY_RESULT_Assertion_;
  }
}

Type YY_RESULT_Type_ = 0;
Type pType(FILE *inp)
{
  initialize_lexer(inp);
  if (yyparse())
  { /* Failure */
    return 0;
  }
  else
  { /* Success */
    return YY_RESULT_Type_;
  }
}

CoreType YY_RESULT_CoreType_ = 0;
CoreType pCoreType(FILE *inp)
{
  initialize_lexer(inp);
  if (yyparse())
  { /* Failure */
    return 0;
  }
  else
  { /* Success */
    return YY_RESULT_CoreType_;
  }
}

Generics YY_RESULT_Generics_ = 0;
Generics pGenerics(FILE *inp)
{
  initialize_lexer(inp);
  if (yyparse())
  { /* Failure */
    return 0;
  }
  else
  { /* Success */
    return YY_RESULT_Generics_;
  }
}

ListType YY_RESULT_ListType_ = 0;
ListType pListType(FILE *inp)
{
  initialize_lexer(inp);
  if (yyparse())
  { /* Failure */
    return 0;
  }
  else
  { /* Success */
    return YY_RESULT_ListType_;
  }
}

BaseType YY_RESULT_BaseType_ = 0;
BaseType pBaseType(FILE *inp)
{
  initialize_lexer(inp);
  if (yyparse())
  { /* Failure */
    return 0;
  }
  else
  { /* Success */
    return YY_RESULT_BaseType_;
  }
}


ListDef reverseListDef(ListDef l)
{
  ListDef prev = 0;
  ListDef tmp = 0;
  while (l)
  {
    tmp = l->listdef_;
    l->listdef_ = prev;
    prev = l;
    l = tmp;
  }
  return prev;
}
ListArg reverseListArg(ListArg l)
{
  ListArg prev = 0;
  ListArg tmp = 0;
  while (l)
  {
    tmp = l->listarg_;
    l->listarg_ = prev;
    prev = l;
    l = tmp;
  }
  return prev;
}
ListStm reverseListStm(ListStm l)
{
  ListStm prev = 0;
  ListStm tmp = 0;
  while (l)
  {
    tmp = l->liststm_;
    l->liststm_ = prev;
    prev = l;
    l = tmp;
  }
  return prev;
}
ListSwitchCase reverseListSwitchCase(ListSwitchCase l)
{
  ListSwitchCase prev = 0;
  ListSwitchCase tmp = 0;
  while (l)
  {
    tmp = l->listswitchcase_;
    l->listswitchcase_ = prev;
    prev = l;
    l = tmp;
  }
  return prev;
}
ListExp reverseListExp(ListExp l)
{
  ListExp prev = 0;
  ListExp tmp = 0;
  while (l)
  {
    tmp = l->listexp_;
    l->listexp_ = prev;
    prev = l;
    l = tmp;
  }
  return prev;
}
ListType reverseListType(ListType l)
{
  ListType prev = 0;
  ListType tmp = 0;
  while (l)
  {
    tmp = l->listtype_;
    l->listtype_ = prev;
    prev = l;
    l = tmp;
  }
  return prev;
}



/* Enabling traces.  */
#ifndef YYDEBUG
# define YYDEBUG 1
#endif

/* Enabling verbose error messages.  */
#ifdef YYERROR_VERBOSE
# undef YYERROR_VERBOSE
# define YYERROR_VERBOSE 1
#else
# define YYERROR_VERBOSE 0
#endif

/* Enabling the token table.  */
#ifndef YYTOKEN_TABLE
# define YYTOKEN_TABLE 0
#endif

#if ! defined YYSTYPE && ! defined YYSTYPE_IS_DECLARED
typedef union YYSTYPE
#line 396 "Grammar.y"
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
  Exp exp_;
  ListExp listexp_;
  Assertion assertion_;
  Type type_;
  CoreType coretype_;
  Generics generics_;
  ListType listtype_;
  BaseType basetype_;

}
/* Line 193 of yacc.c.  */
#line 632 "Parser.c"
	YYSTYPE;
# define yystype YYSTYPE /* obsolescent; will be withdrawn */
# define YYSTYPE_IS_DECLARED 1
# define YYSTYPE_IS_TRIVIAL 1
#endif



/* Copy the second part of user declarations.  */


/* Line 216 of yacc.c.  */
#line 645 "Parser.c"

#ifdef short
# undef short
#endif

#ifdef YYTYPE_UINT8
typedef YYTYPE_UINT8 yytype_uint8;
#else
typedef unsigned char yytype_uint8;
#endif

#ifdef YYTYPE_INT8
typedef YYTYPE_INT8 yytype_int8;
#elif (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
typedef signed char yytype_int8;
#else
typedef short int yytype_int8;
#endif

#ifdef YYTYPE_UINT16
typedef YYTYPE_UINT16 yytype_uint16;
#else
typedef unsigned short int yytype_uint16;
#endif

#ifdef YYTYPE_INT16
typedef YYTYPE_INT16 yytype_int16;
#else
typedef short int yytype_int16;
#endif

#ifndef YYSIZE_T
# ifdef __SIZE_TYPE__
#  define YYSIZE_T __SIZE_TYPE__
# elif defined size_t
#  define YYSIZE_T size_t
# elif ! defined YYSIZE_T && (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
#  include <stddef.h> /* INFRINGES ON USER NAME SPACE */
#  define YYSIZE_T size_t
# else
#  define YYSIZE_T unsigned int
# endif
#endif

#define YYSIZE_MAXIMUM ((YYSIZE_T) -1)

#ifndef YY_
# if defined YYENABLE_NLS && YYENABLE_NLS
#  if ENABLE_NLS
#   include <libintl.h> /* INFRINGES ON USER NAME SPACE */
#   define YY_(msgid) dgettext ("bison-runtime", msgid)
#  endif
# endif
# ifndef YY_
#  define YY_(msgid) msgid
# endif
#endif

/* Suppress unused-variable warnings by "using" E.  */
#if ! defined lint || defined __GNUC__
# define YYUSE(e) ((void) (e))
#else
# define YYUSE(e) /* empty */
#endif

/* Identity function, used to suppress warnings about constant conditions.  */
#ifndef lint
# define YYID(n) (n)
#else
#if (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
static int
YYID (int i)
#else
static int
YYID (i)
    int i;
#endif
{
  return i;
}
#endif

#if ! defined yyoverflow || YYERROR_VERBOSE

/* The parser invokes alloca or malloc; define the necessary symbols.  */

# ifdef YYSTACK_USE_ALLOCA
#  if YYSTACK_USE_ALLOCA
#   ifdef __GNUC__
#    define YYSTACK_ALLOC __builtin_alloca
#   elif defined __BUILTIN_VA_ARG_INCR
#    include <alloca.h> /* INFRINGES ON USER NAME SPACE */
#   elif defined _AIX
#    define YYSTACK_ALLOC __alloca
#   elif defined _MSC_VER
#    include <malloc.h> /* INFRINGES ON USER NAME SPACE */
#    define alloca _alloca
#   else
#    define YYSTACK_ALLOC alloca
#    if ! defined _ALLOCA_H && ! defined _STDLIB_H && (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
#     include <stdlib.h> /* INFRINGES ON USER NAME SPACE */
#     ifndef _STDLIB_H
#      define _STDLIB_H 1
#     endif
#    endif
#   endif
#  endif
# endif

# ifdef YYSTACK_ALLOC
   /* Pacify GCC's `empty if-body' warning.  */
#  define YYSTACK_FREE(Ptr) do { /* empty */; } while (YYID (0))
#  ifndef YYSTACK_ALLOC_MAXIMUM
    /* The OS might guarantee only one guard page at the bottom of the stack,
       and a page size can be as small as 4096 bytes.  So we cannot safely
       invoke alloca (N) if N exceeds 4096.  Use a slightly smaller number
       to allow for a few compiler-allocated temporary stack slots.  */
#   define YYSTACK_ALLOC_MAXIMUM 4032 /* reasonable circa 2006 */
#  endif
# else
#  define YYSTACK_ALLOC YYMALLOC
#  define YYSTACK_FREE YYFREE
#  ifndef YYSTACK_ALLOC_MAXIMUM
#   define YYSTACK_ALLOC_MAXIMUM YYSIZE_MAXIMUM
#  endif
#  if (defined __cplusplus && ! defined _STDLIB_H \
       && ! ((defined YYMALLOC || defined malloc) \
	     && (defined YYFREE || defined free)))
#   include <stdlib.h> /* INFRINGES ON USER NAME SPACE */
#   ifndef _STDLIB_H
#    define _STDLIB_H 1
#   endif
#  endif
#  ifndef YYMALLOC
#   define YYMALLOC malloc
#   if ! defined malloc && ! defined _STDLIB_H && (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
void *malloc (YYSIZE_T); /* INFRINGES ON USER NAME SPACE */
#   endif
#  endif
#  ifndef YYFREE
#   define YYFREE free
#   if ! defined free && ! defined _STDLIB_H && (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
void free (void *); /* INFRINGES ON USER NAME SPACE */
#   endif
#  endif
# endif
#endif /* ! defined yyoverflow || YYERROR_VERBOSE */


#if (! defined yyoverflow \
     && (! defined __cplusplus \
	 || (defined YYSTYPE_IS_TRIVIAL && YYSTYPE_IS_TRIVIAL)))

/* A type that is properly aligned for any stack member.  */
union yyalloc
{
  yytype_int16 yyss;
  YYSTYPE yyvs;
  };

/* The size of the maximum gap between one aligned stack and the next.  */
# define YYSTACK_GAP_MAXIMUM (sizeof (union yyalloc) - 1)

/* The size of an array large to enough to hold all stacks, each with
   N elements.  */
# define YYSTACK_BYTES(N) \
     ((N) * (sizeof (yytype_int16) + sizeof (YYSTYPE)) \
      + YYSTACK_GAP_MAXIMUM)

/* Copy COUNT objects from FROM to TO.  The source and destination do
   not overlap.  */
# ifndef YYCOPY
#  if defined __GNUC__ && 1 < __GNUC__
#   define YYCOPY(To, From, Count) \
      __builtin_memcpy (To, From, (Count) * sizeof (*(From)))
#  else
#   define YYCOPY(To, From, Count)		\
      do					\
	{					\
	  YYSIZE_T yyi;				\
	  for (yyi = 0; yyi < (Count); yyi++)	\
	    (To)[yyi] = (From)[yyi];		\
	}					\
      while (YYID (0))
#  endif
# endif

/* Relocate STACK from its old location to the new one.  The
   local variables YYSIZE and YYSTACKSIZE give the old and new number of
   elements in the stack, and YYPTR gives the new location of the
   stack.  Advance YYPTR to a properly aligned location for the next
   stack.  */
# define YYSTACK_RELOCATE(Stack)					\
    do									\
      {									\
	YYSIZE_T yynewbytes;						\
	YYCOPY (&yyptr->Stack, Stack, yysize);				\
	Stack = &yyptr->Stack;						\
	yynewbytes = yystacksize * sizeof (*Stack) + YYSTACK_GAP_MAXIMUM; \
	yyptr += yynewbytes / sizeof (*yyptr);				\
      }									\
    while (YYID (0))

#endif

/* YYFINAL -- State number of the termination state.  */
#define YYFINAL  3
/* YYLAST -- Last index in YYTABLE.  */
#define YYLAST   261

/* YYNTOKENS -- Number of terminals.  */
#define YYNTOKENS  54
/* YYNNTS -- Number of nonterminals.  */
#define YYNNTS  37
/* YYNRULES -- Number of rules.  */
#define YYNRULES  94
/* YYNRULES -- Number of states.  */
#define YYNSTATES  229

/* YYTRANSLATE(YYLEX) -- Bison symbol number corresponding to YYLEX.  */
#define YYUNDEFTOK  2
#define YYMAXUTOK   308

#define YYTRANSLATE(YYX)						\
  ((unsigned int) (YYX) <= YYMAXUTOK ? yytranslate[YYX] : YYUNDEFTOK)

/* YYTRANSLATE[YYLEX] -- Bison symbol number corresponding to YYLEX.  */
static const yytype_uint8 yytranslate[] =
{
       0,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     2,     2,     2,     2,
       2,     2,     2,     2,     2,     2,     1,     2,     3,     4,
       5,     6,     7,     8,     9,    10,    11,    12,    13,    14,
      15,    16,    17,    18,    19,    20,    21,    22,    23,    24,
      25,    26,    27,    28,    29,    30,    31,    32,    33,    34,
      35,    36,    37,    38,    39,    40,    41,    42,    43,    44,
      45,    46,    47,    48,    49,    50,    51,    52,    53
};

#if YYDEBUG
/* YYPRHS[YYN] -- Index of the first RHS symbol of rule number YYN in
   YYRHS.  */
static const yytype_uint16 yyprhs[] =
{
       0,     0,     3,     5,     6,     9,    20,    32,    40,    41,
      43,    47,    48,    51,    55,    60,    69,    78,    86,    89,
      91,    93,    97,   104,   106,   116,   126,   128,   131,   132,
     137,   139,   141,   143,   145,   148,   150,   152,   157,   159,
     161,   167,   174,   178,   185,   190,   195,   199,   202,   204,
     207,   209,   213,   217,   219,   223,   227,   229,   233,   237,
     241,   245,   247,   251,   255,   257,   258,   260,   264,   266,
     268,   270,   272,   274,   276,   278,   280,   282,   289,   293,
     297,   301,   303,   309,   315,   319,   322,   330,   331,   335,
     336,   338,   342,   344,   346
};

/* YYRHS -- A `-1'-separated list of the rules' RHS.  */
static const yytype_int8 yyrhs[] =
{
      55,     0,    -1,    56,    -1,    -1,    56,    57,    -1,    37,
      50,     4,    58,     5,     6,    86,     7,    59,     8,    -1,
      35,    37,    50,     4,    58,     5,     6,    86,     7,    59,
       8,    -1,    47,    53,     9,    49,    86,    10,    86,    -1,
      -1,    60,    -1,    60,    11,    58,    -1,    -1,    59,    61,
      -1,    50,    12,    86,    -1,    42,    62,     9,    76,    -1,
      42,     4,    62,    11,    62,     5,     9,    76,    -1,    38,
       4,    63,     5,     7,    59,     8,    66,    -1,    45,     4,
      76,     5,     7,    65,     8,    -1,    44,    76,    -1,    85,
      -1,    50,    -1,    50,    12,    86,    -1,    33,    42,    62,
       9,    67,    76,    -1,    76,    -1,    42,     4,    62,    11,
      62,     5,     9,    48,    76,    -1,    33,    42,    62,     9,
      67,    12,     7,    59,     8,    -1,    64,    -1,    64,    65,
      -1,    -1,    34,     7,    59,     8,    -1,    40,    -1,    41,
      -1,    51,    -1,    52,    -1,     4,     5,    -1,    46,    -1,
      36,    -1,    28,     4,    76,     5,    -1,    29,    -1,    50,
      -1,     4,    76,    11,    76,     5,    -1,    53,     4,    67,
      12,    76,     5,    -1,    13,    75,    14,    -1,    43,    15,
      86,    16,     4,     5,    -1,    50,     4,    75,     5,    -1,
      31,     4,    76,     5,    -1,     4,    76,     5,    -1,    17,
      70,    -1,    68,    -1,    18,    69,    -1,    69,    -1,    71,
      19,    70,    -1,    71,    20,    70,    -1,    70,    -1,    72,
      21,    71,    -1,    72,    17,    71,    -1,    71,    -1,    73,
      15,    84,    -1,    73,    16,    84,    -1,    73,    22,    84,
      -1,    73,    23,    84,    -1,    84,    -1,    74,    24,    73,
      -1,    74,    25,    73,    -1,    73,    -1,    -1,    76,    -1,
      76,    11,    75,    -1,    77,    -1,    78,    -1,    79,    -1,
      80,    -1,    81,    -1,    82,    -1,    83,    -1,    74,    -1,
      72,    -1,    32,     4,    50,    11,    86,     5,    -1,    87,
      18,    52,    -1,    87,    18,    51,    -1,    87,    18,    39,
      -1,    90,    -1,     4,    86,    11,    86,     5,    -1,     4,
      86,    21,    86,     5,    -1,    13,    86,    14,    -1,    53,
      88,    -1,     4,     4,    89,     5,     6,    86,     5,    -1,
      -1,    15,    86,    16,    -1,    -1,    86,    -1,    86,    11,
      89,    -1,    27,    -1,    30,    -1,    26,    -1
};

/* YYRLINE[YYN] -- source line where rule number YYN was defined.  */
static const yytype_uint16 yyrline[] =
{
       0,   517,   517,   519,   520,   522,   523,   524,   526,   527,
     528,   530,   531,   533,   535,   536,   537,   538,   539,   540,
     542,   543,   545,   546,   547,   549,   551,   552,   554,   555,
     557,   558,   560,   561,   562,   563,   564,   565,   566,   567,
     568,   569,   570,   571,   572,   573,   574,   576,   577,   579,
     580,   582,   583,   584,   586,   587,   588,   590,   591,   592,
     593,   594,   596,   597,   598,   600,   601,   602,   604,   606,
     608,   610,   612,   614,   616,   618,   620,   622,   624,   625,
     626,   628,   629,   630,   631,   632,   633,   635,   636,   638,
     639,   640,   642,   643,   644
};
#endif

#if YYDEBUG || YYERROR_VERBOSE || YYTOKEN_TABLE
/* YYTNAME[SYMBOL-NUM] -- String name of the symbol SYMBOL-NUM.
   First, the terminals, then, starting at YYNTOKENS, nonterminals.  */
static const char *const yytname[] =
{
  "$end", "error", "$undefined", "_ERROR_", "_SYMB_0", "_SYMB_1",
  "_SYMB_2", "_SYMB_3", "_SYMB_4", "_SYMB_5", "_SYMB_6", "_SYMB_7",
  "_SYMB_8", "_SYMB_9", "_SYMB_10", "_SYMB_11", "_SYMB_12", "_SYMB_13",
  "_SYMB_14", "_SYMB_15", "_SYMB_16", "_SYMB_17", "_SYMB_18", "_SYMB_19",
  "_SYMB_20", "_SYMB_21", "_SYMB_22", "_SYMB_23", "_SYMB_24", "_SYMB_25",
  "_SYMB_26", "_SYMB_27", "_SYMB_28", "_SYMB_29", "_SYMB_30", "_SYMB_31",
  "_SYMB_32", "_SYMB_33", "_SYMB_34", "_SYMB_35", "_SYMB_36", "_SYMB_37",
  "_SYMB_38", "_SYMB_39", "_SYMB_40", "_SYMB_41", "_SYMB_42", "_SYMB_43",
  "_SYMB_44", "_SYMB_45", "_SYMB_46", "_INTEGER_", "_DOUBLE_", "_IDENT_",
  "$accept", "Program", "ListDef", "Def", "ListArg", "ListStm", "Arg",
  "Stm", "IdMaybeTyped", "IfCond", "SwitchCase", "ListSwitchCase", "Else",
  "Case", "Exp15", "Exp14", "Exp13", "Exp12", "Exp11", "Exp9", "Exp8",
  "ListExp", "Exp", "Exp1", "Exp2", "Exp3", "Exp4", "Exp5", "Exp6", "Exp7",
  "Exp10", "Assertion", "Type", "CoreType", "Generics", "ListType",
  "BaseType", 0
};
#endif

# ifdef YYPRINT
/* YYTOKNUM[YYLEX-NUM] -- Internal token number corresponding to
   token YYLEX-NUM.  */
static const yytype_uint16 yytoknum[] =
{
       0,   256,   257,   258,   259,   260,   261,   262,   263,   264,
     265,   266,   267,   268,   269,   270,   271,   272,   273,   274,
     275,   276,   277,   278,   279,   280,   281,   282,   283,   284,
     285,   286,   287,   288,   289,   290,   291,   292,   293,   294,
     295,   296,   297,   298,   299,   300,   301,   302,   303,   304,
     305,   306,   307,   308
};
# endif

/* YYR1[YYN] -- Symbol number of symbol that rule YYN derives.  */
static const yytype_uint8 yyr1[] =
{
       0,    54,    55,    56,    56,    57,    57,    57,    58,    58,
      58,    59,    59,    60,    61,    61,    61,    61,    61,    61,
      62,    62,    63,    63,    63,    64,    65,    65,    66,    66,
      67,    67,    68,    68,    68,    68,    68,    68,    68,    68,
      68,    68,    68,    68,    68,    68,    68,    69,    69,    70,
      70,    71,    71,    71,    72,    72,    72,    73,    73,    73,
      73,    73,    74,    74,    74,    75,    75,    75,    76,    77,
      78,    79,    80,    81,    82,    83,    84,    85,    86,    86,
      86,    87,    87,    87,    87,    87,    87,    88,    88,    89,
      89,    89,    90,    90,    90
};

/* YYR2[YYN] -- Number of symbols composing right hand side of rule YYN.  */
static const yytype_uint8 yyr2[] =
{
       0,     2,     1,     0,     2,    10,    11,     7,     0,     1,
       3,     0,     2,     3,     4,     8,     8,     7,     2,     1,
       1,     3,     6,     1,     9,     9,     1,     2,     0,     4,
       1,     1,     1,     1,     2,     1,     1,     4,     1,     1,
       5,     6,     3,     6,     4,     4,     3,     2,     1,     2,
       1,     3,     3,     1,     3,     3,     1,     3,     3,     3,
       3,     1,     3,     3,     1,     0,     1,     3,     1,     1,
       1,     1,     1,     1,     1,     1,     1,     6,     3,     3,
       3,     1,     5,     5,     3,     2,     7,     0,     3,     0,
       1,     3,     1,     1,     1
};

/* YYDEFACT[STATE-NAME] -- Default rule to reduce with in state
   STATE-NUM when YYTABLE doesn't specify something else to do.  Zero
   means the default is an error.  */
static const yytype_uint8 yydefact[] =
{
       3,     0,     2,     1,     0,     0,     0,     4,     0,     0,
       0,     0,     8,     0,     8,     0,     0,     9,     0,     0,
       0,     0,     8,     0,     0,    94,    92,    93,    87,     0,
       0,    81,     0,    13,     0,    10,    89,     0,     0,     0,
      85,     0,     0,     0,     0,    90,     0,     0,     0,    84,
       0,     7,    80,    79,    78,     0,    11,    89,     0,     0,
       0,    88,    11,     0,     0,    91,     0,    82,    83,     0,
       5,     0,     0,     0,     0,     0,    12,    19,    89,     0,
       6,     0,     0,     0,    20,     0,     0,    65,     0,     0,
       0,    38,     0,    36,     0,    35,    39,    32,    33,     0,
      48,    50,    53,    56,    76,    64,    75,    18,    68,    69,
      70,    71,    72,    73,    74,    61,     0,    90,    86,     0,
       0,     0,     0,    23,     0,     0,     0,    34,     0,     0,
      66,    47,    49,     0,     0,     0,    65,     0,     0,     0,
       0,     0,     0,     0,     0,     0,     0,     0,     0,     0,
       0,     0,     0,     0,    21,    14,    46,     0,    42,    65,
       0,     0,     0,     0,    30,    31,     0,    51,    52,    55,
      54,    57,    58,    59,    60,    62,    63,     0,     0,     0,
       0,    11,     0,     0,    67,    37,    45,     0,    44,     0,
       0,    77,     0,     0,     0,     0,    40,     0,     0,     0,
      26,     0,     0,     0,    28,     0,    43,    41,     0,    27,
      17,    22,     0,     0,    16,    15,     0,     0,    11,     0,
       0,     0,     0,    24,    29,     0,    11,     0,    25
};

/* YYDEFGOTO[NTERM-NUM].  */
static const yytype_int16 yydefgoto[] =
{
      -1,     1,     2,     7,    16,    63,    17,    76,    85,   122,
     200,   201,   214,   166,   100,   101,   102,   103,   104,   105,
     106,   129,   130,   108,   109,   110,   111,   112,   113,   114,
     115,    77,    29,    30,    40,    65,    31
};

/* YYPACT[STATE-NUM] -- Index in YYTABLE of the portion describing
   STATE-NUM.  */
#define YYPACT_NINF -190
static const yytype_int16 yypact[] =
{
    -190,    15,   -14,  -190,    20,     9,    11,  -190,    25,    76,
      62,    90,    64,    66,    64,   105,   113,   109,    12,   119,
      12,   122,    64,    73,    12,  -190,  -190,  -190,   110,   121,
     115,  -190,   130,  -190,    12,  -190,    73,    -4,   124,    12,
    -190,    12,   -33,    12,   132,    30,   135,    12,    12,  -190,
     125,  -190,  -190,  -190,  -190,   136,  -190,    12,   138,   137,
     144,  -190,  -190,     2,    21,  -190,    12,  -190,  -190,   143,
    -190,   146,   150,     0,   148,   151,  -190,  -190,    12,   152,
    -190,   108,    45,   112,   147,   162,   117,   148,   148,   176,
     169,  -190,   170,  -190,   163,  -190,   178,  -190,  -190,   179,
    -190,  -190,  -190,    48,    31,    67,    68,  -190,  -190,  -190,
    -190,  -190,  -190,  -190,  -190,  -190,   148,   175,  -190,   181,
     153,   186,   192,  -190,   200,    12,   148,  -190,    74,   189,
     203,  -190,  -190,   148,   148,    12,   148,    61,   148,   148,
     148,   148,   148,   148,   148,   148,   148,   148,   208,    12,
     112,   112,   209,   112,  -190,  -190,  -190,   148,  -190,   148,
     212,   213,   204,   216,  -190,  -190,   211,  -190,  -190,    48,
      48,  -190,  -190,  -190,  -190,    67,    67,   217,   220,   221,
     222,  -190,   226,   227,  -190,  -190,  -190,   231,  -190,   148,
     205,  -190,    61,   112,   164,   228,  -190,   236,   237,   194,
     205,   235,   148,   243,   219,   148,  -190,  -190,   112,  -190,
    -190,  -190,   241,   247,  -190,  -190,   246,   210,  -190,    61,
     148,   202,   244,  -190,  -190,   250,  -190,   207,  -190
};

/* YYPGOTO[NTERM-NUM].  */
static const yytype_int16 yypgoto[] =
{
    -190,  -190,  -190,  -190,     6,   -62,  -190,  -190,   -81,  -190,
    -190,    59,  -190,  -189,  -190,   171,   -83,   -32,  -190,   -36,
    -190,  -122,   -73,  -190,  -190,  -190,  -190,  -190,  -190,  -190,
     -38,  -190,   -12,  -190,  -190,   225,  -190
};

/* YYTABLE[YYPACT[STATE-NUM]].  What to do in state STATE-NUM.  If
   positive, shift that token.  If negative, reduce the rule which
   number is the opposite.  If zero, do what YYDEFACT says.
   If YYTABLE_NINF, syntax error.  */
#define YYTABLE_NINF -1
static const yytype_uint8 yytable[] =
{
      69,   107,   124,   202,    83,   131,    52,    47,    33,   123,
      70,    37,    38,   128,   163,     3,    23,    48,    53,    54,
      19,     4,    44,     5,    45,    24,    67,    50,    35,    51,
     222,    55,    78,     6,    71,    59,    60,   184,    25,    26,
      72,    57,    27,   148,    73,    64,    74,    75,   140,    86,
      84,    48,   141,   155,    79,   167,   168,     8,    87,     9,
     160,   161,    88,    89,    10,    28,   117,   138,   139,   179,
     180,    13,   182,    90,    91,    11,    92,    36,   120,   156,
      12,    93,   142,   143,   183,   157,    24,   121,    94,   144,
     145,    95,   146,   147,    14,    96,    97,    98,    99,    25,
      26,   164,   165,    27,   171,   172,   173,   174,   169,   170,
     175,   176,   203,   154,    15,    18,   198,    20,    21,   194,
      22,    86,   127,   162,    32,    39,    28,   216,    34,   211,
      87,    41,   215,    42,    88,    89,    43,   178,    49,    56,
      58,    61,    67,    62,    66,    90,    91,   223,    92,    68,
      81,    80,    86,    93,    82,   116,   221,   118,   119,   125,
      94,    87,    84,    95,   227,    88,    89,    96,    97,    98,
      99,   126,   204,   133,   134,    71,    90,    91,   135,    92,
      86,    72,   136,   137,    93,    73,    78,    74,    75,    87,
     151,    94,   149,    88,    95,   150,    71,   152,    96,    97,
      98,    99,    72,   158,    90,    91,    73,    92,    74,    75,
     224,   153,    93,   177,   159,   228,   181,   185,   186,    94,
     187,   188,    95,   189,   190,   191,    96,    97,    98,    99,
     192,   195,   196,   193,    71,   197,   208,   205,   199,    71,
      72,   206,   207,   210,    73,    72,    74,    75,   212,    73,
     217,    74,    75,   213,   218,   219,   225,   226,   220,   209,
     132,    46
};

static const yytype_uint8 yycheck[] =
{
      62,    74,    83,   192,     4,    88,    39,    11,    20,    82,
       8,    23,    24,    86,   136,     0,     4,    21,    51,    52,
      14,    35,    34,    37,    36,    13,     5,    39,    22,    41,
     219,    43,    11,    47,    32,    47,    48,   159,    26,    27,
      38,    11,    30,   116,    42,    57,    44,    45,    17,     4,
      50,    21,    21,   126,    66,   138,   139,    37,    13,    50,
     133,   134,    17,    18,    53,    53,    78,    19,    20,   150,
     151,     9,   153,    28,    29,    50,    31,     4,    33,     5,
       4,    36,    15,    16,   157,    11,    13,    42,    43,    22,
      23,    46,    24,    25,     4,    50,    51,    52,    53,    26,
      27,    40,    41,    30,   142,   143,   144,   145,   140,   141,
     146,   147,   193,   125,    50,    49,   189,    12,     5,   181,
      11,     4,     5,   135,     5,    15,    53,   208,     6,   202,
      13,    10,   205,    18,    17,    18,     6,   149,    14,     7,
       5,    16,     5,     7,     6,    28,    29,   220,    31,     5,
       4,     8,     4,    36,     4,     4,   218,     5,    50,    12,
      43,    13,    50,    46,   226,    17,    18,    50,    51,    52,
      53,     9,     8,     4,     4,    32,    28,    29,    15,    31,
       4,    38,     4,     4,    36,    42,    11,    44,    45,    13,
       4,    43,    11,    17,    46,    42,    32,     5,    50,    51,
      52,    53,    38,    14,    28,    29,    42,    31,    44,    45,
       8,    11,    36,     5,    11,     8,     7,     5,     5,    43,
      16,     5,    46,    12,     7,     5,    50,    51,    52,    53,
       9,     5,     5,    11,    32,     4,    42,     9,    33,    32,
      38,     5,     5,     8,    42,    38,    44,    45,     5,    42,
       9,    44,    45,    34,     7,     9,    12,     7,    48,   200,
      89,    36
};

/* YYSTOS[STATE-NUM] -- The (internal number of the) accessing
   symbol of state STATE-NUM.  */
static const yytype_uint8 yystos[] =
{
       0,    55,    56,     0,    35,    37,    47,    57,    37,    50,
      53,    50,     4,     9,     4,    50,    58,    60,    49,    58,
      12,     5,    11,     4,    13,    26,    27,    30,    53,    86,
      87,    90,     5,    86,     6,    58,     4,    86,    86,    15,
      88,    10,    18,     6,    86,    86,    89,    11,    21,    14,
      86,    86,    39,    51,    52,    86,     7,    11,     5,    86,
      86,    16,     7,    59,    86,    89,     6,     5,     5,    59,
       8,    32,    38,    42,    44,    45,    61,    85,    11,    86,
       8,     4,     4,     4,    50,    62,     4,    13,    17,    18,
      28,    29,    31,    36,    43,    46,    50,    51,    52,    53,
      68,    69,    70,    71,    72,    73,    74,    76,    77,    78,
      79,    80,    81,    82,    83,    84,     4,    86,     5,    50,
      33,    42,    63,    76,    62,    12,     9,     5,    76,    75,
      76,    70,    69,     4,     4,    15,     4,     4,    19,    20,
      17,    21,    15,    16,    22,    23,    24,    25,    76,    11,
      42,     4,     5,    11,    86,    76,     5,    11,    14,    11,
      76,    76,    86,    75,    40,    41,    67,    70,    70,    71,
      71,    84,    84,    84,    84,    73,    73,     5,    86,    62,
      62,     7,    62,    76,    75,     5,     5,    16,     5,    12,
       7,     5,     9,    11,    59,     5,     5,     4,    76,    33,
      64,    65,    67,    62,     8,     9,     5,     5,    42,    65,
       8,    76,     5,    34,    66,    76,    62,     9,     7,     9,
      48,    59,    67,    76,     8,    12,     7,    59,     8
};

#define yyerrok		(yyerrstatus = 0)
#define yyclearin	(yychar = YYEMPTY)
#define YYEMPTY		(-2)
#define YYEOF		0

#define YYACCEPT	goto yyacceptlab
#define YYABORT		goto yyabortlab
#define YYERROR		goto yyerrorlab


/* Like YYERROR except do call yyerror.  This remains here temporarily
   to ease the transition to the new meaning of YYERROR, for GCC.
   Once GCC version 2 has supplanted version 1, this can go.  */

#define YYFAIL		goto yyerrlab

#define YYRECOVERING()  (!!yyerrstatus)

#define YYBACKUP(Token, Value)					\
do								\
  if (yychar == YYEMPTY && yylen == 1)				\
    {								\
      yychar = (Token);						\
      yylval = (Value);						\
      yytoken = YYTRANSLATE (yychar);				\
      YYPOPSTACK (1);						\
      goto yybackup;						\
    }								\
  else								\
    {								\
      yyerror (YY_("syntax error: cannot back up")); \
      YYERROR;							\
    }								\
while (YYID (0))


#define YYTERROR	1
#define YYERRCODE	256


/* YYLLOC_DEFAULT -- Set CURRENT to span from RHS[1] to RHS[N].
   If N is 0, then set CURRENT to the empty location which ends
   the previous symbol: RHS[0] (always defined).  */

#define YYRHSLOC(Rhs, K) ((Rhs)[K])
#ifndef YYLLOC_DEFAULT
# define YYLLOC_DEFAULT(Current, Rhs, N)				\
    do									\
      if (YYID (N))                                                    \
	{								\
	  (Current).first_line   = YYRHSLOC (Rhs, 1).first_line;	\
	  (Current).first_column = YYRHSLOC (Rhs, 1).first_column;	\
	  (Current).last_line    = YYRHSLOC (Rhs, N).last_line;		\
	  (Current).last_column  = YYRHSLOC (Rhs, N).last_column;	\
	}								\
      else								\
	{								\
	  (Current).first_line   = (Current).last_line   =		\
	    YYRHSLOC (Rhs, 0).last_line;				\
	  (Current).first_column = (Current).last_column =		\
	    YYRHSLOC (Rhs, 0).last_column;				\
	}								\
    while (YYID (0))
#endif


/* YY_LOCATION_PRINT -- Print the location on the stream.
   This macro was not mandated originally: define only if we know
   we won't break user code: when these are the locations we know.  */

#ifndef YY_LOCATION_PRINT
# if defined YYLTYPE_IS_TRIVIAL && YYLTYPE_IS_TRIVIAL
#  define YY_LOCATION_PRINT(File, Loc)			\
     fprintf (File, "%d.%d-%d.%d",			\
	      (Loc).first_line, (Loc).first_column,	\
	      (Loc).last_line,  (Loc).last_column)
# else
#  define YY_LOCATION_PRINT(File, Loc) ((void) 0)
# endif
#endif


/* YYLEX -- calling `yylex' with the right arguments.  */

#ifdef YYLEX_PARAM
# define YYLEX yylex (YYLEX_PARAM)
#else
# define YYLEX yylex ()
#endif

/* Enable debugging if requested.  */
#if YYDEBUG

# ifndef YYFPRINTF
#  include <stdio.h> /* INFRINGES ON USER NAME SPACE */
#  define YYFPRINTF fprintf
# endif

# define YYDPRINTF(Args)			\
do {						\
  if (yydebug)					\
    YYFPRINTF Args;				\
} while (YYID (0))

# define YY_SYMBOL_PRINT(Title, Type, Value, Location)			  \
do {									  \
  if (yydebug)								  \
    {									  \
      YYFPRINTF (stderr, "%s ", Title);					  \
      yy_symbol_print (stderr,						  \
		  Type, Value); \
      YYFPRINTF (stderr, "\n");						  \
    }									  \
} while (YYID (0))


/*--------------------------------.
| Print this symbol on YYOUTPUT.  |
`--------------------------------*/

/*ARGSUSED*/
#if (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
static void
yy_symbol_value_print (FILE *yyoutput, int yytype, YYSTYPE const * const yyvaluep)
#else
static void
yy_symbol_value_print (yyoutput, yytype, yyvaluep)
    FILE *yyoutput;
    int yytype;
    YYSTYPE const * const yyvaluep;
#endif
{
  if (!yyvaluep)
    return;
# ifdef YYPRINT
  if (yytype < YYNTOKENS)
    YYPRINT (yyoutput, yytoknum[yytype], *yyvaluep);
# else
  YYUSE (yyoutput);
# endif
  switch (yytype)
    {
      default:
	break;
    }
}


/*--------------------------------.
| Print this symbol on YYOUTPUT.  |
`--------------------------------*/

#if (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
static void
yy_symbol_print (FILE *yyoutput, int yytype, YYSTYPE const * const yyvaluep)
#else
static void
yy_symbol_print (yyoutput, yytype, yyvaluep)
    FILE *yyoutput;
    int yytype;
    YYSTYPE const * const yyvaluep;
#endif
{
  if (yytype < YYNTOKENS)
    YYFPRINTF (yyoutput, "token %s (", yytname[yytype]);
  else
    YYFPRINTF (yyoutput, "nterm %s (", yytname[yytype]);

  yy_symbol_value_print (yyoutput, yytype, yyvaluep);
  YYFPRINTF (yyoutput, ")");
}

/*------------------------------------------------------------------.
| yy_stack_print -- Print the state stack from its BOTTOM up to its |
| TOP (included).                                                   |
`------------------------------------------------------------------*/

#if (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
static void
yy_stack_print (yytype_int16 *bottom, yytype_int16 *top)
#else
static void
yy_stack_print (bottom, top)
    yytype_int16 *bottom;
    yytype_int16 *top;
#endif
{
  YYFPRINTF (stderr, "Stack now");
  for (; bottom <= top; ++bottom)
    YYFPRINTF (stderr, " %d", *bottom);
  YYFPRINTF (stderr, "\n");
}

# define YY_STACK_PRINT(Bottom, Top)				\
do {								\
  if (yydebug)							\
    yy_stack_print ((Bottom), (Top));				\
} while (YYID (0))


/*------------------------------------------------.
| Report that the YYRULE is going to be reduced.  |
`------------------------------------------------*/

#if (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
static void
yy_reduce_print (YYSTYPE *yyvsp, int yyrule)
#else
static void
yy_reduce_print (yyvsp, yyrule)
    YYSTYPE *yyvsp;
    int yyrule;
#endif
{
  int yynrhs = yyr2[yyrule];
  int yyi;
  unsigned long int yylno = yyrline[yyrule];
  YYFPRINTF (stderr, "Reducing stack by rule %d (line %lu):\n",
	     yyrule - 1, yylno);
  /* The symbols being reduced.  */
  for (yyi = 0; yyi < yynrhs; yyi++)
    {
      fprintf (stderr, "   $%d = ", yyi + 1);
      yy_symbol_print (stderr, yyrhs[yyprhs[yyrule] + yyi],
		       &(yyvsp[(yyi + 1) - (yynrhs)])
		       		       );
      fprintf (stderr, "\n");
    }
}

# define YY_REDUCE_PRINT(Rule)		\
do {					\
  if (yydebug)				\
    yy_reduce_print (yyvsp, Rule); \
} while (YYID (0))

/* Nonzero means print parse trace.  It is left uninitialized so that
   multiple parsers can coexist.  */
int yydebug;
#else /* !YYDEBUG */
# define YYDPRINTF(Args)
# define YY_SYMBOL_PRINT(Title, Type, Value, Location)
# define YY_STACK_PRINT(Bottom, Top)
# define YY_REDUCE_PRINT(Rule)
#endif /* !YYDEBUG */


/* YYINITDEPTH -- initial size of the parser's stacks.  */
#ifndef	YYINITDEPTH
# define YYINITDEPTH 200
#endif

/* YYMAXDEPTH -- maximum size the stacks can grow to (effective only
   if the built-in stack extension method is used).

   Do not make this value too large; the results are undefined if
   YYSTACK_ALLOC_MAXIMUM < YYSTACK_BYTES (YYMAXDEPTH)
   evaluated with infinite-precision integer arithmetic.  */

#ifndef YYMAXDEPTH
# define YYMAXDEPTH 10000
#endif



#if YYERROR_VERBOSE

# ifndef yystrlen
#  if defined __GLIBC__ && defined _STRING_H
#   define yystrlen strlen
#  else
/* Return the length of YYSTR.  */
#if (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
static YYSIZE_T
yystrlen (const char *yystr)
#else
static YYSIZE_T
yystrlen (yystr)
    const char *yystr;
#endif
{
  YYSIZE_T yylen;
  for (yylen = 0; yystr[yylen]; yylen++)
    continue;
  return yylen;
}
#  endif
# endif

# ifndef yystpcpy
#  if defined __GLIBC__ && defined _STRING_H && defined _GNU_SOURCE
#   define yystpcpy stpcpy
#  else
/* Copy YYSRC to YYDEST, returning the address of the terminating '\0' in
   YYDEST.  */
#if (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
static char *
yystpcpy (char *yydest, const char *yysrc)
#else
static char *
yystpcpy (yydest, yysrc)
    char *yydest;
    const char *yysrc;
#endif
{
  char *yyd = yydest;
  const char *yys = yysrc;

  while ((*yyd++ = *yys++) != '\0')
    continue;

  return yyd - 1;
}
#  endif
# endif

# ifndef yytnamerr
/* Copy to YYRES the contents of YYSTR after stripping away unnecessary
   quotes and backslashes, so that it's suitable for yyerror.  The
   heuristic is that double-quoting is unnecessary unless the string
   contains an apostrophe, a comma, or backslash (other than
   backslash-backslash).  YYSTR is taken from yytname.  If YYRES is
   null, do not copy; instead, return the length of what the result
   would have been.  */
static YYSIZE_T
yytnamerr (char *yyres, const char *yystr)
{
  if (*yystr == '"')
    {
      YYSIZE_T yyn = 0;
      char const *yyp = yystr;

      for (;;)
	switch (*++yyp)
	  {
	  case '\'':
	  case ',':
	    goto do_not_strip_quotes;

	  case '\\':
	    if (*++yyp != '\\')
	      goto do_not_strip_quotes;
	    /* Fall through.  */
	  default:
	    if (yyres)
	      yyres[yyn] = *yyp;
	    yyn++;
	    break;

	  case '"':
	    if (yyres)
	      yyres[yyn] = '\0';
	    return yyn;
	  }
    do_not_strip_quotes: ;
    }

  if (! yyres)
    return yystrlen (yystr);

  return yystpcpy (yyres, yystr) - yyres;
}
# endif

/* Copy into YYRESULT an error message about the unexpected token
   YYCHAR while in state YYSTATE.  Return the number of bytes copied,
   including the terminating null byte.  If YYRESULT is null, do not
   copy anything; just return the number of bytes that would be
   copied.  As a special case, return 0 if an ordinary "syntax error"
   message will do.  Return YYSIZE_MAXIMUM if overflow occurs during
   size calculation.  */
static YYSIZE_T
yysyntax_error (char *yyresult, int yystate, int yychar)
{
  int yyn = yypact[yystate];

  if (! (YYPACT_NINF < yyn && yyn <= YYLAST))
    return 0;
  else
    {
      int yytype = YYTRANSLATE (yychar);
      YYSIZE_T yysize0 = yytnamerr (0, yytname[yytype]);
      YYSIZE_T yysize = yysize0;
      YYSIZE_T yysize1;
      int yysize_overflow = 0;
      enum { YYERROR_VERBOSE_ARGS_MAXIMUM = 5 };
      char const *yyarg[YYERROR_VERBOSE_ARGS_MAXIMUM];
      int yyx;

# if 0
      /* This is so xgettext sees the translatable formats that are
	 constructed on the fly.  */
      YY_("syntax error, unexpected %s");
      YY_("syntax error, unexpected %s, expecting %s");
      YY_("syntax error, unexpected %s, expecting %s or %s");
      YY_("syntax error, unexpected %s, expecting %s or %s or %s");
      YY_("syntax error, unexpected %s, expecting %s or %s or %s or %s");
# endif
      char *yyfmt;
      char const *yyf;
      static char const yyunexpected[] = "syntax error, unexpected %s";
      static char const yyexpecting[] = ", expecting %s";
      static char const yyor[] = " or %s";
      char yyformat[sizeof yyunexpected
		    + sizeof yyexpecting - 1
		    + ((YYERROR_VERBOSE_ARGS_MAXIMUM - 2)
		       * (sizeof yyor - 1))];
      char const *yyprefix = yyexpecting;

      /* Start YYX at -YYN if negative to avoid negative indexes in
	 YYCHECK.  */
      int yyxbegin = yyn < 0 ? -yyn : 0;

      /* Stay within bounds of both yycheck and yytname.  */
      int yychecklim = YYLAST - yyn + 1;
      int yyxend = yychecklim < YYNTOKENS ? yychecklim : YYNTOKENS;
      int yycount = 1;

      yyarg[0] = yytname[yytype];
      yyfmt = yystpcpy (yyformat, yyunexpected);

      for (yyx = yyxbegin; yyx < yyxend; ++yyx)
	if (yycheck[yyx + yyn] == yyx && yyx != YYTERROR)
	  {
	    if (yycount == YYERROR_VERBOSE_ARGS_MAXIMUM)
	      {
		yycount = 1;
		yysize = yysize0;
		yyformat[sizeof yyunexpected - 1] = '\0';
		break;
	      }
	    yyarg[yycount++] = yytname[yyx];
	    yysize1 = yysize + yytnamerr (0, yytname[yyx]);
	    yysize_overflow |= (yysize1 < yysize);
	    yysize = yysize1;
	    yyfmt = yystpcpy (yyfmt, yyprefix);
	    yyprefix = yyor;
	  }

      yyf = YY_(yyformat);
      yysize1 = yysize + yystrlen (yyf);
      yysize_overflow |= (yysize1 < yysize);
      yysize = yysize1;

      if (yysize_overflow)
	return YYSIZE_MAXIMUM;

      if (yyresult)
	{
	  /* Avoid sprintf, as that infringes on the user's name space.
	     Don't have undefined behavior even if the translation
	     produced a string with the wrong number of "%s"s.  */
	  char *yyp = yyresult;
	  int yyi = 0;
	  while ((*yyp = *yyf) != '\0')
	    {
	      if (*yyp == '%' && yyf[1] == 's' && yyi < yycount)
		{
		  yyp += yytnamerr (yyp, yyarg[yyi++]);
		  yyf += 2;
		}
	      else
		{
		  yyp++;
		  yyf++;
		}
	    }
	}
      return yysize;
    }
}
#endif /* YYERROR_VERBOSE */


/*-----------------------------------------------.
| Release the memory associated to this symbol.  |
`-----------------------------------------------*/

/*ARGSUSED*/
#if (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
static void
yydestruct (const char *yymsg, int yytype, YYSTYPE *yyvaluep)
#else
static void
yydestruct (yymsg, yytype, yyvaluep)
    const char *yymsg;
    int yytype;
    YYSTYPE *yyvaluep;
#endif
{
  YYUSE (yyvaluep);

  if (!yymsg)
    yymsg = "Deleting";
  YY_SYMBOL_PRINT (yymsg, yytype, yyvaluep, yylocationp);

  switch (yytype)
    {

      default:
	break;
    }
}


/* Prevent warnings from -Wmissing-prototypes.  */

#ifdef YYPARSE_PARAM
#if defined __STDC__ || defined __cplusplus
int yyparse (void *YYPARSE_PARAM);
#else
int yyparse ();
#endif
#else /* ! YYPARSE_PARAM */
#if defined __STDC__ || defined __cplusplus
int yyparse (void);
#else
int yyparse ();
#endif
#endif /* ! YYPARSE_PARAM */



/* The look-ahead symbol.  */
int yychar;

/* The semantic value of the look-ahead symbol.  */
YYSTYPE yylval;

/* Number of syntax errors so far.  */
int yynerrs;



/*----------.
| yyparse.  |
`----------*/

#ifdef YYPARSE_PARAM
#if (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
int
yyparse (void *YYPARSE_PARAM)
#else
int
yyparse (YYPARSE_PARAM)
    void *YYPARSE_PARAM;
#endif
#else /* ! YYPARSE_PARAM */
#if (defined __STDC__ || defined __C99__FUNC__ \
     || defined __cplusplus || defined _MSC_VER)
int
yyparse (void)
#else
int
yyparse ()

#endif
#endif
{
  
  int yystate;
  int yyn;
  int yyresult;
  /* Number of tokens to shift before error messages enabled.  */
  int yyerrstatus;
  /* Look-ahead token as an internal (translated) token number.  */
  int yytoken = 0;
#if YYERROR_VERBOSE
  /* Buffer for error messages, and its allocated size.  */
  char yymsgbuf[128];
  char *yymsg = yymsgbuf;
  YYSIZE_T yymsg_alloc = sizeof yymsgbuf;
#endif

  /* Three stacks and their tools:
     `yyss': related to states,
     `yyvs': related to semantic values,
     `yyls': related to locations.

     Refer to the stacks thru separate pointers, to allow yyoverflow
     to reallocate them elsewhere.  */

  /* The state stack.  */
  yytype_int16 yyssa[YYINITDEPTH];
  yytype_int16 *yyss = yyssa;
  yytype_int16 *yyssp;

  /* The semantic value stack.  */
  YYSTYPE yyvsa[YYINITDEPTH];
  YYSTYPE *yyvs = yyvsa;
  YYSTYPE *yyvsp;



#define YYPOPSTACK(N)   (yyvsp -= (N), yyssp -= (N))

  YYSIZE_T yystacksize = YYINITDEPTH;

  /* The variables used to return semantic value and location from the
     action routines.  */
  YYSTYPE yyval;


  /* The number of symbols on the RHS of the reduced rule.
     Keep to zero when no symbol should be popped.  */
  int yylen = 0;

  YYDPRINTF ((stderr, "Starting parse\n"));

  yystate = 0;
  yyerrstatus = 0;
  yynerrs = 0;
  yychar = YYEMPTY;		/* Cause a token to be read.  */

  /* Initialize stack pointers.
     Waste one element of value and location stack
     so that they stay on the same level as the state stack.
     The wasted elements are never initialized.  */

  yyssp = yyss;
  yyvsp = yyvs;

  goto yysetstate;

/*------------------------------------------------------------.
| yynewstate -- Push a new state, which is found in yystate.  |
`------------------------------------------------------------*/
 yynewstate:
  /* In all cases, when you get here, the value and location stacks
     have just been pushed.  So pushing a state here evens the stacks.  */
  yyssp++;

 yysetstate:
  *yyssp = yystate;

  if (yyss + yystacksize - 1 <= yyssp)
    {
      /* Get the current used size of the three stacks, in elements.  */
      YYSIZE_T yysize = yyssp - yyss + 1;

#ifdef yyoverflow
      {
	/* Give user a chance to reallocate the stack.  Use copies of
	   these so that the &'s don't force the real ones into
	   memory.  */
	YYSTYPE *yyvs1 = yyvs;
	yytype_int16 *yyss1 = yyss;


	/* Each stack pointer address is followed by the size of the
	   data in use in that stack, in bytes.  This used to be a
	   conditional around just the two extra args, but that might
	   be undefined if yyoverflow is a macro.  */
	yyoverflow (YY_("memory exhausted"),
		    &yyss1, yysize * sizeof (*yyssp),
		    &yyvs1, yysize * sizeof (*yyvsp),

		    &yystacksize);

	yyss = yyss1;
	yyvs = yyvs1;
      }
#else /* no yyoverflow */
# ifndef YYSTACK_RELOCATE
      goto yyexhaustedlab;
# else
      /* Extend the stack our own way.  */
      if (YYMAXDEPTH <= yystacksize)
	goto yyexhaustedlab;
      yystacksize *= 2;
      if (YYMAXDEPTH < yystacksize)
	yystacksize = YYMAXDEPTH;

      {
	yytype_int16 *yyss1 = yyss;
	union yyalloc *yyptr =
	  (union yyalloc *) YYSTACK_ALLOC (YYSTACK_BYTES (yystacksize));
	if (! yyptr)
	  goto yyexhaustedlab;
	YYSTACK_RELOCATE (yyss);
	YYSTACK_RELOCATE (yyvs);

#  undef YYSTACK_RELOCATE
	if (yyss1 != yyssa)
	  YYSTACK_FREE (yyss1);
      }
# endif
#endif /* no yyoverflow */

      yyssp = yyss + yysize - 1;
      yyvsp = yyvs + yysize - 1;


      YYDPRINTF ((stderr, "Stack size increased to %lu\n",
		  (unsigned long int) yystacksize));

      if (yyss + yystacksize - 1 <= yyssp)
	YYABORT;
    }

  YYDPRINTF ((stderr, "Entering state %d\n", yystate));

  goto yybackup;

/*-----------.
| yybackup.  |
`-----------*/
yybackup:

  /* Do appropriate processing given the current state.  Read a
     look-ahead token if we need one and don't already have one.  */

  /* First try to decide what to do without reference to look-ahead token.  */
  yyn = yypact[yystate];
  if (yyn == YYPACT_NINF)
    goto yydefault;

  /* Not known => get a look-ahead token if don't already have one.  */

  /* YYCHAR is either YYEMPTY or YYEOF or a valid look-ahead symbol.  */
  if (yychar == YYEMPTY)
    {
      YYDPRINTF ((stderr, "Reading a token: "));
      yychar = YYLEX;
    }

  if (yychar <= YYEOF)
    {
      yychar = yytoken = YYEOF;
      YYDPRINTF ((stderr, "Now at end of input.\n"));
    }
  else
    {
      yytoken = YYTRANSLATE (yychar);
      YY_SYMBOL_PRINT ("Next token is", yytoken, &yylval, &yylloc);
    }

  /* If the proper action on seeing token YYTOKEN is to reduce or to
     detect an error, take that action.  */
  yyn += yytoken;
  if (yyn < 0 || YYLAST < yyn || yycheck[yyn] != yytoken)
    goto yydefault;
  yyn = yytable[yyn];
  if (yyn <= 0)
    {
      if (yyn == 0 || yyn == YYTABLE_NINF)
	goto yyerrlab;
      yyn = -yyn;
      goto yyreduce;
    }

  if (yyn == YYFINAL)
    YYACCEPT;

  /* Count tokens shifted since error; after three, turn off error
     status.  */
  if (yyerrstatus)
    yyerrstatus--;

  /* Shift the look-ahead token.  */
  YY_SYMBOL_PRINT ("Shifting", yytoken, &yylval, &yylloc);

  /* Discard the shifted token unless it is eof.  */
  if (yychar != YYEOF)
    yychar = YYEMPTY;

  yystate = yyn;
  *++yyvsp = yylval;

  goto yynewstate;


/*-----------------------------------------------------------.
| yydefault -- do the default action for the current state.  |
`-----------------------------------------------------------*/
yydefault:
  yyn = yydefact[yystate];
  if (yyn == 0)
    goto yyerrlab;
  goto yyreduce;


/*-----------------------------.
| yyreduce -- Do a reduction.  |
`-----------------------------*/
yyreduce:
  /* yyn is the number of a rule to reduce with.  */
  yylen = yyr2[yyn];

  /* If YYLEN is nonzero, implement the default value of the action:
     `$$ = $1'.

     Otherwise, the following line sets YYVAL to garbage.
     This behavior is undocumented and Bison
     users should not rely upon it.  Assigning to YYVAL
     unconditionally makes the parser a bit smaller, and it avoids a
     GCC warning that YYVAL may be used uninitialized.  */
  yyval = yyvsp[1-yylen];


  YY_REDUCE_PRINT (yyn);
  switch (yyn)
    {
        case 2:
#line 517 "Grammar.y"
    { (yyval.program_) = make_ProgramDefs(reverseListDef((yyvsp[(1) - (1)].listdef_))); YY_RESULT_Program_= (yyval.program_); ;}
    break;

  case 3:
#line 519 "Grammar.y"
    { (yyval.listdef_) = 0; YY_RESULT_ListDef_= (yyval.listdef_); ;}
    break;

  case 4:
#line 520 "Grammar.y"
    { (yyval.listdef_) = make_ListDef((yyvsp[(2) - (2)].def_), (yyvsp[(1) - (2)].listdef_)); YY_RESULT_ListDef_= (yyval.listdef_); ;}
    break;

  case 5:
#line 522 "Grammar.y"
    { (yyval.def_) = make_DefFun((yyvsp[(2) - (10)].string_), (yyvsp[(4) - (10)].listarg_), (yyvsp[(7) - (10)].type_), reverseListStm((yyvsp[(9) - (10)].liststm_))); YY_RESULT_Def_= (yyval.def_); ;}
    break;

  case 6:
#line 523 "Grammar.y"
    { (yyval.def_) = make_DefFunExposed((yyvsp[(3) - (11)].string_), (yyvsp[(5) - (11)].listarg_), (yyvsp[(8) - (11)].type_), reverseListStm((yyvsp[(10) - (11)].liststm_))); YY_RESULT_Def_= (yyval.def_); ;}
    break;

  case 7:
#line 524 "Grammar.y"
    { (yyval.def_) = make_DefTypedef((yyvsp[(2) - (7)].string_), (yyvsp[(5) - (7)].type_), (yyvsp[(7) - (7)].type_)); YY_RESULT_Def_= (yyval.def_); ;}
    break;

  case 8:
#line 526 "Grammar.y"
    { (yyval.listarg_) = 0; YY_RESULT_ListArg_= (yyval.listarg_); ;}
    break;

  case 9:
#line 527 "Grammar.y"
    { (yyval.listarg_) = make_ListArg((yyvsp[(1) - (1)].arg_), 0); YY_RESULT_ListArg_= (yyval.listarg_); ;}
    break;

  case 10:
#line 528 "Grammar.y"
    { (yyval.listarg_) = make_ListArg((yyvsp[(1) - (3)].arg_), (yyvsp[(3) - (3)].listarg_)); YY_RESULT_ListArg_= (yyval.listarg_); ;}
    break;

  case 11:
#line 530 "Grammar.y"
    { (yyval.liststm_) = 0; YY_RESULT_ListStm_= (yyval.liststm_); ;}
    break;

  case 12:
#line 531 "Grammar.y"
    { (yyval.liststm_) = make_ListStm((yyvsp[(2) - (2)].stm_), (yyvsp[(1) - (2)].liststm_)); YY_RESULT_ListStm_= (yyval.liststm_); ;}
    break;

  case 13:
#line 533 "Grammar.y"
    { (yyval.arg_) = make_ArgDecl((yyvsp[(1) - (3)].string_), (yyvsp[(3) - (3)].type_)); YY_RESULT_Arg_= (yyval.arg_); ;}
    break;

  case 14:
#line 535 "Grammar.y"
    { (yyval.stm_) = make_StmInit((yyvsp[(2) - (4)].idmaybetyped_), (yyvsp[(4) - (4)].exp_)); YY_RESULT_Stm_= (yyval.stm_); ;}
    break;

  case 15:
#line 536 "Grammar.y"
    { (yyval.stm_) = make_StmSplit((yyvsp[(3) - (8)].idmaybetyped_), (yyvsp[(5) - (8)].idmaybetyped_), (yyvsp[(8) - (8)].exp_)); YY_RESULT_Stm_= (yyval.stm_); ;}
    break;

  case 16:
#line 537 "Grammar.y"
    { (yyval.stm_) = make_StmIfElse((yyvsp[(3) - (8)].ifcond_), reverseListStm((yyvsp[(6) - (8)].liststm_)), (yyvsp[(8) - (8)].else_)); YY_RESULT_Stm_= (yyval.stm_); ;}
    break;

  case 17:
#line 538 "Grammar.y"
    { (yyval.stm_) = make_StmSwitch((yyvsp[(3) - (7)].exp_), (yyvsp[(6) - (7)].listswitchcase_)); YY_RESULT_Stm_= (yyval.stm_); ;}
    break;

  case 18:
#line 539 "Grammar.y"
    { (yyval.stm_) = make_StmReturn((yyvsp[(2) - (2)].exp_)); YY_RESULT_Stm_= (yyval.stm_); ;}
    break;

  case 19:
#line 540 "Grammar.y"
    { (yyval.stm_) = make_StmAssert((yyvsp[(1) - (1)].assertion_)); YY_RESULT_Stm_= (yyval.stm_); ;}
    break;

  case 20:
#line 542 "Grammar.y"
    { (yyval.idmaybetyped_) = make_IdMaybeTypedNotTyped((yyvsp[(1) - (1)].string_)); YY_RESULT_IdMaybeTyped_= (yyval.idmaybetyped_); ;}
    break;

  case 21:
#line 543 "Grammar.y"
    { (yyval.idmaybetyped_) = make_IdMaybeTypedTyped((yyvsp[(1) - (3)].string_), (yyvsp[(3) - (3)].type_)); YY_RESULT_IdMaybeTyped_= (yyval.idmaybetyped_); ;}
    break;

  case 22:
#line 545 "Grammar.y"
    { (yyval.ifcond_) = make_IfCondCase((yyvsp[(3) - (6)].idmaybetyped_), (yyvsp[(5) - (6)].case_), (yyvsp[(6) - (6)].exp_)); YY_RESULT_IfCond_= (yyval.ifcond_); ;}
    break;

  case 23:
#line 546 "Grammar.y"
    { (yyval.ifcond_) = make_IfCondBool((yyvsp[(1) - (1)].exp_)); YY_RESULT_IfCond_= (yyval.ifcond_); ;}
    break;

  case 24:
#line 547 "Grammar.y"
    { (yyval.ifcond_) = make_IfCondUnfold((yyvsp[(3) - (9)].idmaybetyped_), (yyvsp[(5) - (9)].idmaybetyped_), (yyvsp[(9) - (9)].exp_)); YY_RESULT_IfCond_= (yyval.ifcond_); ;}
    break;

  case 25:
#line 549 "Grammar.y"
    { (yyval.switchcase_) = make_SwitchCaseDefault((yyvsp[(3) - (9)].idmaybetyped_), (yyvsp[(5) - (9)].case_), reverseListStm((yyvsp[(8) - (9)].liststm_))); YY_RESULT_SwitchCase_= (yyval.switchcase_); ;}
    break;

  case 26:
#line 551 "Grammar.y"
    { (yyval.listswitchcase_) = make_ListSwitchCase((yyvsp[(1) - (1)].switchcase_), 0); YY_RESULT_ListSwitchCase_= (yyval.listswitchcase_); ;}
    break;

  case 27:
#line 552 "Grammar.y"
    { (yyval.listswitchcase_) = make_ListSwitchCase((yyvsp[(1) - (2)].switchcase_), (yyvsp[(2) - (2)].listswitchcase_)); YY_RESULT_ListSwitchCase_= (yyval.listswitchcase_); ;}
    break;

  case 28:
#line 554 "Grammar.y"
    { (yyval.else_) = make_ElseNone(); YY_RESULT_Else_= (yyval.else_); ;}
    break;

  case 29:
#line 555 "Grammar.y"
    { (yyval.else_) = make_ElseStms(reverseListStm((yyvsp[(3) - (4)].liststm_))); YY_RESULT_Else_= (yyval.else_); ;}
    break;

  case 30:
#line 557 "Grammar.y"
    { (yyval.case_) = make_Case_inl(); YY_RESULT_Case_= (yyval.case_); ;}
    break;

  case 31:
#line 558 "Grammar.y"
    { (yyval.case_) = make_Case_inr(); YY_RESULT_Case_= (yyval.case_); ;}
    break;

  case 32:
#line 560 "Grammar.y"
    { (yyval.exp_) = make_ExpInt((yyvsp[(1) - (1)].int_)); YY_RESULT_Exp_= (yyval.exp_); ;}
    break;

  case 33:
#line 561 "Grammar.y"
    { (yyval.exp_) = make_ExpDouble((yyvsp[(1) - (1)].double_)); YY_RESULT_Exp_= (yyval.exp_); ;}
    break;

  case 34:
#line 562 "Grammar.y"
    { (yyval.exp_) = make_ExpUnit(); YY_RESULT_Exp_= (yyval.exp_); ;}
    break;

  case 35:
#line 563 "Grammar.y"
    { (yyval.exp_) = make_ExpTrue(); YY_RESULT_Exp_= (yyval.exp_); ;}
    break;

  case 36:
#line 564 "Grammar.y"
    { (yyval.exp_) = make_ExpFalse(); YY_RESULT_Exp_= (yyval.exp_); ;}
    break;

  case 37:
#line 565 "Grammar.y"
    { (yyval.exp_) = make_ExpOption((yyvsp[(3) - (4)].exp_)); YY_RESULT_Exp_= (yyval.exp_); ;}
    break;

  case 38:
#line 566 "Grammar.y"
    { (yyval.exp_) = make_ExpNothing(); YY_RESULT_Exp_= (yyval.exp_); ;}
    break;

  case 39:
#line 567 "Grammar.y"
    { (yyval.exp_) = make_ExpId((yyvsp[(1) - (1)].string_)); YY_RESULT_Exp_= (yyval.exp_); ;}
    break;

  case 40:
#line 568 "Grammar.y"
    { (yyval.exp_) = make_ExpPair((yyvsp[(2) - (5)].exp_), (yyvsp[(4) - (5)].exp_)); YY_RESULT_Exp_= (yyval.exp_); ;}
    break;

  case 41:
#line 569 "Grammar.y"
    { (yyval.exp_) = make_ExpSum((yyvsp[(1) - (6)].string_), (yyvsp[(3) - (6)].case_), (yyvsp[(5) - (6)].exp_)); YY_RESULT_Exp_= (yyval.exp_); ;}
    break;

  case 42:
#line 570 "Grammar.y"
    { (yyval.exp_) = make_ExpList((yyvsp[(2) - (3)].listexp_)); YY_RESULT_Exp_= (yyval.exp_); ;}
    break;

  case 43:
#line 571 "Grammar.y"
    { (yyval.exp_) = make_ExpRef((yyvsp[(3) - (6)].type_)); YY_RESULT_Exp_= (yyval.exp_); ;}
    break;

  case 44:
#line 572 "Grammar.y"
    { (yyval.exp_) = make_ExpApp((yyvsp[(1) - (4)].string_), (yyvsp[(3) - (4)].listexp_)); YY_RESULT_Exp_= (yyval.exp_); ;}
    break;

  case 45:
#line 573 "Grammar.y"
    { (yyval.exp_) = make_ExpNoising((yyvsp[(3) - (4)].exp_)); YY_RESULT_Exp_= (yyval.exp_); ;}
    break;

  case 46:
#line 574 "Grammar.y"
    { (yyval.exp_) = (yyvsp[(2) - (3)].exp_); YY_RESULT_Exp_= (yyval.exp_); ;}
    break;

  case 47:
#line 576 "Grammar.y"
    { (yyval.exp_) = make_ExpNegative((yyvsp[(2) - (2)].exp_)); YY_RESULT_Exp_= (yyval.exp_); ;}
    break;

  case 48:
#line 577 "Grammar.y"
    { (yyval.exp_) = (yyvsp[(1) - (1)].exp_); YY_RESULT_Exp_= (yyval.exp_); ;}
    break;

  case 49:
#line 579 "Grammar.y"
    { (yyval.exp_) = make_ExpNot((yyvsp[(2) - (2)].exp_)); YY_RESULT_Exp_= (yyval.exp_); ;}
    break;

  case 50:
#line 580 "Grammar.y"
    { (yyval.exp_) = (yyvsp[(1) - (1)].exp_); YY_RESULT_Exp_= (yyval.exp_); ;}
    break;

  case 51:
#line 582 "Grammar.y"
    { (yyval.exp_) = make_ExpTimes((yyvsp[(1) - (3)].exp_), (yyvsp[(3) - (3)].exp_)); YY_RESULT_Exp_= (yyval.exp_); ;}
    break;

  case 52:
#line 583 "Grammar.y"
    { (yyval.exp_) = make_ExpDiv((yyvsp[(1) - (3)].exp_), (yyvsp[(3) - (3)].exp_)); YY_RESULT_Exp_= (yyval.exp_); ;}
    break;

  case 53:
#line 584 "Grammar.y"
    { (yyval.exp_) = (yyvsp[(1) - (1)].exp_); YY_RESULT_Exp_= (yyval.exp_); ;}
    break;

  case 54:
#line 586 "Grammar.y"
    { (yyval.exp_) = make_ExpPlus((yyvsp[(1) - (3)].exp_), (yyvsp[(3) - (3)].exp_)); YY_RESULT_Exp_= (yyval.exp_); ;}
    break;

  case 55:
#line 587 "Grammar.y"
    { (yyval.exp_) = make_ExpMinus((yyvsp[(1) - (3)].exp_), (yyvsp[(3) - (3)].exp_)); YY_RESULT_Exp_= (yyval.exp_); ;}
    break;

  case 56:
#line 588 "Grammar.y"
    { (yyval.exp_) = (yyvsp[(1) - (1)].exp_); YY_RESULT_Exp_= (yyval.exp_); ;}
    break;

  case 57:
#line 590 "Grammar.y"
    { (yyval.exp_) = make_ExpLt((yyvsp[(1) - (3)].exp_), (yyvsp[(3) - (3)].exp_)); YY_RESULT_Exp_= (yyval.exp_); ;}
    break;

  case 58:
#line 591 "Grammar.y"
    { (yyval.exp_) = make_ExpGt((yyvsp[(1) - (3)].exp_), (yyvsp[(3) - (3)].exp_)); YY_RESULT_Exp_= (yyval.exp_); ;}
    break;

  case 59:
#line 592 "Grammar.y"
    { (yyval.exp_) = make_ExpLtEq((yyvsp[(1) - (3)].exp_), (yyvsp[(3) - (3)].exp_)); YY_RESULT_Exp_= (yyval.exp_); ;}
    break;

  case 60:
#line 593 "Grammar.y"
    { (yyval.exp_) = make_ExpGtEq((yyvsp[(1) - (3)].exp_), (yyvsp[(3) - (3)].exp_)); YY_RESULT_Exp_= (yyval.exp_); ;}
    break;

  case 61:
#line 594 "Grammar.y"
    { (yyval.exp_) = (yyvsp[(1) - (1)].exp_); YY_RESULT_Exp_= (yyval.exp_); ;}
    break;

  case 62:
#line 596 "Grammar.y"
    { (yyval.exp_) = make_ExpEq((yyvsp[(1) - (3)].exp_), (yyvsp[(3) - (3)].exp_)); YY_RESULT_Exp_= (yyval.exp_); ;}
    break;

  case 63:
#line 597 "Grammar.y"
    { (yyval.exp_) = make_ExpNeq((yyvsp[(1) - (3)].exp_), (yyvsp[(3) - (3)].exp_)); YY_RESULT_Exp_= (yyval.exp_); ;}
    break;

  case 64:
#line 598 "Grammar.y"
    { (yyval.exp_) = (yyvsp[(1) - (1)].exp_); YY_RESULT_Exp_= (yyval.exp_); ;}
    break;

  case 65:
#line 600 "Grammar.y"
    { (yyval.listexp_) = 0; YY_RESULT_ListExp_= (yyval.listexp_); ;}
    break;

  case 66:
#line 601 "Grammar.y"
    { (yyval.listexp_) = make_ListExp((yyvsp[(1) - (1)].exp_), 0); YY_RESULT_ListExp_= (yyval.listexp_); ;}
    break;

  case 67:
#line 602 "Grammar.y"
    { (yyval.listexp_) = make_ListExp((yyvsp[(1) - (3)].exp_), (yyvsp[(3) - (3)].listexp_)); YY_RESULT_ListExp_= (yyval.listexp_); ;}
    break;

  case 68:
#line 604 "Grammar.y"
    { (yyval.exp_) = (yyvsp[(1) - (1)].exp_); YY_RESULT_Exp_= (yyval.exp_); ;}
    break;

  case 69:
#line 606 "Grammar.y"
    { (yyval.exp_) = (yyvsp[(1) - (1)].exp_); YY_RESULT_Exp_= (yyval.exp_); ;}
    break;

  case 70:
#line 608 "Grammar.y"
    { (yyval.exp_) = (yyvsp[(1) - (1)].exp_); YY_RESULT_Exp_= (yyval.exp_); ;}
    break;

  case 71:
#line 610 "Grammar.y"
    { (yyval.exp_) = (yyvsp[(1) - (1)].exp_); YY_RESULT_Exp_= (yyval.exp_); ;}
    break;

  case 72:
#line 612 "Grammar.y"
    { (yyval.exp_) = (yyvsp[(1) - (1)].exp_); YY_RESULT_Exp_= (yyval.exp_); ;}
    break;

  case 73:
#line 614 "Grammar.y"
    { (yyval.exp_) = (yyvsp[(1) - (1)].exp_); YY_RESULT_Exp_= (yyval.exp_); ;}
    break;

  case 74:
#line 616 "Grammar.y"
    { (yyval.exp_) = (yyvsp[(1) - (1)].exp_); YY_RESULT_Exp_= (yyval.exp_); ;}
    break;

  case 75:
#line 618 "Grammar.y"
    { (yyval.exp_) = (yyvsp[(1) - (1)].exp_); YY_RESULT_Exp_= (yyval.exp_); ;}
    break;

  case 76:
#line 620 "Grammar.y"
    { (yyval.exp_) = (yyvsp[(1) - (1)].exp_); YY_RESULT_Exp_= (yyval.exp_); ;}
    break;

  case 77:
#line 622 "Grammar.y"
    { (yyval.assertion_) = make_AssertionTypeEqual((yyvsp[(3) - (6)].string_), (yyvsp[(5) - (6)].type_)); YY_RESULT_Assertion_= (yyval.assertion_); ;}
    break;

  case 78:
#line 624 "Grammar.y"
    { (yyval.type_) = make_TypeInitDouble((yyvsp[(1) - (3)].coretype_), (yyvsp[(3) - (3)].double_)); YY_RESULT_Type_= (yyval.type_); ;}
    break;

  case 79:
#line 625 "Grammar.y"
    { (yyval.type_) = make_TypeInitInt((yyvsp[(1) - (3)].coretype_), (yyvsp[(3) - (3)].int_)); YY_RESULT_Type_= (yyval.type_); ;}
    break;

  case 80:
#line 626 "Grammar.y"
    { (yyval.type_) = make_TypeExponential((yyvsp[(1) - (3)].coretype_)); YY_RESULT_Type_= (yyval.type_); ;}
    break;

  case 81:
#line 628 "Grammar.y"
    { (yyval.coretype_) = make_CoreTypeBase((yyvsp[(1) - (1)].basetype_)); YY_RESULT_CoreType_= (yyval.coretype_); ;}
    break;

  case 82:
#line 629 "Grammar.y"
    { (yyval.coretype_) = make_CoreTypeMulPair((yyvsp[(2) - (5)].type_), (yyvsp[(4) - (5)].type_)); YY_RESULT_CoreType_= (yyval.coretype_); ;}
    break;

  case 83:
#line 630 "Grammar.y"
    { (yyval.coretype_) = make_CoreTypeSum((yyvsp[(2) - (5)].type_), (yyvsp[(4) - (5)].type_)); YY_RESULT_CoreType_= (yyval.coretype_); ;}
    break;

  case 84:
#line 631 "Grammar.y"
    { (yyval.coretype_) = make_CoreTypeList((yyvsp[(2) - (3)].type_)); YY_RESULT_CoreType_= (yyval.coretype_); ;}
    break;

  case 85:
#line 632 "Grammar.y"
    { (yyval.coretype_) = make_CoreTypeNamed((yyvsp[(1) - (2)].string_), (yyvsp[(2) - (2)].generics_)); YY_RESULT_CoreType_= (yyval.coretype_); ;}
    break;

  case 86:
#line 633 "Grammar.y"
    { (yyval.coretype_) = make_CoreTypeFunction((yyvsp[(3) - (7)].listtype_), (yyvsp[(6) - (7)].type_)); YY_RESULT_CoreType_= (yyval.coretype_); ;}
    break;

  case 87:
#line 635 "Grammar.y"
    { (yyval.generics_) = make_GenericsNone(); YY_RESULT_Generics_= (yyval.generics_); ;}
    break;

  case 88:
#line 636 "Grammar.y"
    { (yyval.generics_) = make_GenericsType((yyvsp[(2) - (3)].type_)); YY_RESULT_Generics_= (yyval.generics_); ;}
    break;

  case 89:
#line 638 "Grammar.y"
    { (yyval.listtype_) = 0; YY_RESULT_ListType_= (yyval.listtype_); ;}
    break;

  case 90:
#line 639 "Grammar.y"
    { (yyval.listtype_) = make_ListType((yyvsp[(1) - (1)].type_), 0); YY_RESULT_ListType_= (yyval.listtype_); ;}
    break;

  case 91:
#line 640 "Grammar.y"
    { (yyval.listtype_) = make_ListType((yyvsp[(1) - (3)].type_), (yyvsp[(3) - (3)].listtype_)); YY_RESULT_ListType_= (yyval.listtype_); ;}
    break;

  case 92:
#line 642 "Grammar.y"
    { (yyval.basetype_) = make_BaseType_Int(); YY_RESULT_BaseType_= (yyval.basetype_); ;}
    break;

  case 93:
#line 643 "Grammar.y"
    { (yyval.basetype_) = make_BaseType_Unit(); YY_RESULT_BaseType_= (yyval.basetype_); ;}
    break;

  case 94:
#line 644 "Grammar.y"
    { (yyval.basetype_) = make_BaseTypeDouble(); YY_RESULT_BaseType_= (yyval.basetype_); ;}
    break;


/* Line 1267 of yacc.c.  */
#line 2506 "Parser.c"
      default: break;
    }
  YY_SYMBOL_PRINT ("-> $$ =", yyr1[yyn], &yyval, &yyloc);

  YYPOPSTACK (yylen);
  yylen = 0;
  YY_STACK_PRINT (yyss, yyssp);

  *++yyvsp = yyval;


  /* Now `shift' the result of the reduction.  Determine what state
     that goes to, based on the state we popped back to and the rule
     number reduced by.  */

  yyn = yyr1[yyn];

  yystate = yypgoto[yyn - YYNTOKENS] + *yyssp;
  if (0 <= yystate && yystate <= YYLAST && yycheck[yystate] == *yyssp)
    yystate = yytable[yystate];
  else
    yystate = yydefgoto[yyn - YYNTOKENS];

  goto yynewstate;


/*------------------------------------.
| yyerrlab -- here on detecting error |
`------------------------------------*/
yyerrlab:
  /* If not already recovering from an error, report this error.  */
  if (!yyerrstatus)
    {
      ++yynerrs;
#if ! YYERROR_VERBOSE
      yyerror (YY_("syntax error"));
#else
      {
	YYSIZE_T yysize = yysyntax_error (0, yystate, yychar);
	if (yymsg_alloc < yysize && yymsg_alloc < YYSTACK_ALLOC_MAXIMUM)
	  {
	    YYSIZE_T yyalloc = 2 * yysize;
	    if (! (yysize <= yyalloc && yyalloc <= YYSTACK_ALLOC_MAXIMUM))
	      yyalloc = YYSTACK_ALLOC_MAXIMUM;
	    if (yymsg != yymsgbuf)
	      YYSTACK_FREE (yymsg);
	    yymsg = (char *) YYSTACK_ALLOC (yyalloc);
	    if (yymsg)
	      yymsg_alloc = yyalloc;
	    else
	      {
		yymsg = yymsgbuf;
		yymsg_alloc = sizeof yymsgbuf;
	      }
	  }

	if (0 < yysize && yysize <= yymsg_alloc)
	  {
	    (void) yysyntax_error (yymsg, yystate, yychar);
	    yyerror (yymsg);
	  }
	else
	  {
	    yyerror (YY_("syntax error"));
	    if (yysize != 0)
	      goto yyexhaustedlab;
	  }
      }
#endif
    }



  if (yyerrstatus == 3)
    {
      /* If just tried and failed to reuse look-ahead token after an
	 error, discard it.  */

      if (yychar <= YYEOF)
	{
	  /* Return failure if at end of input.  */
	  if (yychar == YYEOF)
	    YYABORT;
	}
      else
	{
	  yydestruct ("Error: discarding",
		      yytoken, &yylval);
	  yychar = YYEMPTY;
	}
    }

  /* Else will try to reuse look-ahead token after shifting the error
     token.  */
  goto yyerrlab1;


/*---------------------------------------------------.
| yyerrorlab -- error raised explicitly by YYERROR.  |
`---------------------------------------------------*/
yyerrorlab:

  /* Pacify compilers like GCC when the user code never invokes
     YYERROR and the label yyerrorlab therefore never appears in user
     code.  */
  if (/*CONSTCOND*/ 0)
     goto yyerrorlab;

  /* Do not reclaim the symbols of the rule which action triggered
     this YYERROR.  */
  YYPOPSTACK (yylen);
  yylen = 0;
  YY_STACK_PRINT (yyss, yyssp);
  yystate = *yyssp;
  goto yyerrlab1;


/*-------------------------------------------------------------.
| yyerrlab1 -- common code for both syntax error and YYERROR.  |
`-------------------------------------------------------------*/
yyerrlab1:
  yyerrstatus = 3;	/* Each real token shifted decrements this.  */

  for (;;)
    {
      yyn = yypact[yystate];
      if (yyn != YYPACT_NINF)
	{
	  yyn += YYTERROR;
	  if (0 <= yyn && yyn <= YYLAST && yycheck[yyn] == YYTERROR)
	    {
	      yyn = yytable[yyn];
	      if (0 < yyn)
		break;
	    }
	}

      /* Pop the current state because it cannot handle the error token.  */
      if (yyssp == yyss)
	YYABORT;


      yydestruct ("Error: popping",
		  yystos[yystate], yyvsp);
      YYPOPSTACK (1);
      yystate = *yyssp;
      YY_STACK_PRINT (yyss, yyssp);
    }

  if (yyn == YYFINAL)
    YYACCEPT;

  *++yyvsp = yylval;


  /* Shift the error token.  */
  YY_SYMBOL_PRINT ("Shifting", yystos[yyn], yyvsp, yylsp);

  yystate = yyn;
  goto yynewstate;


/*-------------------------------------.
| yyacceptlab -- YYACCEPT comes here.  |
`-------------------------------------*/
yyacceptlab:
  yyresult = 0;
  goto yyreturn;

/*-----------------------------------.
| yyabortlab -- YYABORT comes here.  |
`-----------------------------------*/
yyabortlab:
  yyresult = 1;
  goto yyreturn;

#ifndef yyoverflow
/*-------------------------------------------------.
| yyexhaustedlab -- memory exhaustion comes here.  |
`-------------------------------------------------*/
yyexhaustedlab:
  yyerror (YY_("memory exhausted"));
  yyresult = 2;
  /* Fall through.  */
#endif

yyreturn:
  if (yychar != YYEOF && yychar != YYEMPTY)
     yydestruct ("Cleanup: discarding lookahead",
		 yytoken, &yylval);
  /* Do not reclaim the symbols of the rule which action triggered
     this YYABORT or YYACCEPT.  */
  YYPOPSTACK (yylen);
  YY_STACK_PRINT (yyss, yyssp);
  while (yyssp != yyss)
    {
      yydestruct ("Cleanup: popping",
		  yystos[*yyssp], yyvsp);
      YYPOPSTACK (1);
    }
#ifndef yyoverflow
  if (yyss != yyssa)
    YYSTACK_FREE (yyss);
#endif
#if YYERROR_VERBOSE
  if (yymsg != yymsgbuf)
    YYSTACK_FREE (yymsg);
#endif
  /* Make sure YYID is used.  */
  return YYID (yyresult);
}



