TARGET = dalvikvm
SRC_CC = main.cc dalvikvm.cc

DALVIKVM_DIR := $(call select_from_ports,libart)/art/dalvikvm
vpath %.cc $(DALVIKVM_DIR)

LIBS += libnativehelper liblog stdcxx libart
