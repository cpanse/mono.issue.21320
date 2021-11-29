#ifndef __HELLOCPP__
#define __HELLOCPP__

#ifndef MONO_EMBED_CPP_MAIN
#include <Rcpp.h>
using namespace Rcpp;
#endif

#include "hello.h"

Rawrr::Rawrr ()
{
  std::ifstream my_file (rawFile.c_str ());
  if (my_file.good ())
    {
      // read away
    }
  else
    {
        OUTPUT("File " << rawFile.c_str () << " is not good.");
    }
  mono_config_parse (NULL);
}

void
Rawrr::setDomainName (std::string s)
{
  std::string ss = "rawrrr" + s;
  OUTPUT("DomainName=" << ss);
  try
  {
    domain = mono_jit_init_version (ss.c_str (), "v4.0");
  } catch (const std::exception & e)
  {
      OUTPUT("mono_jit_init_version failed.");
  }
}

void
Rawrr::setAssembly (std::string file)
{
  OUTPUT(__LINE__);
  OUTPUT(assemblyFile);

  assemblyFile = file;

  OUTPUT(__LINE__);
  OUTPUT(assemblyFile);
}

void
Rawrr::setRawFile (std::string file)
{
  rawFile = file;
  OUTPUT(rawFile);

  //MonoString *str;
  void *args[1];
  MonoObject *exception;
  args[0] = mono_string_new (domain, rawFile.c_str ());
  exception = NULL;
  mono_runtime_invoke (function_set_rawFile, obj, args, &exception);
  if (exception)
    {
        OUTPUT("Exception was raised in setRawFile\n");
    }
}

void
Rawrr::createObject ()
{

  assembly = mono_domain_assembly_open (domain, assemblyFile.c_str ());

  if (!assembly)
    {
      OUTPUT("ASSEMBLY PROBLEM\n");
      return;
    }

  image = mono_assembly_get_image (assembly);

  Raw = mono_class_from_name (image, "RawrrEmbed", "RawRr");
  if (!Raw)
    {
      OUTPUT("Can't find RawRr in assembly " << mono_image_get_filename (image));
      return;
    }

  OUTPUT("mono_object_new ...");
  obj = mono_object_new (domain, Raw);
  OUTPUT(" [DONE]");

  OUTPUT("mono_runtime_object_init ...");
  mono_runtime_object_init (obj);
  OUTPUT(" [DONE]");

  /// browse class methods
  MonoClass *klass;
  MonoMethod *m = NULL;
  void *iter;

  klass = mono_object_get_class (obj);
  domain = mono_object_get_domain (obj);

  function_get_info = NULL;
  function_set_rawFile = NULL;
  function_open_file = NULL;
  iter = NULL;
  while ((m = mono_class_get_methods (klass, &iter)))
    {
      if (strcmp (mono_method_get_name (m), "get_info") == 0)
	{
	  function_get_info = m;
	}
      else if (strcmp (mono_method_get_name (m), "openFile") == 0)
	{
	  function_open_file = m;
	}
      else if (strcmp (mono_method_get_name (m), "setRawFile") == 0)
	{
	  function_set_rawFile = m;
	}
      else
	{
	}
    }				//while
}

void
Rawrr::openFile ()
{
  MonoObject *exception;
  OUTPUT("OpenFile...");

  exception = NULL;

  mono_runtime_invoke (function_open_file, obj, NULL, &exception);

  if (exception)
    {
      OUTPUT("An exception was thrown while open raw file.");
    }
}

int
Rawrr::get_info ()
{
  MonoObject *exception;

  exception = NULL;

  MonoArray *result =
    (MonoArray *) mono_runtime_invoke (function_get_info, obj, NULL,
				       &exception);

  if (exception)
    {
      OUTPUT("An exception was thrown get_info().");
      return (-1);
    }

  for (unsigned int i = 0; i < mono_array_length (result); i++)
    {
      MonoString *s = mono_array_get (result, MonoString *, i);
      char *s2 = mono_string_to_utf8 (s);
      OUTPUT("INFO[" << i << "]: " << s2);
    }

  return (0);
}

void
Rawrr::dector ()
{
  mono_jit_cleanup (domain);
  OUTPUT("dector");
}
#endif



#ifndef MONO_EMBED_CPP_MAIN
// Expose the classes
RCPP_MODULE (RawrrMod)
{
  class_ < Rawrr >
    ("Rawrr").default_constructor ("Default constructor").
    method ("setAssembly", &Rawrr::setAssembly, "Set assembly path.").
    method ("setRawFile", &Rawrr::setRawFile, "Set path of Thermo Fisher raw file.").
    method ("setDomainName", &Rawrr::setDomainName, "Set the name of the domain.").
    method ("createObject", &Rawrr::createObject, "createObject.").
    method ("openFile", &Rawrr::openFile, "Opens raw file.").
    method ("dector", &Rawrr::dector, "Returns extra trailer of a given scan id.").
    method ("get_info", &Rawrr::get_info, "Returns the rawfile revision.");
}

#endif
