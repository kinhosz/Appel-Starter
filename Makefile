# =============================================================================
#   Appel Starter Pack - Main Makefile
#   Wraps the Appel Engine build system and compiles the User Game.
# =============================================================================

# --- Project Configuration ---
APP_NAME  := Game
SRC_DIR   := src
OBJ_DIR   := obj
BIN_DIR   := bin
LIB_DIR   := lib

# --- Engine Configuration ---
APPEL_DIR     := Appel
APPEL_OBJ_DIR := $(APPEL_DIR)/bin/obj
APPEL_INC     := -I$(APPEL_DIR)/include

# --- Settings ---
# EGPU=0 disables GPU (CUDA) support by default.
EGPU ?= 0

# --- Compiler & Flags ---
CXX      := g++
# Includes: Engine headers + Local 'include' + Local 'lib' + Local 'src'
INCLUDES := $(APPEL_INC) -Iinclude -I$(LIB_DIR) -I$(SRC_DIR)
CXXFLAGS := -std=c++17 -O3 -Wall $(INCLUDES)

# --- Linker & Libraries ---
# 1. Path to SFML .so/.a files within the Engine
SFML_LIB_PATH := $(APPEL_DIR)/lib/SFML/

# 2. Linker Configuration
# -L: Where to search for libraries at compile time
# -Wl,-rpath: Where to search for libraries at RUNTIME (avoids "cannot open shared object file" error)
LDFLAGS  := -L$(LIB_DIR) -L$(SFML_LIB_PATH) \
            -Wl,-rpath,'$$ORIGIN/../$(SFML_LIB_PATH)' \
            -lsfml-audio -lsfml-graphics -lsfml-network -lsfml-system -lsfml-window

# --- Source Management ---
# 1. User Sources (Your Game)
SRCS := $(wildcard $(SRC_DIR)/*.cpp)
OBJS := $(patsubst $(SRC_DIR)/%.cpp, $(OBJ_DIR)/%.o, $(SRCS))

# =============================================================================
#   Main Rules
# =============================================================================

.PHONY: all game clean clear tests unit install check_engine_build

# Default target: Build the game
all: game

# --- Game Compilation Rule ---
game: check_engine_build $(BIN_DIR)/$(APP_NAME)

$(BIN_DIR)/$(APP_NAME): $(OBJS)
	@echo "🎮 [Starter] Linking Game Executable..."
	@mkdir -p $(BIN_DIR)
	@$(CXX) $(OBJS) $$(find $(APPEL_OBJ_DIR) -name '*.o' ! -name 'main.o') -o $@ $(LDFLAGS)
	@echo "✅ Success! Run with: ./$(BIN_DIR)/$(APP_NAME)"

# Compile User Source Files (.cpp -> .o)
$(OBJ_DIR)/%.o: $(SRC_DIR)/%.cpp
	@mkdir -p $(OBJ_DIR)
	$(CXX) $(CXXFLAGS) -c $< -o $@

# --- Engine Helper ---
# Checks if engine objects exist. If not, forces the Engine Makefile to run 'tests'.
check_engine_build:
	@# Checks if any .o file exists in the engine directory
	@if [ -z "$$(ls -A $(APPEL_OBJ_DIR)/*.o 2>/dev/null)" ]; then \
		echo "⚙️  [Starter] Engine objects not found. Building Appel Engine first..."; \
		$(MAKE) -C $(APPEL_DIR) tests EGPU=$(EGPU); \
	else \
		echo "⚙️  [Starter] Engine objects found. Using existing binaries."; \
	fi

# =============================================================================
#   Proxy Rules (Forwarding commands to Appel Engine)
# =============================================================================

# Run Engine Integration Tests
tests:
	@echo "🧪 [Starter] Forwarding 'tests' to Engine..."
	@$(MAKE) -C $(APPEL_DIR) tests EGPU=$(EGPU)

# Run Engine Unit Tests (Usage: make unit FNAME=tests/file.cpp)
unit:
	@if [ -z "$(FNAME)" ]; then \
		echo "❌ Error: Please specify FNAME (e.g., make unit FNAME=tests/geometry/vector.cpp)"; \
		exit 1; \
	fi
	@echo "🔬 [Starter] Forwarding 'unit' to Engine..."
	@$(MAKE) -C $(APPEL_DIR) unit FNAME=$(FNAME) EGPU=$(EGPU)

# Install Dependencies (SFML, etc.) via Engine script
install:
	@echo "📦 [Starter] Installing dependencies..."
	@$(MAKE) -C $(APPEL_DIR) install

# =============================================================================
#   Cleaning
# =============================================================================

# Clear everything (Starter + Engine)
clear: clean

clean:
	@echo "🧹 [Starter] Cleaning local build..."
	@rm -rf $(OBJ_DIR) $(BIN_DIR)
	@echo "🧹 [Starter] Cleaning Engine build..."
	@$(MAKE) -C $(APPEL_DIR) clear

# =============================================================================
#   Shortcuts
# =============================================================================

# Build and Run
run: game
	@echo "🚀 Running Game..."
	@./$(BIN_DIR)/$(APP_NAME)
