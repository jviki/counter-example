GHDL = ghdl

all: run-counter_test
clean:
	git clean -xfd

counter_test: counter.vhd counter_test.vhd
	$(GHDL) -a $^
	$(GHDL) -e $@

run-counter_test: counter_test
	./$< --stop-time=1us --wave=counter_test.ghw

.PHONY: all clean run-counter_test
