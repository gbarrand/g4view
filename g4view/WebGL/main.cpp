// Copyright (C) 2010, Guy Barrand. All rights reserved.
// See the file g4view.license for terms.

#include "../g4view/main"

#include <exlib/app/WebGL/main_cpp>

int main(int argc,char** argv) {return exlib_main<g4view::context,g4view::main>("g4view",argc,argv);}

//exlib_build_use inlib expat
//exlib_build_use exlib png jpeg zlib inlib_glutess freetype kernel
