package = "senna"
version = "scm-1"

source = {
   url = "git://github.com/torch/senna.git"
}

description = {
   summary = "SENNA interface to LuaJIT",
   detailed = [[
   ]],
   homepage = "https://github.com/torch/senna",
   license = "BSD"
}

dependencies = {
   "lua >= 5.1",
}

build = {
   type = "cmake",
   variables = {
      CMAKE_BUILD_TYPE="Release",
      LUA_PATH="$(LUADIR)",
      LUA_CPATH="$(LIBDIR)"
   }
}
