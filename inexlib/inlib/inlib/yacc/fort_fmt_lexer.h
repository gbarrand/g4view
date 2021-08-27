// Copyright (C) 2010, Guy Barrand. All rights reserved.
// See the file inlib.license for terms.

#ifndef inlib_fort_fmt_lexer_h
#define inlib_fort_fmt_lexer_h

#include <string>
#include <ostream>

namespace inlib {

// For FotranFormatToken.h :
class data_desc;

class fort_fmt_lexer {
public:
  fort_fmt_lexer(std::ostream&,int = 0);
private:
  fort_fmt_lexer(const fort_fmt_lexer&);
  fort_fmt_lexer& operator=(const fort_fmt_lexer&);
public:
  void set(const std::string&);
  std::ostream& out() const;
  int verboseLevel() const;
public:
  int input(char*,int); // Can't be avoided.
private:
  int m_verbose_level;
  std::string m_string;
  char* fCurrent;
  char* fEnd;
  std::ostream& m_out;
};

}

#endif
