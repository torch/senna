local ffi = require 'ffi'

ffi.cdef[[

void SENNA_set_verbose_mode(int verbose);

typedef struct SENNA_Hash_ SENNA_Hash;
SENNA_Hash* SENNA_Hash_new(const char *path, const char *filename);
SENNA_Hash *SENNA_Hash_new_with_admissible_keys(const char *path, const char *filename, const char *admissible_keys_filename);
int SENNA_Hash_index(SENNA_Hash *hash, const char *key);
const char* SENNA_Hash_key(SENNA_Hash *hash, int idx);
void SENNA_Hash_convert_IOBES_to_brackets(SENNA_Hash *hash);
void SENNA_Hash_convert_IOBES_to_IOB(SENNA_Hash *hash);
int SENNA_Hash_size(SENNA_Hash *hash);
char SENNA_Hash_is_admissible_index(SENNA_Hash *hash, int idx);
void SENNA_Hash_free(SENNA_Hash *hash);

typedef struct SENNA_CHK_ SENNA_CHK;
SENNA_CHK* SENNA_CHK_new(const char *path, const char *subpath);
int* SENNA_CHK_forward(SENNA_CHK *chk, const int *sentence_words, const int *sentence_caps, const int *sentence_posl, int sentence_size);
void SENNA_CHK_free(SENNA_CHK *chk);

typedef struct SENNA_NER_ SENNA_NER;

SENNA_NER* SENNA_NER_new(const char *path, const char *subpath);
int* SENNA_NER_forward(SENNA_NER *ner, const int *sentence_words,
                                       const int *sentence_caps,
                                       const int *sentence_gazl,
                                       const int *sentence_gazm,
                                       const int *sentence_gazo,
                                       const int *sentence_gazp,
                                       int sentence_size);
void SENNA_NER_free(SENNA_NER *ner);

typedef struct SENNA_POS_ SENNA_POS;
SENNA_POS* SENNA_POS_new(const char *path, const char *subpath);
int* SENNA_POS_forward(SENNA_POS *pos, const int *sentence_words, const int *sentence_caps, const int *sentence_suff, int sentence_size);
void SENNA_POS_free(SENNA_POS *pos);

typedef struct SENNA_PSG_ SENNA_PSG;
SENNA_PSG* SENNA_PSG_new(const char *path, const char *subpath);
void SENNA_PSG_forward(SENNA_PSG *psg, const int *sentence_words, const int *sentence_caps, const int *sentence_posl, int sentence_size, int **labels_, int *n_level_);
void SENNA_PSG_free(SENNA_PSG *psg);

typedef struct SENNA_PT0_ SENNA_PT0;
SENNA_PT0* SENNA_PT0_new(const char *path, const char *subpath);
int* SENNA_PT0_forward(SENNA_PT0 *pt0, const int *sentence_words, const int *sentence_caps, const int *sentence_posl, int sentence_size);
void SENNA_PT0_free(SENNA_PT0 *pt0);

typedef struct SENNA_SRL_ SENNA_SRL;
SENNA_SRL* SENNA_SRL_new(const char *path, const char *subpath);
int** SENNA_SRL_forward(SENNA_SRL *srl, const int *sentence_words, const int *sentence_caps, const int *sentence_chkl, const int *sentence_isvb, int sentence_size);
void SENNA_SRL_free(SENNA_SRL *srl);

typedef struct SENNA_Tokens_
{
    char **words;
    int *start_offset;
    int *end_offset;
    int *word_idx;
    int *caps_idx;
    int *suff_idx;
    int *gazl_idx;
    int *gazm_idx;
    int *gazo_idx;
    int *gazp_idx;
    int n;

} SENNA_Tokens;

typedef struct SENNA_Tokenizer_ SENNA_Tokenizer;
SENNA_Tokenizer* SENNA_Tokenizer_new(SENNA_Hash *word_hash,
                                     SENNA_Hash *caps_hash,
                                     SENNA_Hash *suff_hash,
                                     SENNA_Hash *gazt_hash,
                                     SENNA_Hash *gazl_hash,
                                     SENNA_Hash *gazm_hash,
                                     SENNA_Hash *gazo_hash,
                                     SENNA_Hash *gazp_hash,
                                     int is_tokenized);
void SENNA_Tokenizer_free(SENNA_Tokenizer *tokenizer);
SENNA_Tokens* SENNA_Tokenizer_tokenize(SENNA_Tokenizer *tokenizer, const char *sentence);
void SENNA_tokenize_untilspace(int *size_, const char *sentence);
void SENNA_tokenize_alphanumeric(int *size_, const char *sentence);
void SENNA_tokenize_dictionarymatch(int *size_, int *idxhash_, SENNA_Hash *hash, const char *sentence);
void SENNA_tokenize_number(int *size_, const char *sentence);

typedef struct SENNA_VBS_ SENNA_VBS;
SENNA_VBS* SENNA_VBS_new(const char *path, const char *subpath);
int* SENNA_VBS_forward(SENNA_VBS *vbs, const int *sentence_words, const int *sentence_caps, const int *sentence_posl, int sentence_size);
void SENNA_VBS_free(SENNA_VBS *vbs);

]]
