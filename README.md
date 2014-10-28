# SENNA LuaJIT Interface

*Disclaimer*: while this glue code is provided under a BSD license, __SENNA__ is not. Please refer
to [__SENNA__ license](http://ml.nec-labs.com/senna/license.html).

This interface supports Part-of-speech tagging, Chunking, Name Entity Recognition and Semantic Role Labeling.

## Installation

Because __SENNA__ is shipped under a particular license, we do not include it into this repository.
You thus need to follow these steps to install SENNA LuaJIT interface:

  * Clone the SENNA LuaJIT interface:
  ```sh
  git clone https://github.com/torch/senna.git
  ```

  * Go into the created directory:
  ```sh
  cd senna
  ```

  * Get [__SENNA__](http://ml.nec-labs.com/senna/license.html). You must accept the license to proceed further.

  * Unpack __SENNA__ archive into the git directory.

  * Run `luarocks`:
  ```sh
  luarocks make rocks/senna-scm-1.rockspec
  ```

## Running

We provide an example usage called `senna.run`. It outputs tags into `stdout` for anything coming in `stdin`.
Typical usage:
```sh
luajit -lsenna.run < file_to_tag.txt > tags.txt
```
