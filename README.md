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

# Environments
This repository uses [GitHub Actions](https://github.com/musicslayer/makefile_cpp/actions) to test that this makefile works on Linux, MacOS, and Windows. There are three .yml files each capable of spawning a job run:
- build.yml will test that the code can be built
- lint.yml will lint the code
- run.yml will test that the code can be built and that the release version can run

Any output from linting and running is also copied into an artifact text file.

# Folder Structure
This makefile assumes a few things about the folder structure of your project:
- All cpp files are in a folder called "src". They may be in subfolders.
- All h files are in a folder called "include". They may be in subfolders.
- Files ".clang-format" and ".clang-tidy" are present in the base folder.

In addition, the files generated while building will adhere to the following structure:
- All built files will be contained in a folder called "output".
- Inside "output", a subfolder will be created based on the OS and architecture you are building on (e.g. win_x86_64).
- Inside the above subfolder, there are two additional subfolders:
  - bin - This contains subfolders "release" and "debug", each containing the appropriate executable program.
  - build - This contains subfolders "release" and "debug", each containing the appropriate intermediary files (.d and .o).

I believe this is a reasonable folder structure for most C++ projects.

# Building
There are a few commands used to build the C++ code:

```
make all     # Build everything
make debug   # Build the debug version
make release # Build the release version
```

Note that all of these can be done in parallel. For example:
```
make -j all
```

As described above, the generated files will be in different subfolders depending on the OS and architecture you are building on as well as if it is the release or debug build.

# Cleaning
You can remove all output files by executing:

```
make clean
```

# Formatting and Linting
You can run Clang to format or lint your code:
```
make format
make lint
```

These will use ".clang-format" and ".clang-tidy" respectively. You can use the -j option to perform these operations in parallel.

# Running
There are 3 different ways to run the program:

```
make run       # Build and run the release version
make run-debug # Build and run the debug version
make run-gdb   # Build and run the debug version in gdb
```

If the executable doesn't exist or the source code has changed since it was last built, make will build the code first. You can use the -j option to perform this building (if any) in parallel.

Note that "run" will run the release executable, while "run-debug" and "run-gdb" will use the debug executable. The makefile builds these two using different compiler flags, and thus there may be different behavior between the two.
- Release uses -O2 whereas debug uses -O0, changing the amount of optimizations applied.
- Debug uses -g to ensure that debugging symbols are generated.
 
# Command Line Options
This makefile provides one variable that can be configured via the command line: VERBOSE. For example, the following produces no output (as long as there are no errors):

```
make all
```

Whereas the following will produce output:

```
make all VERBOSE=1
g++ -I include -std=c++20 -Wall -Wextra -Werror -Wpedantic -MMD -MP -DWIN32 -mconsole -pthread -static -static-libgcc -static-libstdc++ -O2 -c src/app.cpp -o output/win_x86_64/build/release/app.o
g++ -I include -std=c++20 -Wall -Wextra -Werror -Wpedantic -MMD -MP -DWIN32 -mconsole -pthread -static -static-libgcc -static-libstdc++ -O2 -c src/main.cpp -o output/win_x86_64/build/release/main.o
g++ -I include -std=c++20 -Wall -Wextra -Werror -Wpedantic -MMD -MP -DWIN32 -mconsole -pthread -static -static-libgcc -static-libstdc++ -O2 -c src/sub/other.cpp -o output/win_x86_64/build/release/sub/other.o
g++ -I include -std=c++20 -Wall -Wextra -Werror -Wpedantic -MMD -MP -DWIN32 -mconsole -pthread -static -static-libgcc -static-libstdc++ -O2 output/win_x86_64/build/release/app.o output/win_x86_64/build/release/main.o output/win_x86_64/build/release/sub/other.o -o output/win_x86_64/bin/release/myapp
g++ -I include -std=c++20 -Wall -Wextra -Werror -Wpedantic -MMD -MP -DWIN32 -mconsole -pthread -static -static-libgcc -static-libstdc++ -g -O0 -c src/app.cpp -o output/win_x86_64/build/debug/app.o
g++ -I include -std=c++20 -Wall -Wextra -Werror -Wpedantic -MMD -MP -DWIN32 -mconsole -pthread -static -static-libgcc -static-libstdc++ -g -O0 -c src/main.cpp -o output/win_x86_64/build/debug/main.o
g++ -I include -std=c++20 -Wall -Wextra -Werror -Wpedantic -MMD -MP -DWIN32 -mconsole -pthread -static -static-libgcc -static-libstdc++ -g -O0 -c src/sub/other.cpp -o output/win_x86_64/build/debug/sub/other.o
g++ -I include -std=c++20 -Wall -Wextra -Werror -Wpedantic -MMD -MP -DWIN32 -mconsole -pthread -static -static-libgcc -static-libstdc++ -g -O0 output/win_x86_64/build/debug/app.o output/win_x86_64/build/debug/main.o output/win_x86_64/build/debug/sub/other.o -o output/win_x86_64/bin/debug/myapp_debug
```

Setting VERBOSE to 1 allows for additional output, whereas setting it to any other value (or not setting it at all) suppresses the output. Note that not all make operations will produce additional output with the VERBOSE option.
