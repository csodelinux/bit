#pragma once
#include <fstream>
#include <stdexcept>
#include <string>
void error(const std::string &message);
void check_file(std::fstream &file, const std::string &filename);
