#include "error.hpp"
#include "parser.hpp"
#include <iostream>

#ifdef _WIN32
#include <windows.h>
void setConsoleColor(WORD color) {
  HANDLE hConsole = GetStdHandle(STD_OUTPUT_HANDLE);
  SetConsoleTextAttribute(hConsole, color);
}
#else
void setConsoleColor(const std::string &colorCode) { std::cout << colorCode; }
#endif

void log(const std::string &message, MessageType type) {
#ifdef _WIN32
  switch (type) {
  case MessageType::ERROR:
    setConsoleColor(FOREGROUND_RED | FOREGROUND_INTENSITY);
    break;
  case MessageType::WARNING:
    setConsoleColor(FOREGROUND_RED | FOREGROUND_GREEN | FOREGROUND_INTENSITY);
    break;
  case MessageType::BUILD:
    setConsoleColor(FOREGROUND_GREEN | FOREGROUND_INTENSITY);
    break;
  case MessageType::HINT:
    setConsoleColor(FOREGROUND_BLUE | FOREGROUND_INTENSITY);
    break;
  }
  std::cerr << message << std::endl;
  setConsoleColor(FOREGROUND_RED | FOREGROUND_GREEN | FOREGROUND_BLUE);
#else
  switch (type) {
  case MessageType::ERROR:
    setConsoleColor("\033[1;31m");
    break;
  case MessageType::WARNING:
    setConsoleColor("\033[1;33m");
    break;
  case MessageType::BUILD:
    setConsoleColor("\033[1;32m");
    break;
  case MessageType::HINT:
    setConsoleColor("\033[1;34m");
    break;
  }
  std::cerr << message << "\033[0m" << std::endl;
#endif
}

void error(const std::string &message) {
  log("Error: " + message, MessageType::ERROR);
}

void warning(const std::string &message) {
  log("Warning: " + message, MessageType::WARNING);
}

void build_info(const std::string &message) {
  log("Build: " + message, MessageType::BUILD);
}

void hint(const std::string &message) {
  log("Hint: " + message, MessageType::HINT);
}

void syntax(const std::string &message, commands command) {
  error("Syntax Error: " + message);
}

void check_file(std::fstream &file, const std::string &filename) {
  file.open(filename, std::fstream::in);
  if (!file.is_open()) {
    error("File is not found: " + filename);
    hint("Please consider adding the build file.");
    throw std::runtime_error("File not found");
  }
}
