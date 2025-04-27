#pragma once
#include "error.hpp"
#include <filesystem>
#include <fstream>
#include <functional>
#include <string>
#include <vector>

struct commands {
  std::string compiler;
  std::string compile_flags;
  std::string build_file;
  std::string build_dir;
  std::string source_file;
  std::string build_type;
};

std::string trimWhitespace(const std::string &str);
std::string readFromEqualToEnd(const std::string &line);
void extract(std::fstream &file, std::string &line,
             std::vector<std::string> &lines);
void processCommand(
    const std::string &line, const std::string &expectedCommand,
    commands &build_command,
    const std::function<void(commands &, const std::string &)> &setter);
void compiler(std::vector<std::string> &lines, commands &build_command);
void compiler_flag(std::vector<std::string> &lines, commands &build_command);
void build_file(std::vector<std::string> &lines, commands &build_command);
void build_dir(std::vector<std::string> &lines, commands &build_command);
void source_file(std::vector<std::string> &lines, commands &build_command);
void build_type(std::vector<std::string> &lines, commands &build_command);
void make_dir(const std::string &dir_name);
void exec(commands &build_command);
