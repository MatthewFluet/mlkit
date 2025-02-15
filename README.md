## MLKit

The [MLKit](http://elsman.com/mlkit) is a compiler toolkit for the
Standard ML language, including **The MLKit with Regions**, a native
backend for the x86 architecture, based on region inference, and
**SMLtoJs**, a JavaScript backend targeting web browsers. The two
compilers share the same frontend and compilation management scheme.

The MLKit covers all of Standard ML, as defined in the 1997 edition of
the Definition of Standard ML and supports most of the [Standard ML
Basis Library](http://elsman.com/mlkit/basis.html).

## Test Statistics and Benchmarking

[![CI](https://github.com/melsman/mlkit/workflows/CI/badge.svg)](https://github.com/melsman/mlkit/actions) [Benchmarking](https://elsman.com/mlkit-bench/)

## Installation

Under macOS, MLKit is available through Homebrew: Just execute `brew
install mlkit`. Under Linux, you may install a binary version of MLKit
by downloading a binary tgz-distribution and following the embedded
README-file.

## General Features

- **Compiles all of Standard ML**. The MLKit compiles all of Standard ML, [including Modules](http://elsman.com/mlkit/staticinterp.html), as specified by
  the Definition of Standard ML. The MLKit also supports most of the
  [Standard ML Basis Library](http://elsman.com/mlkit/basis.html).

- **Compiles large programs**. The MLKit compiles large programs,
  [including itself](http://elsman.com/mlkit/bootstrap.html), around
  80.000 lines of Standard ML plus the Standard ML Basis Library. The
  support for [ML Basis
  Files](http://elsman.com/mlkit/mlbasisfiles.html) makes it easy to
  compile a program with different Standard ML compilers. Currently,
  both [MLton](http://mlton.org) and the MLKit supports the concept of
  ML Basis Files. The MLKit works well together with
  [smlpkg](https://github.com/diku-dk/smlpkg), a generic package
  manager for Standard ML libraries and programs.

- **Documentation is available**. Man-pages and general documentation
  is available from the [MLKit home
  page](http://melsman.github.io/mlkit).

## MLKit with Regions - The x86 Native Backend

This version of the compiler is based on region inference and has the
following features:

- An x86 native backend (works with Linux and macOS).

- Memory allocation directives (both allocation and deallocation) are
  inferred by the compiler, which uses a number of program analyses
  concerning lifetimes and storage layout. The MLKit compiler is
  unique among ML implementations in this respect.

- A comprehensive guide on [Programming with Regions in the
  MLKit](http://elsman.com/mlkit/raw/doc/mlkit.pdf) is available,
  which also demonstrate how to create memory profiles of program
  executions using the supplied region profiler and how to interact
  with C programs.

- Region inference may be augmented with reference-tracing garbage
  collection to achieve better memory behavior.

## SMLtoJs - The JavaScript Backend

This version of the compiler generates efficient JavaScript, primarily
for [executing Standard ML code in the
browser](/README_SMLTOJS.md).

## The Barry Backend

The repository also includes the sources for
[Barry](/README_BARRY.md), a Standard ML source-to-source compiler
that eliminates modules, using static interpretation, and generates
optimised Core-language Standard ML code.

## License and Copyright

The MLKit compiler is distributed under the GNU Public License,
version 2. See the file [MLKit-LICENSE](/doc/license/MLKit-LICENSE)
for details. The runtime system (`/src/Runtime/`) and libraries
(`basis/`) is distributed under the more liberal MIT License.

## Compilation Requirements

To compile, install, and use the MLKit, a Linux box running Ubuntu
Linux, Debian, gentoo, or similar is needed. The MLKit also works on
macOS and has also earlier been reported to run on the FreeBSD/x86
platform, with a little tweaking.

To compile the MLKit, a Standard ML compiler is needed, which needs to
be one of the following:

__[MLton](http://mlton.org) >= 20051202:__
```bash
$ mlton
MLton 20051202 (built Sat Dec 03 04:20:11 2005 on pavilion)
```

If a version prior to 20201023 is used, you may need to adjust the
`mlton`-flags setup in the file `Makefiledefault`.

__A working MLKit compiler >= 4.3.0:__
```bash
$ mlkit -V
MLKit version 4.3.0, Jan 25, 2006 [X86 Backend]
```

Moreover, `gcc` is needed for compiling the runtime system and related
tools.

## Compilation

After having checked out the sources from Github, execute the command:
```bash
$ ./autobuild
```

Now, `cd` to the toplevel directory of the repository and execute the
appropriate set of commands:

__Compile with MLton alone (Tested with 3Gb RAM):__
```bash
$ ./configure
$ make mlkit
```

__Compile with existing MLKit (Tested with 1Gb RAM):__
```bash
$ ./configure --with-compiler=mlkit
$ make mlkit
```

If you later want to install the MLKit in your own home directory, you
should also pass the option `--prefix=$HOME/mlkit` to `./configure` above.

For binary packages, we use
```bash
$ ./configure --sysconfdir=/etc --prefix=/usr
```

## Pre-compile Basis Library and Kit-Library

Execute the following command:
```bash
$ make mlkit_libs
```

## Bootstrapping (optional - works with 1Gb RAM)

This step is optional. If you want the resulting executable compiler
to be bootstrapped (compiled with itself), execute the command:
```bash
$ make bootstrap && make mlkit_libs
```

Be aware that this step takes some time.

## Installation after Compilation

For a system-wide installation of the MLKit, including installation of
man-pages and tools, execute the command:
```bash
$ sudo make install
```

For a personal installation, with `--prefix=$HOME/mlkit` given to
`./configure`, execute the following command:
```bash
$ make install
```

## Making a Binary Package

To build a binary package, execute the command
```bash
$ make mlkit_x64_tgz
```

This command leaves a package `mlkit-X.Y.Z-x64.tgz` in the `dist/`
directory. For building a binary package, the installation step above
is not needed and the bootstrapping step is optional. The binary package includes both the MLKit with Regions compiler (i.e., the `mlkit` executable) and [SMLtoJs](/README_SMLTOJS.md) (i.e., an executables named `smltojs`).

## Try It

To test the installation, copy the directory `/usr/share/mlkit/kitdemo` to
somewhere in your own directory, say `$HOME/kitdemo`:
```bash
$ cp -a /usr/share/mlkit/kitdemo $HOME/kitdemo
$ cd $HOME/kitdemo
$ mlkit helloworld.sml
```

The MLKit should produce an executable file `run`:
```bash
$ ./run
hello world
```

## Trying Without Installing

You can run `mlkit` without installing it, but you should then point
the environment variable `SML_LIB` at the build directory (which
contains the `basis` and the `lib` directories) whenever you run
`mlkit`.  E.g:

```bash
$ SML_LIB=$PWD bin/mlkit
```

## More Information

See the [MLKit home page](http://melsman.github.io/mlkit) for information about related papers, etc.

General documentation for the MLKit is located in the directories `doc/mlkit`
and `man/man1`. License information is located in the file
`doc/license/MLKit-LICENSE`.

## Comments and Bug Reports

The MLKit has a number of [known bugs and limitations](http://elsman.com/mlkit/bugs.html). To file a bug-report, create an issue at the Github page.

## Appendix A: Directory Structure of the Sources

    kit/
       README
       configure
       Makefile.in
       src/
       basis/
       doc/mlkit.pdf
          /license/MLKit-LICENSE
       man/man1/rp2ps.1
       kitdemo/
       test/

## Appendix B: Quick Compilation and Installation Guide

We assume that MLton >= 20051202 is installed on the system as
described above.

After having checked out the sources from Github, execute the command:
```bash
$ ./autobuild
```

To compile the MLKit, execute the following commands:
```bash
$ ./configure
$ make mlkit
$ make bootstrap
$ make mlkit_libs
```

The `make bootstrap` command is optional.

To install the MLKit and related tools, execute:
```bash
$ sudo make install
```

See the section "Try It" above to test the installation.

## Appendix C: Displaying Region Flow Graphs with VCG

The [VCG tool](http://www.cs.uni-sb.de/RW/users/sander/html/gsvcg1.html) can be used to show region flow graphs.
