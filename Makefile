# Christian Panse <cp@fgcz.ethz.ch>
# Zurich 2021-11-27 
# test code snippet to invoke managed code from R and C++
CC=gcc
CPP=g++

#PKG_CONFIG_PATH=/usr/local/lib/pkgconfig
CPPFLAGS=-std=gnu++14 -DMONO_EMBED_CPP_MAIN -fPIC -Wl,-rpath,$(PWD) $(shell pkg-config --cflags mono-2 )
RCPPFLAGS=$(shell pkg-config --cflags mono-2 ) -O3
LDFLAGS=$(shell pkg-config --libs mono-2 )
MLOGLEV=debug
MLOGMASK=dll,cfg
#MLOGMASK=all

run: runRcpp runmain

runmain: linkmain monobuild
	# export LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:${PWD} && export MONO_LOG_LEVEL=debug && export MONO_LOG_MASK=dll,cfg && ./main
	@echo "==================== START RUNMAIN"
	MONO_LOG_LEVEL="$(MLOGLEV)" MONO_LOG_MASK="$(MLOGMASK)" ./main
	@echo "==================== END RUNMAIN"

linkmain: compmain libhello
	$(CPP) -o main main.o $(CPPFLAGS) -L$(PWD) -lhello

compmain:
	$(CPP) -c main.cpp $(CPPFLAGS)

monobuild:
	xbuild || msbuild


runRcpp: Hello.R monobuild
	@echo "********************* RUN R Hello.R"
	PKG_CPPFLAGS="$(RCPPFLAGS)" PKG_LIBS="$(LDFLAGS)" MONO_LOG_LEVEL="$(MLOGLEV)" MONO_LOG_MASK="$(MLOGMASK)" R --no-save < Hello.R
	@echo "********************* END R Hello.R"

libhello: complibhello
	$(CC) -shared -o libhello.so hello.o $(LDFLAGS) $(CPPFLAGS)  

complibhello:
	$(CPP) -c -o hello.o hello.cpp $(LDFLAGS) $(CPPFLAGS)	

clean:
	$(RM) -vfr *.json Rcpptmp *.o *.so main *.exe
