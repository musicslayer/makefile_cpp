# C++ Makefile
C++ Makefile that can be reused in other projects

## Introduction
This repository contains a makefile and some simple C++ code. The purpose is to demonstrate the usage of a simple C++ makefile that can be dropped into other projects with minimal changes. Some examples of the functionality include:
- Parallel builds
- Clang formatting and linting
- Separate debug and release builds
- Separate folders for building on different operating systems and architectures
- Command line options such as verbosity
- Support for cpp and h files in subfolders

# Folder Structure
This makefile assumes a few things about the folder structure of your project:
- All cpp files are in a folder called "src". They may be in subfolders.
- All h files are in a folder called "include". They may be in subfolders.
- Files ".clang-format" and ".clang-tidy" are present.

In addtion, the files generated while building will adhere to the following structure:
- All built files will be contained in a folder called "output".
- Inside "output", a subfolder will be created based on the OS and architecture you are building on.
- Inside the above subfolder, there are two additional subfolders:
  - bin - This contains subfolders "release" and "debug", each containing the appropriate executable program.
  - build - This contains subfolders "release" and "debug", each containing the appropriate intermediary files (.d and .o).

I believe this is a reasonable folder structure for most C++ projects.

# Building
There are a few commands used to build the C++ code:
```
make all     # Build everything
make debug   # Build the debug version
make rebuild # Clean and rebuild everything
make release # Build the release version
```

Note that all of these (except rebuild) can be done in parallel. For example:
```
make -j8 all
```

# Cleaning
You can remove all output files by executing:
```
make clean
```

This should not be done in parallel, and there should be no need to since it is just deleting one folder.

# Formatting and Linting

# Running
