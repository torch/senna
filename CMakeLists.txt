cmake_minimum_required (VERSION 2.6)
cmake_policy(SET CMP0042 NEW)

SET(PKGNAME senna)

add_library(${PKGNAME} MODULE
  senna/SENNA_CHK.c
  senna/SENNA_Hash.c
  senna/SENNA_NER.c
  senna/SENNA_POS.c
  senna/SENNA_PSG.c
  senna/SENNA_PT0.c
  senna/SENNA_SRL.c
  senna/SENNA_Scores2Treillis.c
  senna/SENNA_Tokenizer.c
  senna/SENNA_Treillis.c
  senna/SENNA_VBS.c
  senna/SENNA_nn.c
  senna/SENNA_utils.c)

set(BLA_VENDOR "Intel10_64lp")
find_package(BLAS)
if(BLAS_FOUND)
    add_definitions('-DUSE_MKL_BLAS')
    include_directories(BEFORE ${CMAKE_SOURCE_DIR})
    target_link_libraries(${PKGNAME} ${BLAS_LIBRARIES})
else()
  set(BLA_VENDOR "Apple")
  find_package(BLAS)
  if(BLAS_FOUND)
    add_definitions('-DUSE_APPLE_BLAS')
    target_link_libraries(${PKGNAME} ${BLAS_LIBRARIES})
  else()
    message(WARNING "no suitable blas library found (only MKL or ACCELERATE are supported)... it will be slow!")
  endif()
endif()

install(TARGETS ${PKGNAME} LIBRARY
  DESTINATION ${LUA_CPATH})

install(DIRECTORY senna/hash
  DESTINATION ${LUA_PATH}/${PKGNAME})

install(DIRECTORY senna/data
  DESTINATION ${LUA_PATH}/${PKGNAME})

install(FILES
  init.lua
  env.lua
  cdefs.lua
  hash.lua
  tokens.lua
  tokenizer.lua
  pos.lua
  chk.lua
  ner.lua
  srl.lua
  run.lua
  DESTINATION ${LUA_PATH}/${PKGNAME})
