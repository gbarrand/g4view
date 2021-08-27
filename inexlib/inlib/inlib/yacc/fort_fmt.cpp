#ifndef lint
static const char fort_fmt_sccsid[] = "@(#)yaccpar	1.9 (Berkeley) 02/21/93";
#endif

#include <stdlib.h>

#define YYBYACC 1
#define YYMAJOR 1
#define YYMINOR 9
#define YYPATCH 20050813

#define YYEMPTY (-1)
#define fort_fmt_clearin    (fort_fmt_char = YYEMPTY)
#define fort_fmt_errok      (fort_fmt_errflag = 0)
#define YYRECOVERING (fort_fmt_errflag != 0)

//extern int fort_fmt_parse(inlib::fort_fmt& a_parser);

static int fort_fmt_growstack(void);
#define YYPREFIX "fort_fmt_"
#line 2 "../source/fort_fmt.y"

/* this :*/
#include "fort_fmt.h"

#ifdef INLIB_MEM
#include "../mem"
#endif
#include "../sprintf"

#include "fort_fmt_lexer.h"

extern int fort_fmt_lexer_lex(inlib::fort_fmt_lexer&);
static int fort_fmt_parse(inlib::fort_fmt& a_parser);
static void fort_fmt_error(inlib::fort_fmt&,const char*); 

/*#define LIB_DEBUG*/

#line 20 "../source/fort_fmt.y"
typedef union {
  unsigned long m_integer;
  inlib::data_desc* m_desc;
  unsigned int m_type;
} YYSTYPE;
#line 45 "y.tab.c"
#define NUMBER_INTEGER 257
#define NUMBER_EXPONENT 258
#define T_X 259
#define T_I 260
#define T_F 261
#define T_E 262
#define T_G 263
#define T_A 264
#define T_L 265
#define T_SLASH 266
#define UMINUS 267
#define YYERRCODE 256
short fort_fmt_lhs[] = {                                        -1,
    0,    0,    1,    1,    2,    2,    2,    3,    3,    4,
    4,    4,    4,    5,    5,    5,    5,    5,    5,    5,
    5,
};
short fort_fmt_len[] = {                                         2,
    1,    1,    3,    4,    1,    1,    3,    1,    2,    1,
    2,    4,    5,    1,    1,    1,    1,    1,    1,    1,
    1,
};
short fort_fmt_defred[] = {                                      0,
    1,    0,    0,    0,    2,    0,    0,   14,   15,   16,
   17,   18,   19,   20,   21,    6,    0,    5,    8,    0,
    0,    9,    3,    0,    0,    4,    0,    0,    0,   13,
};
short fort_fmt_dgoto[] = {                                       4,
   16,   17,   18,   19,   20,
};
short fort_fmt_sindex[] = {                                    -21,
    0,  -39,  -40,    0,    0,  -40,  -32,    0,    0,    0,
    0,    0,    0,    0,    0,    0,  -38,    0,    0, -252,
  -37,    0,    0,  -40,  -28,    0,  -35, -241, -237,    0,
};
short fort_fmt_rindex[] = {                                      0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,  -31,
    0,    0,    0,    0,  -30,    0,  -24,    0,  -29,    0,
};
short fort_fmt_gindex[] = {                                      0,
   22,   -4,    0,   16,    0,
};
#define YYTABLESIZE 236
short fort_fmt_table[] = {                                       3,
    6,   21,   23,   26,   25,   24,   24,    6,   24,   10,
   11,   12,   10,   11,   12,   29,    7,   28,    3,   27,
   30,    5,   22,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    0,    0,    0,    0,
    0,    0,    0,    0,    0,    0,    7,    0,    8,    9,
   10,   11,   12,   13,   14,   15,    8,    9,   10,   11,
   12,   13,   14,   15,    1,    2,
};
short fort_fmt_check[] = {                                      40,
   40,    6,   41,   41,  257,   44,   44,   40,   44,   41,
   41,   41,   44,   44,   44,  257,   41,   46,   40,   24,
  258,    0,    7,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,   -1,
   -1,   -1,   -1,   -1,   -1,   -1,  257,   -1,  259,  260,
  261,  262,  263,  264,  265,  266,  259,  260,  261,  262,
  263,  264,  265,  266,  256,  257,
};
#define YYFINAL 4
#ifndef YYDEBUG
#define YYDEBUG 0
#endif
#define YYMAXTOKEN 267
#if YYDEBUG
char *fort_fmt_name[] = {
"end-of-file",0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
0,0,0,0,0,0,"'('","')'","'*'","'+'","','","'-'","'.'","'/'",0,0,0,0,0,0,0,0,0,0,
0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,
"NUMBER_INTEGER","NUMBER_EXPONENT","T_X","T_I","T_F","T_E","T_G","T_A","T_L",
"T_SLASH","UMINUS",
};
char *fort_fmt_rule[] = {
"$accept : result",
"result : error",
"result : data_desc_tree",
"data_desc_tree : '(' data_desc_list ')'",
"data_desc_tree : NUMBER_INTEGER '(' data_desc_list ')'",
"data_desc_list : data_desc_leaf",
"data_desc_list : data_desc_tree",
"data_desc_list : data_desc_list ',' data_desc_list",
"data_desc_leaf : data_desc_one",
"data_desc_leaf : NUMBER_INTEGER data_desc_one",
"data_desc_one : data_type",
"data_desc_one : data_type NUMBER_INTEGER",
"data_desc_one : data_type NUMBER_INTEGER '.' NUMBER_INTEGER",
"data_desc_one : data_type NUMBER_INTEGER '.' NUMBER_INTEGER NUMBER_EXPONENT",
"data_type : T_X",
"data_type : T_I",
"data_type : T_F",
"data_type : T_E",
"data_type : T_G",
"data_type : T_A",
"data_type : T_L",
"data_type : T_SLASH",
};
#endif
#if YYDEBUG
#include <stdio.h>
#endif

