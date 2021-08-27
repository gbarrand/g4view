// Copyright (C) 2010, Guy Barrand. All rights reserved.
// See the file inlib.license for terms.

#ifndef inlib_yacc_cexpr_eval_h
#define inlib_yacc_cexpr_eval_h

#ifdef INLIB_MEM
#include "../mem"
#endif

#include "cexpr_lexer.h"

#include "../valop"
#include "../val_func"
#include "../valop_exec"
#include "../vmanip"
#include "../sto"

namespace inlib {
namespace yacc {
  class cexpr_eval;
}}

extern "C" {
  extern int cexpr_eval_parse(inlib::yacc::cexpr_eval&);
}

namespace inlib {
namespace yacc {

class cexpr_eval {
  static const std::string& s_class() {
    static const std::string s_v("inlib::yacc::cexpr_eval");
    return s_v;
  }
public:
  cexpr_eval(std::ostream& a_out,const std::string& a_s)
  :m_out(a_out)
  ,m_string(a_s)
  ,m_find_names(false)
  ,m_find_functions(false)
  ,m_lexer(a_out)
  ,m_result(0)
  ,m_success(false)
  {
#ifdef INLIB_MEM
    mem::increment(s_class().c_str());
#endif
  }

  virtual ~cexpr_eval() {
    clear();
#ifdef INLIB_MEM
    mem::decrement(s_class().c_str());
#endif
  }

public:
  cexpr_eval(const cexpr_eval& a_from)
  :m_out(a_from.m_out)
  ,m_find_names(false)
  ,m_find_functions(false)
  ,m_lexer(a_from.m_lexer)
  ,m_result(0)
  ,m_success(false)
  ,m_funcs(a_from.m_funcs)
  {
#ifdef INLIB_MEM
    mem::increment(s_class().c_str());
#endif
  }

  cexpr_eval& operator=(const cexpr_eval& a_from){
    clear();
    m_lexer = a_from.m_lexer;
    m_funcs = a_from.m_funcs;
    // Reset other things :
    m_string.clear();
    m_find_names = false;
    m_find_functions = false;
    m_result = 0;
    return *this;
  }

public:
  void set_script(const std::string& a_s) {
    clear();
    m_string = a_s;
    m_find_names = false;
    m_find_functions = false;
    m_result = 0;
  }

  bool find_variables(std::vector<std::string>& a_names) {
    a_names.clear();
    clear();
    if(!m_string.size()) return true;
    m_lexer.set(m_string);
    m_find_names = true;
    m_find_functions = false;
    m_success = true;
    cexpr_eval_parse(*this);
    if(!m_success) {
      clear();
      return false;
    }
    if(m_tmp_exps.size()) {
      m_out << "inlib::yacc::cexpr_eval::find_variables :"
          << " stack anomaly " << (unsigned int)m_tmp_exps.size()
          << std::endl;
    }
    unique<std::string>(m_names);
    a_names = m_names;
    return true;
  }

  bool find_functions(std::vector<std::string>& a_names) {
    a_names.clear();
    clear();
    if(!m_string.size()) return true;
    m_lexer.set(m_string);
    m_find_names = false;
    m_find_functions = true;
    m_success = true;
    cexpr_eval_parse(*this);
    if(!m_success) {
      clear();
      return false;
    }
    if(m_tmp_exps.size()) {
      m_out << "inlib::yacc::cexpr_eval::find_variables :"
          << " stack anomaly " << (unsigned int)m_tmp_exps.size()
          << std::endl;
    }
    unique<std::string>(m_names);
    a_names = m_names;
    return true;
  }

