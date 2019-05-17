all:
	hsc2hs src.hs -o Callback.hs
	ghc -dynamic -fPIC Callback.hs
	ghc -optl '-lHSrts-ghc8.0.1' -dynamic -shared sample.c Callback.o -o libcallback.so
	gcc -ldl dltest.c
	./a.out

clean:
	rm -f *.o *.so *_stub.h *~ a.out *.hi Callback.hs
