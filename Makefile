# Makefile for 32-bit Number Guessing Game

PROGRAM = guessinggame
SOURCE  = guessinggame.asm
OBJECT  = $(SOURCE:.asm=.o)

ASM     = nasm
LINKER  = ld

ASMFLAGS = -f elf32
LINKFLAGS = -m elf_i386

all: $(PROGRAM)

$(PROGRAM): $(OBJECT)
	$(LINKER) $(LINKFLAGS) -o $@ $<

$(OBJECT): $(SOURCE)
	$(ASM) $(ASMFLAGS) -o $@ $<

run: $(PROGRAM)
	./$(PROGRAM)

clean:
	rm -f $(OBJECT) $(PROGRAM)