/* define the initial stack-sizes */
#ifdef YYSTACKSIZE
#undef YYMAXDEPTH
#define YYMAXDEPTH  YYSTACKSIZE
#else
#ifdef YYMAXDEPTH
#define YYSTACKSIZE YYMAXDEPTH
#else
#define YYSTACKSIZE 500
#define YYMAXDEPTH  500
#endif
#endif

#define YYINITSTACKSIZE 500

int      fort_fmt_debug;
int      fort_fmt_nerrs;
int      fort_fmt_errflag;
int      fort_fmt_char;
short   *fort_fmt_ssp;
YYSTYPE *fort_fmt_vsp;
YYSTYPE  fort_fmt_val;
YYSTYPE  fort_fmt_lval;

/* variables for the parser stack */
static short   *fort_fmt_ss;
static short   *fort_fmt_sslim;
static YYSTYPE *fort_fmt_vs;
static int      fort_fmt_stacksize;
#line 241 "../source/fort_fmt.y"

//////////////////////////////////////////////////////////////////////////////
inlib::fort_fmt::fort_fmt(
 const std::string& a_string
,std::ostream& a_out
,int a_verbose_level
) 
:m_verbose_level(a_verbose_level)
,m_string(a_string)
,m_out(a_out)
,m_lexer(a_out,a_verbose_level)
,m_success(false)
//////////////////////////////////////////////////////////////////////////////
//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!//
{
}
//////////////////////////////////////////////////////////////////////////////
inlib::fort_fmt::~fort_fmt(
) 
//////////////////////////////////////////////////////////////////////////////
//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!//
{
  clear();
}

// private.
inlib::fort_fmt::fort_fmt(const fort_fmt& a_from) 
:m_verbose_level(a_from.m_verbose_level)
,m_string(a_from.m_string)
,m_out(a_from.m_out)
,m_lexer(a_from.m_out,m_verbose_level)
,m_success(false)
{}

// private.
inlib::fort_fmt& inlib::fort_fmt::operator=(const fort_fmt&) {return *this;}

void inlib::fort_fmt::setScript(const std::string& a_string) {m_string = a_string;}

const std::string& inlib::fort_fmt::script() const {return m_string;}

bool inlib::fort_fmt::parse() {
  clear();
  if(m_string.empty()) return false;
  m_lexer.set(m_string);
  m_success = true;
  fort_fmt_parse(*this);
  if(!m_success) clear();
  return m_success;
}

const inlib::data_desc& inlib::fort_fmt::result() const {return m_tree;}

void inlib::fort_fmt::clear() {
  m_tree.clear();

  // In case of error :
 {std::vector<data_desc*>::iterator it;
  for(it=m_tmp_descs.begin();it!=m_tmp_descs.end();++it) delete (*it);
  m_tmp_descs.clear();}
}

bool inlib::fort_fmt::isSuccess() const {return m_success;}

//////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////

std::ostream& inlib::fort_fmt::out() const {return m_out;}

inlib::fort_fmt_lexer& inlib::fort_fmt::lexer() {return m_lexer;}

