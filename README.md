# mono.issue.21320


code snippet to reproduce https://github.com/mono/mono/issues/21320

- requirements:
  - Linux
  - current mono (v6.12)
  - g++
  - R 4.1 and package Rcpp 


## using plain C++ code
```
$ make
g++ -c main.cpp `pkg-config --cflags mono-2` -std=gnu++14 -DMONO_EMBED_CPP_MAIN -fPIC
g++ -c -o hello.o hello.cpp `pkg-config --cflags mono-2` -lm -std=gnu++14 -DMONO_EMBED_CPP_MAIN -fPIC
gcc -shared -o libhello.so hello.o `pkg-config --libs mono-2` -std=gnu++14 -DMONO_EMBED_CPP_MAIN -fPIC
g++ -o main main.o -std=gnu++14 -DMONO_EMBED_CPP_MAIN -fPIC -L`pwd` -lhello
cpanse@fgcz-c-073:~/__checkouts/mono.issue.21320 > make && ./main
g++ -c main.cpp `pkg-config --cflags mono-2` -std=gnu++14 -DMONO_EMBED_CPP_MAIN -fPIC
g++ -c -o hello.o hello.cpp `pkg-config --cflags mono-2` -lm -std=gnu++14 -DMONO_EMBED_CPP_MAIN -fPIC
gcc -shared -o libhello.so hello.o `pkg-config --libs mono-2` -std=gnu++14 -DMONO_EMBED_CPP_MAIN -fPIC
g++ -o main main.o -std=gnu++14 -DMONO_EMBED_CPP_MAIN -fPIC -L`pwd` -lhello
DomainName=rawrrrHello
hello.h
OpenFile...
INFO[0]: file:///home/cpanse/__checkouts/mono.issue.21320/helloRcpp.exe
INFO[1]: 995
INFO[2]: System.Diagnostics.Process (/home/cpanse/__checkouts/mono.issue.21320/main)
INFO[3]: currentProcess.Id:	39317
INFO[4]: PrivateMemorySize64 (KB):	34400
INFO[5]: Error message:
INFO[6]: raw file name:	hello.h
```

## using Rcpp and mono v6.12 &#10060;
```
$ export MONO_LOG_LEVEL=debug
$ export MONO_LOG_MASK=dll,cfg
$ R --no-save < Hello.R

...

R> R$openFile()
OpenFile...
Mono: DllImport attempting to load: '/usr/lib/../lib/libmono-native.so'.
Mono: DllImport error loading library '/usr/lib/../lib/libmono-native.so': '/usr/lib/../lib/libmono-native.so: undefined symbol: mono_add_internal_call_with_flags'.
Mono: DllImport error loading library '/usr/lib/../lib/libmono-native.so': '/usr/lib/../lib/libmono-native.so: undefined symbol: mono_add_internal_call_with_flags'.
Mono: DllImport error loading library '/usr/lib/../lib/libmono-native.so': '/usr/lib/../lib/libmono-native.so: undefined symbol: mono_add_internal_call_with_flags'.
Mono: DllImport error loading library '/usr/lib/../lib/libmono-native.so': '/usr/lib/../lib/libmono-native.so: undefined symbol: mono_add_internal_call_with_flags'.
Mono: DllImport error loading library '/usr/lib/../lib/libmono-native.so': '/usr/lib/../lib/libmono-native.so: undefined symbol: mono_add_internal_call_with_flags'.
Mono: DllImport unable to load library '/usr/lib/../lib/libmono-native.so'.
Mono: DllImport attempting to load: '/usr/lib/../lib/libmono-native.so'.
...

```

