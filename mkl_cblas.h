#ifndef MKL_BLAS_H
#define MKL_BLAS_H

/* just few function definitions */
/* this has nothing to do with mkl_cblas.h shipped by Intel MKL */

/* we do that because SENNA requires mkl_blas.h which is not found by
 * find_package(BLAS) */

#include <stdint.h>

typedef enum {CblasRowMajor=101, CblasColMajor=102} CBLAS_LAYOUT;
typedef enum {CblasNoTrans=111, CblasTrans=112, CblasConjTrans=113} CBLAS_TRANSPOSE;

void cblas_scopy(const int64_t N, const float *X, const int64_t incX, float *Y, const int64_t incY);

void cblas_sgemv(const  CBLAS_LAYOUT Layout,
                 const  CBLAS_TRANSPOSE TransA, const int64_t M, const int64_t N,
                 const float alpha, const float *A, const int64_t lda,
                 const float *X, const int64_t incX, const float beta,
                 float *Y, const int64_t incY);

void cblas_sgemm(const  CBLAS_LAYOUT Layout, const  CBLAS_TRANSPOSE TransA,
                 const  CBLAS_TRANSPOSE TransB, const int64_t M, const int64_t N,
                 const int64_t K, const float alpha, const float *A,
                 const int64_t lda, const float *B, const int64_t ldb,
                 const float beta, float *C, const int64_t ldc);

#endif
