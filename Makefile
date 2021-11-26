CPPFLAGS=-std=gnu++14 -DMONO_EMBED_CPP_MAIN -fPIC
mainlink: maincomp libhello
	g++ -o main main.o $(CPPFLAGS) -L`pwd` -lhello
maincomp:
	g++ -c main.cpp `pkg-config --cflags mono-2` $(CPPFLAGS)
clean:
	$(RM) -vfr *.json sourceCpp-x86_64-pc-linux-gnu-1.0.7 *.blob *.o *.so main
monobuild:
	xbuild && mono rawrrRcpp.exe 

Rcppbuild:
	R --no-save < Hello.R

libhello: complibhello
	gcc -shared -o libhello.so hello.o `pkg-config --libs mono-2` $(CPPFLAGS)  

complibhello:
	g++ -c -o hello.o hello.cpp `pkg-config --cflags mono-2` -lm $(CPPFLAGS)	
	
	
