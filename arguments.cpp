#include "arguments.hpp"
void help_instruction(char *input) {
  std::string option = input;
  if (option == "--help" || option == "-h") {
    std::cout << "Bit!" << std::endl;
    std::cout << "Bit is a simplified version of makefiles designed to ease "
                 "the process of building C++ projects."
              << std::endl;
    std::cout << std::endl;
    std::cout << "Usage:" << std::endl;
    std::cout
        << "  bit                   Build the project using the build.bit file."
        << std::endl;
    std::cout << "  bit -h | --help       Show this help message." << std::endl;
    std::cout << "  bit -v | --version    Show the version of the project."
              << std::endl;
    std::cout << std::endl;
    std::cout << "Getting Started:" << std::endl;
    std::cout << "1. Create a 'build.bit' file in your project directory."
              << std::endl;
    std::cout << "2. Add the necessary build configuration inside it, like:"
              << std::endl;
    std::cout << "     compiler=g++" << std::endl;
    std::cout << "     build_file=app" << std::endl;
    std::cout << "     source_file=main.cpp" << std::endl;
    std::cout << "     build_type=executable" << std::endl;
    std::cout << "3. Run 'bit' to build your project." << std::endl;
    std::cout << std::endl;
    std::cout << "For more information, refer to the reference and "
                 "contribution documentation."
              << std::endl;
    std::cout << "Project URL: https://github.com/csodelinux/bit" << std::endl;
  } else if (option == "--version" || option == "-v") {
    std::cout << VERSION << std::endl;
  } else {
    std::cerr << "Enter a valid input" << std::endl;
  }
}
