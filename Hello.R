#R

Sys.setenv("PKG_CPPFLAGS"="`pkg-config --cflags mono-2` -O3")
Sys.setenv("PKG_CXXFLAGS"="`pkg-config --cflags mono-2` -O3")
Sys.setenv("PKG_LIBS"="`pkg-config --libs mono-2`")


Rcpp::sourceCpp("hello.cpp", cacheDir = "/tmp/cpanse/Hello/", showOutput=TRUE, verbose=TRUE, rebuild = TRUE)

f <- "hello.h"


R <- new(Rawrr)
R$setDomainName("Hello")
R$createObject()
R$setRawFile(f)
R$get_info()
R$openFile()
R$get_info()

packageVersion("Rcpp")
# Sys.getenv()   
