# mono.issue.21320


code snippet to reproduce https://github.com/mono/mono/issues/21320

- requirements:
  - Linux
  - current mono 
  - g++
  - R 4.1


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