## using Rcpp and mono v5.18 &#9989;
```
cpanse@fgcz-c-073:~/__checkouts/mono.issue.21320  (main)> R --no-save < Hello.R 

R version 4.1.1 (2021-08-10) -- "Kick Things"
Copyright (C) 2021 The R Foundation for Statistical Computing
Platform: x86_64-pc-linux-gnu (64-bit)

R is free software and comes with ABSOLUTELY NO WARRANTY.
You are welcome to redistribute it under certain conditions.
Type 'license()' or 'licence()' for distribution details.

R is a collaborative project with many contributors.
Type 'contributors()' for more information and
'citation()' on how to cite R or R packages in publications.

Type 'demo()' for some demos, 'help()' for on-line help, or
'help.start()' for an HTML browser interface to help.
Type 'q()' to quit R.

R> #R
R> 
R> Sys.setenv("PKG_CPPFLAGS"="`pkg-config --cflags mono-2` -O3")
R> Sys.setenv("PKG_CXXFLAGS"="`pkg-config --cflags mono-2` -O3")
R> Sys.setenv("PKG_LIBS"="`pkg-config --libs mono-2`")
R> 
R> 
R> Rcpp::sourceCpp("hello.cpp", cacheDir = "/tmp/cpanse/Hello/", showOutput=TRUE, verbose=TRUE, rebuild = TRUE)

Generated extern "C" functions 
--------------------------------------------------------


#include <Rcpp.h>
#ifdef RCPP_USE_GLOBAL_ROSTREAM
Rcpp::Rostream<true>&  Rcpp::Rcout = Rcpp::Rcpp_cout_get();
Rcpp::Rostream<false>& Rcpp::Rcerr = Rcpp::Rcpp_cerr_get();
#endif


Generated R functions 
-------------------------------------------------------

`.sourceCpp_39_DLLInfo` <- dyn.load('/tmp/cpanse/Hello/sourceCpp-x86_64-pc-linux-gnu-1.0.7/sourcecpp_aecb61c06d74/sourceCpp_40.so')

library(Rcpp)
 populate( Rcpp::Module("RawrrMod",`.sourceCpp_39_DLLInfo`), environment() ) 

rm(`.sourceCpp_39_DLLInfo`)

Building shared library
--------------------------------------------------------

DIR: /tmp/cpanse/Hello/sourceCpp-x86_64-pc-linux-gnu-1.0.7/sourcecpp_aecb61c06d74

/usr/lib/R/bin/R CMD SHLIB --preclean -o 'sourceCpp_40.so' 'hello.cpp' 
g++ -std=gnu++14 -I"/usr/share/R/include" -DNDEBUG `pkg-config --cflags mono-2` -O3  -I"/home/cpanse/R/x86_64-pc-linux-gnu-library/4.1/Rcpp/include" -I"/home/cpanse/__checkouts/mono.issue.21320"   `pkg-config --cflags mono-2` -O3 -fpic  -g -O2 -fdebug-prefix-map=/home/jranke/git/r-backports/buster/r-base-4.1.1=. -fstack-protector-strong -Wformat -Werror=format-security -Wdate-time -D_FORTIFY_SOURCE=2 -g  -c hello.cpp -o hello.o
g++ -std=gnu++14 -shared -L/usr/lib/R/lib -Wl,-z,relro -o sourceCpp_40.so hello.o -L/usr/lib/pkgconfig/../../lib -lmono-2.0 -lm -lrt -ldl -lpthread -L/usr/lib/R/lib -lR
R> 
R> f <- "hello.h"
R> 
R> 
R> R <- new(Rawrr)
R> R$setDomainName("Hello")
DomainName=rawrrrHello
R> R$createObject()
mono_object_new ... [DONE]
mono_runtime_object_init ... [DONE]
R> R$setRawFile(f)
hello.h
R> R$get_info()
INFO[0]: file:///home/cpanse/__checkouts/mono.issue.21320/helloRcpp.exe
INFO[1]: 
INFO[2]: System.Diagnostics.Process (/usr/lib/R/bin/exec/R)
INFO[3]: currentProcess.Id:	44747
INFO[4]: PrivateMemorySize64 (KB):	96716
INFO[5]: Error message:	
INFO[6]: raw file name:	hello.h
[1] 0
R> R$openFile()
OpenFile...
R> R$get_info()
INFO[0]: file:///home/cpanse/__checkouts/mono.issue.21320/helloRcpp.exe
INFO[1]: 995
INFO[2]: System.Diagnostics.Process (/usr/lib/R/bin/exec/R)
INFO[3]: currentProcess.Id:	44747
INFO[4]: PrivateMemorySize64 (KB):	96716
INFO[5]: Error message:	
INFO[6]: raw file name:	hello.h
[1] 0
R> 
R> packageVersion("Rcpp")
[1] '1.0.7'
R> # Sys.getenv()   
R> 
cpanse@fgcz-c-073:~/__checkouts/mono.issue.21320  (main)> 

```



