package = "calculus"
version = "scm-1"

source = {
   url = "git://github.com/soumith/calculus.torch.git",
}

description = {
   summary = "Calculus functions for Torch",
   detailed = [[
   A torch7 package to do differentiation and integration over arbitrary Tensors, using a variety of methods including finite-difference, simpson's rule etc.
   ]],
   homepage = "https://github.com/soumith/calculus.torch",
   license = "BSD"
}

dependencies = {
   "torch >= 7.0",
   "argcheck",
}

build = {
   type = "command",
   build_command = [[
cmake -E make_directory build && cd build && cmake .. -DCMAKE_BUILD_TYPE=Release -DCMAKE_PREFIX_PATH="$(LUA_BINDIR)/.." -DCMAKE_INSTALL_PREFIX="$(PREFIX)" && $(MAKE)
]],
   install_command = "cd build && $(MAKE) install"
}