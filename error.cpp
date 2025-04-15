#include "error.hpp"
#include <iostream>

void error(const std::string &message) {
  std::cerr << "Error: " << message << std::endl;
}

void check_file(std::fstream &file, const std::string &filename) {
  file.open(filename, std::fstream::in);
  if (!file.is_open()) {
    error("File not found: " + filename);
    throw std::runtime_error("File not found");
  }
}
