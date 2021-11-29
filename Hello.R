#R
Sys.getenv("PKG_CONFIG_PATH")
Sys.getenv("PKG_CPPFLAGS")
Sys.getenv("PKG_LIBS")
Sys.getenv("MONO_LOG_LEVEL")
Sys.getenv("MONO_LOG_MASK")

Rcpp::sourceCpp("hello.cpp", cacheDir = "Rcpptmp", showOutput=TRUE, verbose=TRUE, rebuild = TRUE)

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
