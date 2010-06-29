PROGRAM := ../bin/run_sample

test:
	rm -f results.txt
	./test.bash ${PROGRAM} 1
	./test.bash ${PROGRAM} 2
	./test.bash ${PROGRAM} 3
	./test.bash ${PROGRAM} 4
	./test.bash ${PROGRAM} 5

clean:
	rm -f results.txt
	rm -f output/*
