CXX = g++
CXXFLAGS = -Wall -Werror -std=c++17

TARGET = bit
SRC = bit.cpp parser.cpp error.cpp 

PREFIX ?= /usr/local
BINDIR = $(PREFIX)/bin

all:
	@echo ""
	@echo "Usage:"
	@echo "  make build            # Build the project"
	@echo "  make install          # Install to $(BINDIR)"
	@echo "  make PREFIX=~/local install  # Install to custom location"
	@echo "  sudo make system-install     # Install to /usr/bin"
	@echo "  make clean            # Remove build artifacts"
	@echo ""

build: $(TARGET)

$(TARGET): $(SRC)
	$(CXX) $(CXXFLAGS) -o $@ $^

install: $(TARGET)
	install -d $(BINDIR)
	install -m 755 $(TARGET) $(BINDIR)

system-install: $(TARGET)
	install -m 755 $(TARGET) /usr/bin

clean:
	rm -f $(TARGET)

.PHONY: all build install system-install clean

