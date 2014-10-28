# SENNA LuaJIT Interface

*Disclaimer*: while this glue code is provided under a BSD license, _SENNA_ is not. Please refer
to [_SENNA_ license](http://ml.nec-labs.com/senna/license.html).

This interface supports Part-of-speech tagging, Chunking, Name Entity Recognition and Semantic Role Labeling.

## Installation

Because _SENNA_ is shipped under a particular license, we do not include it into this repository.
You thus need to follow these steps to install SENNA LuaJIT interface:

  * Clone the SENNA LuaJIT interface:
  ```sh
  git clone https://github.com/torch/senna.git
  ```

  * Go into the created directory:
  ```sh
  cd senna
  ```

  * Get [_SENNA_](http://ml.nec-labs.com/senna/license.html). You must accept the license to proceed further.

  * Unpack _SENNA_ archive into the git directory.

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

Typical output:
```sh
echo "The Dow Jones industrials closed at 2569.26 ." | luajit -lsenna.run
                 The        DT      (NP*         *                   -      (A1*
                 Dow       NNP         *    (MISC*                   -         *
               Jones       NNP         *        *)                   -         *
         industrials       NNS        *)         *                   -        *)
              closed       VBD     (VP*)         *              closed      (V*)
                  at        IN     (PP*)         *                   -  (AM-EXT*
             2569.26        CD     (NP*)         *                   -        *)
         .         .         *         *                   -         *
```

## Interface Description

The LuaJIT interface provides several objects encapsulating _SENNA_'s tools.

### Hash

_SENNA_'s Hash.

#### senna.Hash(path, filename[, admissible_keys_filename])

Load a hash stored at `filename`, into the given `path`. If the
`adimissible_keys_filename` is present, this will create a hash with
admissible keys (needed for NER).

#### Hash:index(key)

Returns the index of the given string `key`.

#### Hash:key(idx)

Returns the string at the given index `idx` (a number).

#### Hash:size()

Returns the number of pairs (key, value) stored into the hash.

#### Hash:IOBES2IOB()

Transform IOBES hash values (strings) into IOB format.

#### Hash:IOBES2BRK()

Transform IOBES hash values (strings) into bracket format.
