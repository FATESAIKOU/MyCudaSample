gpu-read: readFile.cu fileParser.o
	nvcc -g -o gpu-read readFile.cu fileParser.o -ll

fileParser.o: flex/fileParser.l
	flex -o flex/fileParser.c flex/fileParser.l
	gcc -g -c -o fileParser.o flex/fileParser.c -ll

clean:
	rm -f *.o flex/fileParser.c gpu-read
