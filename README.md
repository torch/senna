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
`admissible_keys_filename` is present, this will create a hash with
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

### Tokens

Encapsulate tokens returned by the Tokenizer. Only created by the tokenizer.


#### Tokens:words()

Return a table containing tokenized word strings.

### Tokenizer

Encapsulate _SENNA_'s tokenizer.

#### senna.Tokenizer([is_tokenized])

Create a new tokenizer. The tokenizer will be able to tokenize and create
any features required by _SENNA_ subroutines. If `is_tokenized` is at true,
then the tokenizer assumes words are already tokenized, separated with spaces.

#### Tokenizer:tokenize(sentence)

Tokenize the given string. Returns `Tokens`.

`Important note`: because of internal states retained into the Tokenizer,
it is not possible to tokenize and process several sentences at the
time. Keep this in mind when calling the analyzing tools.

### Part Of Speech

_SENNA_'s Part-of-speech (POS) module.

#### senna.POS()

Creates a POS analyzer.

#### POS:forward(tokens)

Returns a table containing POS tags computed on the given tokens (which
must be from coming the `Tokenizer` module).

### Chunking

_SENNA_'s chunking (shallow parsing) module.

#### senna.CHK([hashtype])

Creates a chunking analyzer. The optional `hashtype` argument indicates the
format of the generated tags. By default it will be `IOBES`. Other options
are `IOB` or `BRK` (for bracketing tags).

#### CHK:forward(tokens, pos_tags)

Returns a table containing chunking tags, computed on the given tokens
(which must be coming from the `Tokenizer` module) and POS tags (which must be
coming from the `POS` module).

### Name Entity Recognition

_SENNA_'s name entity recognition (NER) module.

#### senna.NER([hashtype])

Creates a NER analyzer. The optional `hashtype` argument indicates the
format of the generated tags. By default it will be `IOBES`. Other options
are `IOB` or `BRK` (for bracketing tags).

#### NER:forward(tokens)

Returns a table containing NER tags, computed on the given tokens (which
must be coming from the `Tokenizer` module).


### Semantic Role Labeling

_SENNA_'s semantic role labeling (SRL) module.

#### senna.SRL([hashtype],[verbtype])

Creates a SRL analyzer. The optional `hashtype` argument indicates the
format of the generated tags. By default it will be `IOBES`. Other options
are `IOB` or `BRK` (for bracketing tags).

The optional `verbtype` indicates how verbs should be found. Default is
`VBS`, _SENNA_'s custom way of finding verbs. One can also use verbs from
POS with `POS` or user provided verbs with `USR`.

#### SRL:forward(tokens, pos_labels[, usr_verb_labels])

Returns a table containing a table of SRL tags, computed on the given
tokens (which must be coming from the `Tokenizer` module) and POS tags
(which must be coming from the `POS` module).

Each table in the table corresponds to a particular detected/provided verb
and contains tags for each word in the sentence.

The returned table also contains a `verb` field, which is a table of
booleans. A boolean at true means the word was considered as a verb.

If `USR` was passed as `verbtype` during creation of the module, the user
must also provide a list of words considered as verbs in
`usr_verb_labels`. The list must be a list of booleans, of the size of the
number of tokens in the sentence. A boolean at true means the corresponding
word will be considered as a verb.
