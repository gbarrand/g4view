#ifndef inlib_fort_fmt_h
#define inlib_fort_fmt_h

#include "fort_fmt_lexer.h"

#include <vector>

namespace inlib {

#define data_desc_X 1
#define data_desc_I 2
#define data_desc_F 3
#define data_desc_E 4
#define data_desc_G 5
#define data_desc_A 6
#define data_desc_L 7
#define data_desc_SLASH 8

class data_desc_iterator;

class data_desc {
public:
  data_desc();
  virtual ~data_desc();
public:
  void clear();
  void dump(std::ostream&,int = 0) const;
  data_desc_iterator* createIterator() const;
  data_desc* firstLeaf();
  data_desc* nextChild(data_desc*);
  void reset(bool = true);
  std::string cformat() const;
public:
  std::vector<data_desc*> m_children;
  data_desc* m_parent;
  int m_index;
  // Leaf data :
  unsigned int m_multiplicity;
  unsigned int m_type;
  unsigned int m_width;
  unsigned int m_precision;
  unsigned int m_exponent;
};

class data_desc_iterator {
public:
  data_desc_iterator(data_desc&);
  virtual ~data_desc_iterator();
  data_desc* next();
  void reset();
  bool finished() const;
public:
  data_desc& m_tree;
  data_desc* m_desc;
  bool fFinished;
};

class fort_fmt {
public:
  fort_fmt(const std::string&,std::ostream&,int = 0);
  virtual ~fort_fmt();
private:
  fort_fmt(const fort_fmt&);
  fort_fmt& operator=(const fort_fmt&);
public:
  void setScript(const std::string&);
  const std::string& script() const;
  void clear();
  bool parse();
  bool isSuccess() const;
  const data_desc& result() const;
public:  // Internal :
  fort_fmt_lexer& lexer();
  std::ostream& out() const;
public:
  int m_verbose_level;
  std::string m_string;
  std::ostream& m_out;
  fort_fmt_lexer m_lexer;
  bool m_success;
  data_desc m_tree;
  std::vector<data_desc*> m_tmp_descs;
};

}

#endif
