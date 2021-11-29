
#ifndef _RAWRRINVOKECS
#define _RAWRRINVOKECS

#include <mono/jit/jit.h>

#include <mono/metadata/object.h>
#include <mono/metadata/environment.h>
#include <mono/metadata/assembly.h>
#include <mono/metadata/debug-helpers.h>
#include <mono/metadata/mono-config.h>

#include <string.h>
#include <stdlib.h>
#include <fstream>

#ifndef FALSE
#define FALSE 0
#endif

#include <iostream>

#ifndef MONO_EMBED_CPP_MAIN
#include <Rcpp.h>
#endif

#ifdef MONO_EMBED_CPP_MAIN
#define OUTPUT(ttt)  std::cerr << ttt << std::endl
#else
#define OUTPUT(ttt)  Rcpp::Rcerr << ttt << std::endl
#endif

class Rawrr
{
  std::string rawFile = "/tmp/sample.raw";
  std::string assemblyFile = "helloRcpp.exe";
  MonoDomain *domain;
  MonoAssembly *assembly;
  MonoImage *image;

  MonoMethod *function_set_rawFile;
  MonoMethod *function_get_info;
  MonoMethod *function_open_file;

  MonoClass *Raw;
  MonoObject *obj;

private:

public:
    Rawrr ();
  void setDomainName (std::string s = "");
  void setAssembly (std::string file);
  void setRawFile (std::string file);
  void createObject ();
  void openFile ();
  int get_info ();
  void dector ();
};
#endif
