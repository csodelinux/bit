#include "arguments.hpp"
#include "error.hpp"
#include "parser.hpp"
#include <iostream>

int main(int args, char *argv[]) {
  if (args > 1) {
    help_instruction(argv[1]);
    return 0;
  }
  commands cmd;
  std::fstream file;
  std::string line;
  std::vector<std::string> lines;

  check_file(file, "build.bit");
  extract(file, line, lines);
  file.close();

  compiler(lines, cmd);
  compiler_flag(lines, cmd);
  build_dir(lines, cmd);
  build_file(lines, cmd);
  source_file(lines, cmd);
  build_type(lines, cmd);

  exec(cmd);
  return 0;
}
