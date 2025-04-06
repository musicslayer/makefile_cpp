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
- Files ".clang-format" and ".clang-tidy" are present in the base folder.

In addition, the files generated while building will adhere to the following structure:
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
You can run Clang to format or lint your code:
```
make format
make lint
```

These will use ".clang-format" and ".clang-tidy" respectively. I recommend customizing those files to suit your needs.

# Running
There are 3 different ways to run the program:

```
make run       # Build and run the release version
make run-debug # Build and run the debug version
make run-gdb   # Build and run the debug version in gdb
```

If the executable doesn't exist or the source code has changed since it was last built, make will build/rebuild the code first. You can use the -j option to perform this building (if any) in parallel.

Note that "run" will run the release executable, while "run-debug" and "run-gdb" will use the debug executable. The makefile builds these two using different compiler flags, and thus there may be different behavior between the two.
- Release uses -O2 whereas debug uses -O0, changing the amount of optimizations applied.
- Debug uses -g to ensure that debugging symbols are generated.
 
# Command Line Options
This makefile provides one variable that can be configured via the command line: VERBOSE. For example, the following produces no output (as long as there are no errors):

```
make rebuild
```

Whereas the following will produce output:

```
make rebuild VERBOSE=1
g++ -I include -std=c++20 -Wall -Wextra -Werror -Wpedantic -MMD -MP -mconsole -DWIN32 -pthread -static -static-libgcc -static-libstdc++ -O2 -c src/app.cpp -o output/win_x86_64/build/release/app.o
g++ -I include -std=c++20 -Wall -Wextra -Werror -Wpedantic -MMD -MP -mconsole -DWIN32 -pthread -static -static-libgcc -static-libstdc++ -O2 -c src/main.cpp -o output/win_x86_64/build/release/main.o
g++ -I include -std=c++20 -Wall -Wextra -Werror -Wpedantic -MMD -MP -mconsole -DWIN32 -pthread -static -static-libgcc -static-libstdc++ -O2 -c src/sub/other.cpp -o output/win_x86_64/build/release/sub/other.o
g++ -I include -std=c++20 -Wall -Wextra -Werror -Wpedantic -MMD -MP -mconsole -DWIN32 -pthread -static -static-libgcc -static-libstdc++ -O2 output/win_x86_64/build/release/app.o output/win_x86_64/build/release/main.o output/win_x86_64/build/release/sub/other.o -o output/win_x86_64/bin/release/myapp
g++ -I include -std=c++20 -Wall -Wextra -Werror -Wpedantic -MMD -MP -mconsole -DWIN32 -pthread -static -static-libgcc -static-libstdc++ -g -O0 -c src/app.cpp -o output/win_x86_64/build/debug/app.o
g++ -I include -std=c++20 -Wall -Wextra -Werror -Wpedantic -MMD -MP -mconsole -DWIN32 -pthread -static -static-libgcc -static-libstdc++ -g -O0 -c src/main.cpp -o output/win_x86_64/build/debug/main.o
g++ -I include -std=c++20 -Wall -Wextra -Werror -Wpedantic -MMD -MP -mconsole -DWIN32 -pthread -static -static-libgcc -static-libstdc++ -g -O0 -c src/sub/other.cpp -o output/win_x86_64/build/debug/sub/other.o
g++ -I include -std=c++20 -Wall -Wextra -Werror -Wpedantic -MMD -MP -mconsole -DWIN32 -pthread -static -static-libgcc -static-libstdc++ -g -O0 output/win_x86_64/build/debug/app.o output/win_x86_64/build/debug/main.o output/win_x86_64/build/debug/sub/other.o -o output/win_x86_64/bin/debug/myapp_debug
```

Setting VERBOSE to 1 allows for additional output, whereas setting it to any other value (or not setting it at all) suppresses the output. Note that not all make operations will produce additional output with the VERBOSE option.
