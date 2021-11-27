CPPFLAGS=-std=gnu++14 -DMONO_EMBED_CPP_MAIN -fPIC

run: mainlink monobuild Rcppbuild
	export LD_LIBRARY_PATH=${LD_LIBRARY_PATH}:${PWD} && export MONO_LOG_LEVEL=debug && export MONO_LOG_MASK=dll,cfg && ./main
mainlink: libhello
	g++ -o main main.o $(CPPFLAGS) -L`pwd` -lhello
maincomp:
	g++ -c main.cpp `pkg-config --cflags mono-2` $(CPPFLAGS)
clean:
	$(RM) -vfr *.json sourceCpp-x86_64-pc-linux-gnu-1.0.7 *.blob *.o *.so main *.exe
monobuild:
	xbuild || msbuild

Rcppbuild:
	R --no-save < Hello.R

libhello: complibhello
	gcc -shared -o libhello.so hello.o `pkg-config --libs mono-2` $(CPPFLAGS)  

complibhello:
	g++ -c -o hello.o hello.cpp `pkg-config --cflags mono-2` -lm $(CPPFLAGS)	
	
	
