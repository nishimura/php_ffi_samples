PARSEC=/usr/lib/haskell-packages/ghc/lib/x86_64-linux-ghc-8.0.1/parsec-3.1.11-BCos4GEVCuDB8dnOCBHO6X

OPT1=-optl-L$(PARSEC) -optl-Wl,-rpath,$(PARSEC)
OPT2=-optl '-lHSparsec-3.1.11-BCos4GEVCuDB8dnOCBHO6X-ghc8.0.1'

all: bridge.hs
	ghc -dynamic -fPIC bridge.hs
	ghc -optl '-lHSrts-ghc8.0.1' \
		$(OPT1) $(OPT2) \
		-dynamic -shared bridge.o HsTemplate.o -o libtemplate.so
	gcc -ldl dltest.c
	./a.out

bridge.hs: src.hs
	hsc2hs src.hs -o bridge.hs



clean:
	rm -f *.o *.so *_stub.h *~ a.out *.hi bridge.hs
