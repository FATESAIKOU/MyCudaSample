all: main.cu contral.o thread.o
	nvcc -O3 -o ga main.cu contral.o thread.o
	rm -f contral.o thread.o

contral.o: contral.cu
	nvcc -O3 -c contral.cu

thread.o: thread.c
	nvcc -O3 -c thread.cu