  bool execute(const std::vector<value>& aInput,value& aResult,std::string& aError) {
    //printf("debug : inlib::yacc::cexpr_eval::execute : \"%s\" %lu\n",
    //  m_string.c_str(),m_result);
    if(!m_string.size()) {
      aResult.set_none();
      return true;
    }
    if(!m_result) {
      aResult.set_none();
      aError = "inlib::yacc::cexpr_eval::execute : not ready : fReturn = 0.";
      return false;
    }

    valop_exec v(aInput,aError);
    if(!v.visit(*m_result)) {
      aResult.set_none();
      return false;
    }

    if(!m_success) {
      aResult.set_none();
      aError = "inlib::yacc::cexpr_eval::execute : failed.";
      return false;
    }
    aResult = v.ret();

    return true;
  }

  bool cut(const std::vector<value>& aInput,bool& aResult,std::string& aError) {
    value ret; //WARNING : this allocation can take time.
    if(!execute(aInput,ret,aError)) {
      aResult = true;
      return false;
    }
    if(ret.type()==value::BOOL) {
      aResult = ret.get_bool();
      return true;
    }
    if(ret.type()==value::NONE) {
      //This may happen if m_string is empty.
      aResult = true;
      return true;
    }
    aResult = true;
    aError = "inlib::yacc::cexpr_eval::cut : failed.";
    return false;
  }

  bool compile() {
    std::vector<std::string> vars;
    find_variables(vars);
    return compile(vars);
  }

  bool compile(const std::vector<std::string>& a_names) {
    clear();
    if(!m_string.size()) return true;
    m_names = a_names;
    m_lexer.set(m_string);
    m_find_names = false;
    m_find_functions = false;
    m_success = true;
    cexpr_eval_parse(*this);
    if(!m_success) {
      clear();
      return false;
    }
    if(m_tmp_exps.size()) {
      m_out << "inlib::yacc::cexpr_eval::compile :"
            << " stack anomaly " << (unsigned int)m_tmp_exps.size()
            << std::endl;
    }
    return true;
  }

  void clear() {
   {std::vector<valop*>::iterator it;
    for(it=m_tmp_exps.begin();it!=m_tmp_exps.end();++it) delete (*it);
    m_tmp_exps.clear();}
    m_names.clear();
    delete m_result;
    m_result = 0;
  }


public: //OpenPAW :
  //void setScript(const std::string& a_s) {set_script(a_s);}
  //bool findVariables(std::vector<std::string>& aNames) {return find_variables(aNames);}
public:  // Internal :

  void add_name(const std::string& a_s) { m_names.push_back(a_s);}
  bool find_names() const{ return m_find_names;}

  bool find_variable(const std::string& a_s,unsigned int& aIndex){
    if(!item_index<std::string>(m_names,a_s,aIndex)) {
      m_out << "inlib::yacc::cexpr_eval::find_variable :"
            << " " << a_s << " not a variable."
            << std::endl;
      return false;
    }
    return true;
  }

  bool find_functions() const{ return m_find_functions;}

  void add_function(ival_func* aFunc) {return m_funcs.add(aFunc);}

  ival_func* find_function(const std::string& a_s,bool a_warn = true) const {
    ival_func* func = m_funcs.find(a_s);
    if(!func && a_warn) {
      m_out << "inlib::yacc::cexpr_eval::find_function : " << a_s << " not a function." << std::endl;
      return 0;
    }

    //m_out << "inlib::yacc::cexpr_eval::find_function :"
    //      << " " << a_s << " found."
    //      << std::endl;

    return func;
  }

  cexpr_lexer& lexer(){return m_lexer;}

  std::ostream& out() const { return m_out;}

  std::vector<valop*>& stack(){ return m_tmp_exps;}
  void set_result(valop* aValue){ m_result = aValue;}
  void set_status(bool aValue){m_success = aValue;}

protected:
  std::ostream& m_out;
  std::string m_string;
  bool m_find_names;
  bool m_find_functions;
  std::vector<std::string> m_names;
  cexpr_lexer m_lexer;
  valop* m_result;
  bool m_success;
  std::vector<valop*> m_tmp_exps;
  std::string m_error;
  val_funcs m_funcs;
};

}}

#endif
