EXECUTABLES = convolution convolutionIter convolutionIter2
CC=gcc49

all: $(EXECUTABLES)

LDFLAGS += $(foreach librarydir,$(subst :, ,$(LD_LIBRARY_PATH)),-L$(librarydir))

UNAME_S := $(shell uname -s)
ifeq ($(UNAME_S),Linux)
  LDFLAGS += -lrt -lOpenCL -lm
  CFLAGS += -Wall -std=gnu99 -g -O2
endif
ifeq ($(UNAME_S),Darwin)
  LDFLAGS +=  -framework OpenCL -lm
  CFLAGS += -Wall -std=c99 -g -O2
endif

ifdef OPENCL_INC
  CPPFLAGS = -I$(OPENCL_INC)
endif

ifdef OPENCL_LIB
  LDFLAGS = -L$(OPENCL_LIB)
endif

convolution.o: convolution.c cl-helper.h timing.h
cl-helper.o: cl-helper.c cl-helper.h
ppma_io.o: ppma_io.c ppma_io.h
convolutionIter.o: convolutionIter.c cl-helper.h timing.h
convolutionIter2.o: convolutionIter2.c cl-helper.h timing.h

convolution: convolution.o ppma_io.o cl-helper.o

convolutionIter: convolutionIter.o ppma_io.o cl-helper.o

convolutionIter2: convolutionIter2.o ppma_io.o cl-helper.o

clean:
	rm -f $(EXECUTABLES) *.o