static void fort_fmt_error(inlib::fort_fmt& a_parser,const char* a_string) {
  a_parser.out() << "fort_fmt : " << a_string << std::endl;
  a_parser.m_success = false;
}
//////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////
inlib::data_desc::data_desc(
)
:m_parent(0)
,m_index(0)
,m_multiplicity(1)
,m_type(0) //Unknown by default
,m_width(0)
,m_precision(0)
,m_exponent(0)
//////////////////////////////////////////////////////////////////////////////
//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!//
{
#ifdef INLIB_MEM
  inlib::mem::increment("inlib::data_desc");
#endif
}
//////////////////////////////////////////////////////////////////////////////
inlib::data_desc::~data_desc(
)
//////////////////////////////////////////////////////////////////////////////
//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!//
{
  clear();
#ifdef INLIB_MEM
  inlib::mem::decrement("inlib::data_desc");
#endif
}

void inlib::data_desc::clear() {
  std::vector<data_desc*>::iterator it;
  for(it=m_children.begin();it!=m_children.end();++it) delete *it;
  m_children.clear();
}

void inlib::data_desc::reset(bool aDoThis){
  // Descent the tree to reset all the m_index to 0.
  if(aDoThis) m_index = 0;
  std::vector<data_desc*>::iterator it;
  for(it=m_children.begin();it!=m_children.end();++it) (*it)->reset();
}

inlib::data_desc_iterator* inlib::data_desc::createIterator() const {
  data_desc& self = const_cast<data_desc&>(*this);
  return new inlib::data_desc_iterator(self);
}

inlib::data_desc* inlib::data_desc::firstLeaf() {
  std::vector<data_desc*>::iterator it;
  for(it=m_children.begin();it!=m_children.end();++it) {
    inlib::data_desc* leaf = (*it)->firstLeaf();
    if(leaf) return leaf;
  }
  if(!m_children.size()) return 0;
  return m_children[0];
}
//////////////////////////////////////////////////////////////////////////////
inlib::data_desc* inlib::data_desc::nextChild(
 inlib::data_desc* aChild
)
//////////////////////////////////////////////////////////////////////////////
//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!//
{
  unsigned int number = m_children.size(); 
  if(!aChild && number) return m_children[0];
  for(unsigned int index=0;index<number;index++) {
    if(aChild==m_children[index]) {
      if((index+1)<number) {
        return m_children[index+1];
      } else { 
        return 0;
      }
    }
  }
  return 0; //Should never pass here.
}
//////////////////////////////////////////////////////////////////////////////
void inlib::data_desc::dump(
 std::ostream& a_out
,int aIndent
) const
//////////////////////////////////////////////////////////////////////////////
//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!//
{
  std::string sindent(aIndent,' ');

  if(!m_children.size()) { // Leaf :
    a_out << sindent;
    a_out << m_multiplicity;
    if(m_type==data_desc_X) a_out << "X";
    else if(m_type==data_desc_I) a_out << "I";
    else if(m_type==data_desc_F) a_out << "F";
    else if(m_type==data_desc_E) a_out << "E";
    else if(m_type==data_desc_G) a_out << "G";
    else if(m_type==data_desc_A) a_out << "A";
    else if(m_type==data_desc_SLASH) a_out << "/";
    else a_out << "?";
    a_out << m_width;
    a_out << ".";
    a_out << m_precision;
    a_out << "E";
    a_out << m_exponent;
    a_out << std::endl;    
  } else {

    a_out << sindent;
    a_out << m_multiplicity;
    a_out << std::endl;    

   {std::vector<data_desc*>::const_iterator it;
    for(it=m_children.begin();it!=m_children.end();++it) {
      (*it)->dump(a_out,aIndent+2);
    }}
  }

}

