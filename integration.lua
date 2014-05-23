local calculus = require 'calculus.env'
require 'torch'

local function simpsons(f, a, b)
   return (f(a) + f((a+b)/2) * 4 + f(b)) * (b-a)/6
end

-- adapted from wikipedia C99 pseudocode
local function aSimpsonsRecursion(f, a, b, eps, S, fa, fb, fc, bottom)
   local c = (a + b)/2
   local h = b - a
   local d = (a + c)/2
   local e = (c + b)/2
   local fd = f(d)
   local fe = f(e)   
   local Sleft = h/12 * (fa + fd*4 + fc)
   local Sright = h/12 * (fc + fe*4 + fb)
   local S2 = Sleft + Sright

   local abs
   if type(S2) == 'number' then
      abs = math.abs(S2 - S)
   else -- tensor
      abs = (S2 - S):abs()
   end
   
   if (bottom <= 0 or abs <= 15*eps) then
      return S2 + (S2 - S) / 15
   end
   return aSimpsonsRecursion(f, a, c, eps/2, Sleft, fa, fc, fd, bottom-1) +
      aSimpsonsRecursion(f, c, b, eps/2, Sright, fc, fb, fe, bottom-1)
end

-- adapted from wikipedia C99 pseudocode
local function adaptiveSimpsons(f, a, b, maxRecursionDepth)
   maxRecursionDepth = maxRecursionDepth or 10
   local eps = calculus.doubleEpsilon
   if torch.typename(a) == 'torch.FloatTensor' then
      eps =  calculus.floatEpsilon
   end
   local c = (a+b)/2
   local h = b - a
   local fa = f(a)
   local fb = f(b)
   local fc = f(c)
   local S = (h/6) * (fa + 4*fc + fb)
   return aSimpsonsRecursion(f, a, b, eps, S, fa, fb, fc, maxRecursionDepth)
end

local function monteCarlo(f, a, b)
   error('NYI')
end

function calculus.integrate(f, a, b, method)
   local help = [[
   Integrates the given function over the limits [a, b]
   Takes in four arguments:
    f       - the function to differentiate
    a       - the lower integration limit. Number (or) torch.FloatTensor (or) torch.DoubleTensor
    b       - the upper integration limit. Number (or) torch.FloatTensor (or) torch.DoubleTensor
   [method] - 'asimps'/'simps'/'mc' for adaptive-simpsons/simpsons/monte-carlo respectively. Default is 'adaptive-simpsons'
   ]]
   method = method or 'asimps'
   if not (type(f) == 'function'
	   and (torch.typename(a) == 'torch.FloatTensor' or torch.typename(a) == 'torch.DoubleTensor' or type(a) == 'number')
	   and (torch.typename(b) == 'torch.FloatTensor' or torch.typename(b) == 'torch.DoubleTensor' or type(b) == 'number')
	   and (method == 'asimps' or method == 'simps' or method == 'mc')) then
	   print(help)
	   error('invalid arguments')
   end

   if method == 'simps' or method == 'simpsons' then
      return simpsons(f, a, b)
   elseif method == 'asimps' or method == 'adaptive-simpsons' then
      return adaptiveSimpsons(f, a, b)
   elseif method == 'mc' or method == 'monte-carlo' then
      return monteCarlo(f, a, b)
   end   
end
