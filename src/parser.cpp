#include "parser.hpp"
#include "error.hpp"
#include <iostream>

std::string trimWhitespace(const std::string &str) {
  size_t start = str.find_first_not_of(" \t\n\r\f\v");
  if (start == std::string::npos)
    return "";
  size_t end = str.find_last_not_of(" \t\n\r\f\v");
  return str.substr(start, end - start + 1);
}

std::string readFromEqualToEnd(const std::string &line) {
  size_t equalPos = line.find('=');
  if (equalPos == std::string::npos)
    return "";
  std::string result = line.substr(equalPos + 1);
  return trimWhitespace(result);
}

void extract(std::fstream &file, std::string &line,
             std::vector<std::string> &lines) {
  while (getline(file, line)) {
    lines.push_back(line);
  }
}

void processCommand(
    const std::string &line, const std::string &expectedCommand,
    commands &build_command,
    const std::function<void(commands &, const std::string &)> &setter) {
  if (line.find(expectedCommand) == 0) {
    std::string value = readFromEqualToEnd(line);
    if (!value.empty()) {
      setter(build_command, value);
    }
  }
}

void compiler(std::vector<std::string> &lines, commands &build_command) {
  for (const auto &line : lines) {
    processCommand(
        line, "compiler", build_command,
        [](commands &cmd, const std::string &value) { cmd.compiler = value; });
  }
  if (build_command.compiler.empty()) {
    error("No compiler is set");
    hint("Please consider adding a compiler");
    exit(1);
  } else {
    build_command.compiler = build_command.compiler + " ";
  }
}

void compiler_flag(std::vector<std::string> &lines, commands &build_command) {
  for (const auto &line : lines) {
    processCommand(line, "flags", build_command,
                   [](commands &cmd, const std::string &value) {
                     cmd.compile_flags = value;
                   });
  }
  if (build_command.compile_flags.empty()) {
    warning("No compiler flag set. Setting default");
    build_command.compile_flags = "";
  } else {
    build_command.compile_flags = build_command.compile_flags + " ";
  }
}

void build_dir(std::vector<std::string> &lines, commands &build_command) {
  for (const auto &line : lines) {
    processCommand(
        line, "build_dir", build_command,
        [](commands &cmd, const std::string &value) { cmd.build_dir = value; });
  }
  if (build_command.build_dir.empty()) {
    warning("No build directory set. Setting default");
    build_command.build_dir = "";
    return;
  }
  make_dir(build_command.build_dir);
  build_command.build_dir = build_command.build_dir + "/";
}

void build_file(std::vector<std::string> &lines, commands &build_command) {
  for (const auto &line : lines) {
    processCommand(line, "build_file", build_command,
                   [](commands &cmd, const std::string &value) {
                     cmd.build_file = value;
                   });
  }
  if (build_command.build_file.empty()) {
    build_command.build_file = "app ";
    warning("No build file name specified. Defaulting to name app.");
  } else {
    build_command.build_file = build_command.build_file + " ";
  }
}

void source_file(std::vector<std::string> &lines, commands &build_command) {
  for (const auto &line : lines) {
    processCommand(line, "source_file", build_command,
                   [](commands &cmd, const std::string &value) {
                     cmd.source_file = value;
                   });
  }
  if (build_command.source_file.empty()) {
    error("No source file set");
    exit(1);
  }
}

void build_type(std::vector<std::string> &lines, commands &build_command) {
  for (const auto &line : lines) {
    processCommand(
        line, "build_type", build_command,
        [](commands &cmd, const std::string &value) {
          if (value == "executable") {
            cmd.build_type = "-o ";
          } else if (value == "library") {
            cmd.build_type = "-c ";
          } else {
            error("Invalid build type. Must be 'executable' or 'library'");
          }
        });
  }
  if (build_command.build_type.empty()) {
    error("No build type set");
    exit(1);
  }
}

void make_dir(const std::string &dir_name) {
  if (!std::filesystem::exists(dir_name)) {
    std::filesystem::create_directory(dir_name);
  }
}
void exec(commands &build_command) {
  if (build_command.compiler.empty() || build_command.source_file.empty()) {
    error("Missing required build parameters");
    return;
  }
  std::string path = build_command.build_dir.c_str();
  std::string cmd = build_command.compiler + build_command.compile_flags +
                    build_command.build_type + build_command.build_dir +
                    build_command.build_file + build_command.source_file;
  build_info("Running: " + cmd);
  
  if (system(cmd.c_str()) != 0) {
    error("Build command failed");
  }
}