std::string inlib::data_desc::cformat() const {
  data_desc& self = const_cast<data_desc&>(*this);

       if(m_type==data_desc_X) {
    return "";
  } else if(m_type==data_desc_I) {
    std::string cformat;
    inlib::sprintf(cformat,64,"%%%d.%dd",m_width,m_precision);
    return cformat;
  } else if(m_type==data_desc_F) {
    // # : to force having a decimal point, even if precision is 0.
    std::string cformat;
    inlib::sprintf(cformat,64,"%%#%d.%df",m_width,m_precision);
    return cformat;
  } else if(m_type==data_desc_E) {
    std::string cformat;
    inlib::sprintf(cformat,64,"%%%d.%dE",m_width,m_precision);
    return cformat;
  } else if(m_type==data_desc_G) {
    std::string cformat;
    inlib::sprintf(cformat,64,"%%%d.%dG",m_width,m_precision);
    return cformat;
  } else if(m_type==data_desc_A) {
    return "%s";
  } else if(m_type==data_desc_SLASH) {
    return "";
  } else {
    return "";  
  }
}
//////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////
inlib::data_desc_iterator::data_desc_iterator(
 inlib::data_desc& aTree
)
:m_tree(aTree)
,m_desc(0)
,fFinished(false)
//////////////////////////////////////////////////////////////////////////////
//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!//
{
#ifdef INLIB_MEM
  inlib::mem::increment("inlib::data_desc_iterator");
#endif
  m_tree.reset();
}
//////////////////////////////////////////////////////////////////////////////
inlib::data_desc_iterator::~data_desc_iterator(
)
//////////////////////////////////////////////////////////////////////////////
//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!//
{
#ifdef INLIB_MEM
  inlib::mem::decrement("inlib::data_desc_iterator");
#endif
}
//////////////////////////////////////////////////////////////////////////////
void inlib::data_desc_iterator::reset(
) 
//////////////////////////////////////////////////////////////////////////////
//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!//
{
  m_tree.reset();
  m_desc = 0;
  fFinished = false;
}
//////////////////////////////////////////////////////////////////////////////
bool inlib::data_desc_iterator::finished(
) const
//////////////////////////////////////////////////////////////////////////////
//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!//
{
  return fFinished;
}
//////////////////////////////////////////////////////////////////////////////
inlib::data_desc* inlib::data_desc_iterator::next(
)
//////////////////////////////////////////////////////////////////////////////
//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!//
{
  if(fFinished) return 0;
  if(!m_desc) { //Begin of iteration.
    m_desc = &m_tree;
    m_desc->m_index = 0;
  } else { // Repeat again ?
    if((m_desc->m_index+1)<(int)m_desc->m_multiplicity) {
      m_desc->m_index++;
      m_desc->reset(false);
      return m_desc; // The same.
    }
  }
  // New desc :
  while(true) {
    inlib::data_desc* leaf = m_desc->firstLeaf();
    if(leaf) {
      m_desc = leaf;
      m_desc->m_index = 0;
   /*{inlib::data_desc* parent = m_desc->m_parent;
      while(parent) {
        parent->m_index = 0;
        parent = parent->m_parent;          
      }}*/
      return leaf;
    }
    // Back to parent and after current m_desc :
    inlib::data_desc* parent = m_desc->m_parent;
    while(1) {
      if(!parent) { //Tree finished.      
        m_desc = 0;
        fFinished = true;
        return 0;
      }
      m_desc = parent->nextChild(m_desc);
      if(m_desc) break;
      // parent children exhausted.
      // Repeat again ?
      if((parent->m_index+1)<(int)parent->m_multiplicity) {
        parent->m_index++;
        parent->reset(false);
        m_desc = parent;
        break;
      } else {
        m_desc = parent;
        parent = parent->m_parent;          
      }
    }
  }
}
#line 535 "y.tab.c"
/* allocate initial stack or double stack size, up to YYMAXDEPTH */
static int fort_fmt_growstack(void)
{
    int newsize, i;
    short *newss;
    YYSTYPE *newvs;

    if ((newsize = fort_fmt_stacksize) == 0)
        newsize = YYINITSTACKSIZE;
    else if (newsize >= YYMAXDEPTH)
        return -1;
    else if ((newsize *= 2) > YYMAXDEPTH)
        newsize = YYMAXDEPTH;

    i = fort_fmt_ssp - fort_fmt_ss;
    newss = (fort_fmt_ss != 0)
          ? (short *)realloc(fort_fmt_ss, newsize * sizeof(*newss))
          : (short *)malloc(newsize * sizeof(*newss));
    if (newss == 0)
        return -1;

    fort_fmt_ss  = newss;
    fort_fmt_ssp = newss + i;
    newvs = (fort_fmt_vs != 0)
          ? (YYSTYPE *)realloc(fort_fmt_vs, newsize * sizeof(*newvs))
          : (YYSTYPE *)malloc(newsize * sizeof(*newvs));
    if (newvs == 0)
        return -1;

    fort_fmt_vs = newvs;
    fort_fmt_vsp = newvs + i;
    fort_fmt_stacksize = newsize;
    fort_fmt_sslim = fort_fmt_ss + newsize - 1;
    return 0;
}

