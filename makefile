# Command Line Options
# Set VERBOSE=1 to see all output, otherwise everything except errors will be suppressed.
AT = $(if $(filter 1,$(VERBOSE)),,@)

# OS and Architecture
OS_FULL_NAME := $(shell uname -s)
OS_NAME =
ifeq ($(OS_FULL_NAME),Linux)
    OS_NAME = linux
endif
ifeq ($(OS_FULL_NAME),Darwin)
    OS_NAME = mac
endif
ifneq (,$(findstring MINGW,$(OS_FULL_NAME)))
    OS_NAME = win
endif

ifeq ($(strip $(OS_NAME)),)
    $(error Unsupported OS: $(OS_FULL_NAME))
endif

ARCH_NAME := $(shell uname -m)
OS_ARCH_NAME = $(OS_NAME)_$(ARCH_NAME)

# Tools
CLANG_FORMAT := clang-format
CLANG_TIDY := clang-tidy
SHELL := bash

# App Information
APP_NAME_RELEASE := myapp
APP_NAME_DEBUG := myapp_debug

# Source
SRC_DIR := src
SRCS := $(shell bash -c 'shopt -s globstar nullglob; echo $(SRC_DIR)/**/*.cpp')
HDR_DIR := include
HDRS := $(shell bash -c 'shopt -s globstar nullglob; echo $(HDR_DIR)/**/*.h')

# Compiler
CXX := g++

CXXFLAGS := -I $(HDR_DIR) -std=c++20 -Wall -Wextra -Werror -Wpedantic -MMD -MP
ifeq ($(OS_NAME),linux)
    CXXFLAGS += -DLINUX
endif
ifeq ($(OS_NAME),mac)
    CXXFLAGS += -DMACOS
endif
ifeq ($(OS_NAME),win)
    CXXFLAGS += -DWIN32 -mconsole -pthread -static -static-libgcc -static-libstdc++
endif

CXXFLAGS_LINT := $(CXXFLAGS) -Wno-unknown-warning-option -Wno-unused-command-line-argument
CXXFLAGS_RELEASE := $(CXXFLAGS) -O2
CXXFLAGS_DEBUG := $(CXXFLAGS) -g -O0

# Output
OUTPUT_DIR := output
BUILD_DIR := $(OUTPUT_DIR)/$(OS_ARCH_NAME)/build
BIN_DIR := $(OUTPUT_DIR)/$(OS_ARCH_NAME)/bin

BUILD_DIR_RELEASE := $(BUILD_DIR)/release
BUILD_DIR_DEBUG := $(BUILD_DIR)/debug
BIN_DIR_RELEASE := $(BIN_DIR)/release
BIN_DIR_DEBUG := $(BIN_DIR)/debug

OBJS_RELEASE := $(subst $(SRC_DIR)/, $(BUILD_DIR_RELEASE)/, $(SRCS:.cpp=.o))
OBJS_DEBUG := $(subst $(SRC_DIR)/, $(BUILD_DIR_DEBUG)/, $(SRCS:.cpp=.o))

DEPS_RELEASE := $(OBJS_RELEASE:.o=.d)
DEPS_DEBUG := $(OBJS_DEBUG:.o=.d)
-include $(DEPS_RELEASE) $(DEPS_DEBUG)

# Build Rules
$(BUILD_DIR_RELEASE)/%.o: $(SRC_DIR)/%.cpp
	@mkdir -p $(dir $@)
	$(AT)$(CXX) $(CXXFLAGS_RELEASE) -c $< -o $@

$(BUILD_DIR_DEBUG)/%.o: $(SRC_DIR)/%.cpp
	@mkdir -p $(dir $@)
	$(AT)$(CXX) $(CXXFLAGS_DEBUG) -c $< -o $@

$(BIN_DIR_RELEASE)/$(APP_NAME_RELEASE): $(OBJS_RELEASE)
	@mkdir -p $(dir $@)
	$(AT)$(CXX) $(CXXFLAGS_RELEASE) $^ -o $@

$(BIN_DIR_DEBUG)/$(APP_NAME_DEBUG): $(OBJS_DEBUG)
	@mkdir -p $(dir $@)
	$(AT)$(CXX) $(CXXFLAGS_DEBUG) $^ -o $@

# Targets
.DEFAULT_GOAL := all

.PHONY: all
all: release debug

.PHONY: clean
clean:
	@rm -rf "$(OUTPUT_DIR)"

.PHONY: debug
debug: $(BIN_DIR_DEBUG)/$(APP_NAME_DEBUG)

.PHONY: format
format:
	@echo "Formatting source files..."
	@$(CLANG_FORMAT) -i $(SRCS) $(HDRS)

.PHONY: help
help:
	@echo "Available targets:"
	@echo "  make all       - Build everything"
	@echo "  make clean     - Remove all build artifacts"
	@echo "  make debug     - Build the debug version"
	@echo "  make format    - Run the formatter (uses .clang-format)"
	@echo "  make help      - View all available targets"
	@echo "  make lint      - Run the linter (uses .clang-tidy)"
	@echo "  make rebuild   - Clean and rebuild everything"
	@echo "  make release   - Build the release version"
	@echo "  make run       - Build and run the release version"
	@echo "  make run-debug - Build and run the debug version"
	@echo "  make run-gdb   - Build and run the debug version in gdb"

.PHONY: lint
lint:
	@echo "Linting source files..."
	@$(CLANG_TIDY) --quiet $(SRCS) $(HDRS) -- -x c++ $(CXXFLAGS_LINT)

.PHONY: rebuild
rebuild:
	@$(MAKE) --no-print-directory clean
	@$(MAKE) --no-print-directory all

.PHONY: release
release: $(BIN_DIR_RELEASE)/$(APP_NAME_RELEASE)

.PHONY: run
run: release
	@$(BIN_DIR_RELEASE)/$(APP_NAME_RELEASE)

.PHONY: run-debug
run-debug: debug
	@$(BIN_DIR_DEBUG)/$(APP_NAME_DEBUG)

.PHONY: run-gdb
run-gdb: debug
	@gdb --args $(BIN_DIR_DEBUG)/$(APP_NAME_DEBUG)