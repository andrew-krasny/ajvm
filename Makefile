ROOT_DIR  := $(abspath $(dir $(lastword $(MAKEFILE_LIST))))
SRC_DIR   := $(ROOT_DIR)/src
BUILD_DIR := $(shell pwd)/build
DIST_DIR  := $(shell pwd)

SOURCES := $(shell find $(SRC_DIR) -type f -name "*.c" -print)
OBJS    := $(SOURCES:$(SRC_DIR)/%.c=$(BUILD_DIR)/%.o)
DEPS    := $(OBJS:%.o=%.d)

CC      = gcc
CFLAGS  = -fno-stack-protector -D_GNU_SOURCE -g
LDFLAGS = -lpthread

WVM := $(DIST_DIR)/wvm

all: $(WVM)
	@ls -l $(WVM)

$(WVM): $(OBJS) | $(DIST_DIR)
	$(LINK.c) -o $@ $(OBJS)

$(OBJS):  $(BUILD_DIR)/%.o: $(SRC_DIR)/%.c | $(BUILD_DIR)
	$(COMPILE.c) -MMD -MP -MF $(@:%.o=%.d) -o $@ $<

$(DIST_DIR) $(BUILD_DIR):
	mkdir -p $@

clean:
	rm -rf $(BUILD_DIR) $(WVM)

-include $(DEPS)

.PHONY: all wvm