#define YYABORT goto fort_fmt_abort
#define YYREJECT goto fort_fmt_abort
#define YYACCEPT goto fort_fmt_accept
#define YYERROR goto fort_fmt_errlab
int
fort_fmt_parse(inlib::fort_fmt& a_parser)
{
    /*GB register*/ int fort_fmt_m, fort_fmt_n, fort_fmt_state;
#if YYDEBUG
    /*GB register*/ const char *fort_fmt_s;

    if ((fort_fmt_s = getenv("YYDEBUG")) != 0)
    {
        fort_fmt_n = *fort_fmt_s;
        if (fort_fmt_n >= '0' && fort_fmt_n <= '9')
            fort_fmt_debug = fort_fmt_n - '0';
    }
#endif

    fort_fmt_nerrs = 0;
    fort_fmt_errflag = 0;
    fort_fmt_char = YYEMPTY;

    if (fort_fmt_ss == NULL && fort_fmt_growstack()) goto fort_fmt_overflow;
    fort_fmt_ssp = fort_fmt_ss;
    fort_fmt_vsp = fort_fmt_vs;
    *fort_fmt_ssp = fort_fmt_state = 0;

fort_fmt_loop:
    if ((fort_fmt_n = fort_fmt_defred[fort_fmt_state]) != 0) goto fort_fmt_reduce;
    if (fort_fmt_char < 0)
    {
        if ((fort_fmt_char = fort_fmt_lexer_lex(a_parser.lexer())) < 0) fort_fmt_char = 0;
#if YYDEBUG
        if (fort_fmt_debug)
        {
            fort_fmt_s = 0;
            if (fort_fmt_char <= YYMAXTOKEN) fort_fmt_s = fort_fmt_name[fort_fmt_char];
            if (!fort_fmt_s) fort_fmt_s = "illegal-symbol";
            printf("%sdebug: state %d, reading %d (%s)\n",
                    YYPREFIX, fort_fmt_state, fort_fmt_char, fort_fmt_s);
        }
#endif
    }
    if ((fort_fmt_n = fort_fmt_sindex[fort_fmt_state]) && (fort_fmt_n += fort_fmt_char) >= 0 &&
            fort_fmt_n <= YYTABLESIZE && fort_fmt_check[fort_fmt_n] == fort_fmt_char)
    {
#if YYDEBUG
        if (fort_fmt_debug)
            printf("%sdebug: state %d, shifting to state %d\n",
                    YYPREFIX, fort_fmt_state, fort_fmt_table[fort_fmt_n]);
#endif
        if (fort_fmt_ssp >= fort_fmt_sslim && fort_fmt_growstack())
        {
            goto fort_fmt_overflow;
        }
        *++fort_fmt_ssp = fort_fmt_state = fort_fmt_table[fort_fmt_n];
        *++fort_fmt_vsp = fort_fmt_lval;
        fort_fmt_char = YYEMPTY;
        if (fort_fmt_errflag > 0)  --fort_fmt_errflag;
        goto fort_fmt_loop;
    }
    if ((fort_fmt_n = fort_fmt_rindex[fort_fmt_state]) && (fort_fmt_n += fort_fmt_char) >= 0 &&
            fort_fmt_n <= YYTABLESIZE && fort_fmt_check[fort_fmt_n] == fort_fmt_char)
    {
        fort_fmt_n = fort_fmt_table[fort_fmt_n];
        goto fort_fmt_reduce;
    }
    if (fort_fmt_errflag) goto fort_fmt_inrecovery;

    fort_fmt_error(a_parser,"syntax error");

#ifdef lint
    goto fort_fmt_errlab;
#endif

fort_fmt_errlab:
    ++fort_fmt_nerrs;

fort_fmt_inrecovery:
    if (fort_fmt_errflag < 3)
    {
        fort_fmt_errflag = 3;
        for (;;)
        {
            if ((fort_fmt_n = fort_fmt_sindex[*fort_fmt_ssp]) && (fort_fmt_n += YYERRCODE) >= 0 &&
                    fort_fmt_n <= YYTABLESIZE && fort_fmt_check[fort_fmt_n] == YYERRCODE)
            {
#if YYDEBUG
                if (fort_fmt_debug)
                    printf("%sdebug: state %d, error recovery shifting\
 to state %d\n", YYPREFIX, *fort_fmt_ssp, fort_fmt_table[fort_fmt_n]);
#endif
                if (fort_fmt_ssp >= fort_fmt_sslim && fort_fmt_growstack())
                {
                    goto fort_fmt_overflow;
                }
                *++fort_fmt_ssp = fort_fmt_state = fort_fmt_table[fort_fmt_n];
                *++fort_fmt_vsp = fort_fmt_lval;
                goto fort_fmt_loop;
            }
            else
            {
#if YYDEBUG
                if (fort_fmt_debug)
                    printf("%sdebug: error recovery discarding state %d\n",
                            YYPREFIX, *fort_fmt_ssp);
#endif
                if (fort_fmt_ssp <= fort_fmt_ss) goto fort_fmt_abort;
                --fort_fmt_ssp;
                --fort_fmt_vsp;
            }
        }
    }
    else
    {
        if (fort_fmt_char == 0) goto fort_fmt_abort;
#if YYDEBUG
        if (fort_fmt_debug)
        {
            fort_fmt_s = 0;
            if (fort_fmt_char <= YYMAXTOKEN) fort_fmt_s = fort_fmt_name[fort_fmt_char];
            if (!fort_fmt_s) fort_fmt_s = "illegal-symbol";
            printf("%sdebug: state %d, error recovery discards token %d (%s)\n",
                    YYPREFIX, fort_fmt_state, fort_fmt_char, fort_fmt_s);
        }
#endif
        fort_fmt_char = YYEMPTY;
        goto fort_fmt_loop;
    }

fort_fmt_reduce:
#if YYDEBUG
    if (fort_fmt_debug)
        printf("%sdebug: state %d, reducing by rule %d (%s)\n",
                YYPREFIX, fort_fmt_state, fort_fmt_n, fort_fmt_rule[fort_fmt_n]);
#endif
    fort_fmt_m = fort_fmt_len[fort_fmt_n];
    fort_fmt_val = fort_fmt_vsp[1-fort_fmt_m];
    switch (fort_fmt_n)
    {
case 1:
#line 43 "../source/fort_fmt.y"
{
  /* To reset lex and yacc in case of error.*/
}
break;
case 2:
#line 45 "../source/fort_fmt.y"
{
  a_parser.m_tree.m_children.push_back(fort_fmt_vsp[0].m_desc);
  fort_fmt_vsp[0].m_desc->m_parent = &(a_parser.m_tree);
  a_parser.m_tmp_descs.pop_back();
}
break;
case 3:
#line 52 "../source/fort_fmt.y"
{
  if(a_parser.m_verbose_level) {
    a_parser.out() << "inlib::fort_fmt::parse :"
        << " data_desc_tree : (data_desc_list)" 
        << std::endl;
  }
  fort_fmt_vsp[-1].m_desc->m_multiplicity = 1;
  fort_fmt_val.m_desc = fort_fmt_vsp[-1].m_desc;
}
break;
case 4:
#line 60 "../source/fort_fmt.y"
{
  if(a_parser.m_verbose_level) {
    a_parser.out() << "inlib::fort_fmt::parse :"
        << " data_desc_tree : integer(data_desc_list)" 
        << std::endl;
  }
  fort_fmt_vsp[-1].m_desc->m_multiplicity = fort_fmt_vsp[-3].m_integer;
  fort_fmt_val.m_desc = fort_fmt_vsp[-1].m_desc;
}
break;
case 5:
#line 71 "../source/fort_fmt.y"
{
  if(a_parser.m_verbose_level) {
    a_parser.out() << "inlib::fort_fmt::parse :"
        << " data_desc_list : data_desc_leaf" 
        << std::endl;
  }
  inlib::data_desc* list = new inlib::data_desc();
  list->m_children.push_back(fort_fmt_vsp[0].m_desc);
  fort_fmt_vsp[0].m_desc->m_parent = list;
  a_parser.m_tmp_descs.pop_back();
  a_parser.m_tmp_descs.push_back(list);/*To cleanup in case of error.*/
  fort_fmt_val.m_desc = list;
}
break;
case 6:
#line 83 "../source/fort_fmt.y"
{
  if(a_parser.m_verbose_level) {
    a_parser.out() << "inlib::fort_fmt::parse :"
        << " data_desc_list : data_desc_tree" 
        << std::endl;
  }
  inlib::data_desc* list = new inlib::data_desc();
  list->m_children.push_back(fort_fmt_vsp[0].m_desc);
  fort_fmt_vsp[0].m_desc->m_parent = list;
  a_parser.m_tmp_descs.pop_back();
  a_parser.m_tmp_descs.push_back(list);/*To cleanup in case of error.*/
  fort_fmt_val.m_desc = list;
}
break;
case 7:
#line 95 "../source/fort_fmt.y"
{
  if(a_parser.m_verbose_level) {
    a_parser.out() << "inlib::fort_fmt::parse :"
        << " data_desc_list : data_desc_tree,data_desc_tree" 
        << std::endl;
  }
  inlib::data_desc* list = new inlib::data_desc();
  list->m_children.push_back(fort_fmt_vsp[-2].m_desc);
  fort_fmt_vsp[-2].m_desc->m_parent = list;
  list->m_children.push_back(fort_fmt_vsp[0].m_desc);
  fort_fmt_vsp[0].m_desc->m_parent = list;
  a_parser.m_tmp_descs.pop_back();
  a_parser.m_tmp_descs.pop_back();
  a_parser.m_tmp_descs.push_back(list);/*To cleanup in case of error.*/
  fort_fmt_val.m_desc = list;
}
break;
case 8:
#line 113 "../source/fort_fmt.y"
{
  if(a_parser.m_verbose_level) {
    a_parser.out() << "inlib::fort_fmt::parse :"
        << " data_desc_leaf : data_desc_one" 
        << std::endl;
  }
  fort_fmt_vsp[0].m_desc->m_multiplicity = 1;
  fort_fmt_val.m_desc = fort_fmt_vsp[0].m_desc;
}
break;
case 9:
#line 121 "../source/fort_fmt.y"
{
  if(a_parser.m_verbose_level) {
    a_parser.out() << "inlib::fort_fmt::parse :"
        << " data_desc_leaf : integer data_desc_one" 
        << std::endl;
  }
  fort_fmt_vsp[0].m_desc->m_multiplicity = fort_fmt_vsp[-1].m_integer;
  fort_fmt_val.m_desc = fort_fmt_vsp[0].m_desc;
}
break;
case 10:
#line 132 "../source/fort_fmt.y"
{
  if(a_parser.m_verbose_level) {
    a_parser.out() << "inlib::fort_fmt::parse :"
        << " data_desc_one : data_type" 
        << std::endl;
  }
  inlib::data_desc* leaf = new inlib::data_desc();
  a_parser.m_tmp_descs.push_back(leaf);/*To cleanup in case of error.*/
  leaf->m_type = fort_fmt_vsp[0].m_type;
  fort_fmt_val.m_desc = leaf;
}
break;
case 11:
#line 142 "../source/fort_fmt.y"
{
  if(a_parser.m_verbose_level) {
    a_parser.out() << "inlib::fort_fmt::parse :"
        << " data_desc_one : data_type integer" 
        << std::endl;
  }
  inlib::data_desc* leaf = new inlib::data_desc();
  a_parser.m_tmp_descs.push_back(leaf);/*To cleanup in case of error.*/
  leaf->m_type = fort_fmt_vsp[-1].m_type;
  leaf->m_width = fort_fmt_vsp[0].m_integer;
  fort_fmt_val.m_desc = leaf;
}
break;
case 12:
#line 153 "../source/fort_fmt.y"
{
  if(a_parser.m_verbose_level) {
    a_parser.out() << "inlib::fort_fmt::parse :"
        << " data_desc_one : data_type integer.integer" 
        << std::endl;
  }
  inlib::data_desc* leaf = new inlib::data_desc();
  a_parser.m_tmp_descs.push_back(leaf);/*To cleanup in case of error.*/
  leaf->m_type = fort_fmt_vsp[-3].m_type;
  leaf->m_width = fort_fmt_vsp[-2].m_integer;
  leaf->m_precision = fort_fmt_vsp[0].m_integer;
  fort_fmt_val.m_desc = leaf;
}
break;
case 13:
#line 165 "../source/fort_fmt.y"
{
  if(a_parser.m_verbose_level) {
    a_parser.out() << "inlib::fort_fmt::parse :"
        << " data_desc_one : data_type integer.integerEinteger" 
        << std::endl;
  }
  inlib::data_desc* leaf = new inlib::data_desc();
  a_parser.m_tmp_descs.push_back(leaf);/*To cleanup in case of error.*/
  leaf->m_type = fort_fmt_vsp[-4].m_type;
  leaf->m_width = fort_fmt_vsp[-3].m_integer;
  leaf->m_precision = fort_fmt_vsp[-1].m_integer;
  leaf->m_exponent = fort_fmt_vsp[0].m_integer;
  fort_fmt_val.m_desc = leaf;
}
break;
case 14:
#line 181 "../source/fort_fmt.y"
{ 
  if(a_parser.m_verbose_level) {
    a_parser.out() << "inlib::fort_fmt::parse :"
        << " data_type : T_X" 
        << std::endl;
  }
  fort_fmt_val.m_type = data_desc_X;
}
break;
case 15:
#line 188 "../source/fort_fmt.y"
{ 
  if(a_parser.m_verbose_level) {
    a_parser.out() << "inlib::fort_fmt::parse :"
          << " data_type : T_I" 
          << std::endl;
  }
  fort_fmt_val.m_type = data_desc_I;
}
break;
case 16:
#line 195 "../source/fort_fmt.y"
{ 
  if(a_parser.m_verbose_level) {
    a_parser.out() << "inlib::fort_fmt::parse :"
        << " data_type : T_F" 
        << std::endl;
  }
  fort_fmt_val.m_type = data_desc_F;
}
break;
case 17:
#line 202 "../source/fort_fmt.y"
{
  if(a_parser.m_verbose_level) {
    a_parser.out() << "inlib::fort_fmt::parse :"
        << " data_type : T_E" 
        << std::endl;
  }
  fort_fmt_val.m_type = data_desc_E;
}
break;
case 18:
#line 209 "../source/fort_fmt.y"
{
  if(a_parser.m_verbose_level) {
    a_parser.out() << "inlib::fort_fmt::parse :"
        << " data_type : T_G" 
        << std::endl;
  }
  fort_fmt_val.m_type = data_desc_G;
}
break;
case 19:
#line 216 "../source/fort_fmt.y"
{
  if(a_parser.m_verbose_level) {
    a_parser.out() << "inlib::fort_fmt::parse :"
          << " data_type : T_A" 
          << std::endl;
  }
  fort_fmt_val.m_type = data_desc_A;
}
break;
case 20:
#line 223 "../source/fort_fmt.y"
{
  if(a_parser.m_verbose_level) {
    a_parser.out() << "inlib::fort_fmt::parse :"
          << " data_type : T_L" 
          << std::endl;
  }
  fort_fmt_val.m_type = data_desc_L;
}
break;
case 21:
#line 230 "../source/fort_fmt.y"
{
  if(a_parser.m_verbose_level) {
    a_parser.out() << "inlib::fort_fmt::parse :"
        << " data_type : T_SLASH" 
        << std::endl;
  }
  fort_fmt_val.m_type = data_desc_SLASH;
}
break;
#line 976 "y.tab.c"
    }
    fort_fmt_ssp -= fort_fmt_m;
    fort_fmt_state = *fort_fmt_ssp;
    fort_fmt_vsp -= fort_fmt_m;
    fort_fmt_m = fort_fmt_lhs[fort_fmt_n];
    if (fort_fmt_state == 0 && fort_fmt_m == 0)
    {
#if YYDEBUG
        if (fort_fmt_debug)
            printf("%sdebug: after reduction, shifting from state 0 to\
 state %d\n", YYPREFIX, YYFINAL);
#endif
        fort_fmt_state = YYFINAL;
        *++fort_fmt_ssp = YYFINAL;
        *++fort_fmt_vsp = fort_fmt_val;
        if (fort_fmt_char < 0)
        {
            if ((fort_fmt_char = fort_fmt_lexer_lex(a_parser.lexer())) < 0) fort_fmt_char = 0;
#if YYDEBUG
            if (fort_fmt_debug)
            {
                fort_fmt_s = 0;
                if (fort_fmt_char <= YYMAXTOKEN) fort_fmt_s = fort_fmt_name[fort_fmt_char];
                if (!fort_fmt_s) fort_fmt_s = "illegal-symbol";
                printf("%sdebug: state %d, reading %d (%s)\n",
                        YYPREFIX, YYFINAL, fort_fmt_char, fort_fmt_s);
            }
#endif
        }
        if (fort_fmt_char == 0) goto fort_fmt_accept;
        goto fort_fmt_loop;
    }
    if ((fort_fmt_n = fort_fmt_gindex[fort_fmt_m]) && (fort_fmt_n += fort_fmt_state) >= 0 &&
            fort_fmt_n <= YYTABLESIZE && fort_fmt_check[fort_fmt_n] == fort_fmt_state)
        fort_fmt_state = fort_fmt_table[fort_fmt_n];
    else
        fort_fmt_state = fort_fmt_dgoto[fort_fmt_m];
#if YYDEBUG
    if (fort_fmt_debug)
        printf("%sdebug: after reduction, shifting from state %d \
to state %d\n", YYPREFIX, *fort_fmt_ssp, fort_fmt_state);
#endif
    if (fort_fmt_ssp >= fort_fmt_sslim && fort_fmt_growstack())
    {
        goto fort_fmt_overflow;
    }
    *++fort_fmt_ssp = fort_fmt_state;
    *++fort_fmt_vsp = fort_fmt_val;
    goto fort_fmt_loop;

fort_fmt_overflow:
    fort_fmt_error(a_parser,"yacc stack overflow");

fort_fmt_abort:
    return (1);

fort_fmt_accept:
    return (0);
}
