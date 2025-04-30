#pragma once
#include <string>
#include <fstream>

enum class MessageType {
  ERROR,
  WARNING,
  BUILD,
  HINT
};

void log(const std::string &message, MessageType type);
void error(const std::string &message);
void warning(const std::string &message);
void build_info(const std::string &message);
void hint(const std::string &message);
void syntax(const std::string &message, struct commands command);
void check_file(std::fstream &file, const std::string &filename);

