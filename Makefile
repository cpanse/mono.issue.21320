# Christian Panse <cp@fgcz.ethz.ch>
# Zurich 2021-11-27 
# test code snippet to invoke managed code from R and C++

CPPFLAGS=-std=gnu++14 -DMONO_EMBED_CPP_MAIN -fPIC

run: runRcpp runmain

runmain: linkmain monobuild
	export LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:${PWD} && ./main
	# export LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:${PWD} && export MONO_LOG_LEVEL=debug && export MONO_LOG_MASK=dll,cfg && ./main

linkmain: compmain libhello
	g++ -o main main.o $(CPPFLAGS) -L`pwd` -lhello

compmain:
	g++ -c main.cpp `pkg-config --cflags mono-2` $(CPPFLAGS)


monobuild:
	xbuild || msbuild

runRcpp:
	R --no-save < Hello.R

libhello: complibhello
	gcc -shared -o libhello.so hello.o `pkg-config --libs mono-2` $(CPPFLAGS)  

complibhello:
	g++ -c -o hello.o hello.cpp `pkg-config --cflags mono-2` -lm $(CPPFLAGS)	

clean:
	$(RM) -vfr *.json Rcpptmp *.o *.so main *.exe
