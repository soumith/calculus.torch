local calculus = require 'calculus.env'
require 'torch'

function calculus.finiteDifferenceJacobian(f,x,method)
   local help = [[
   Calculates finite difference based derivative (or partial derivatives, in case of tensor input)
   Takes in three arguments:
    f       - the function to differentiate
    x       - the input. Number (or) torch.FloatTensor (or) torch.DoubleTensor
   [method] - 'central' difference or 'forward' difference. Default is 'central'
   ]]
   method = method or 'central'
   if not (type(f) == 'function' 
	   and (torch.typename(x) == 'torch.FloatTensor' or torch.typename(x) == 'torch.DoubleTensor' or type(x) == 'number')
	   and (method == 'central' or method == 'forward')) then
      print(help)
      error('invalid arguments')
   end
   
   local epsilon = calculus.floatEpsilon
   if torch.typename(x) == 'torch.DoubleTensor' or type(x) == 'number' then epsilon = calculus.doubleEpsilon; end
   
   if method == 'central' then
      return (f(x+epsilon) - f(x-epsilon)) / (epsilon + epsilon)
   else -- forward
      return (f(x+epsilon) - f(x))         / (epsilon)
   end   
end

function calculus.finiteDifferenceHessian(f,x,method)
   local help = [[
   Calculates finite difference based second derivative (or partial derivatives, in case of tensor input)
   Takes in three arguments:
    f       - the function to differentiate
    x       - the input. Number (or) torch.FloatTensor (or) torch.DoubleTensor
   [method] - 'central' difference or 'forward' difference. Default is 'central'
   ]]
   method = method or 'central'
   if not (type(f) == 'function' 
	   and (torch.typename(x) == 'torch.FloatTensor' or torch.typename(x) == 'torch.DoubleTensor' or type(x) == 'number')
	   and (method == 'central' or method == 'forward')) then
      print(help)
      error('invalid arguments')
   end
   
   local epsilon = calculus.floatEpsilon
   if torch.typename(x) == 'torch.DoubleTensor' or type(x) == 'number' then epsilon = calculus.doubleEpsilon; end
   
   if method == 'central' then
      return (f(x + epsilon)     - f(x)           * 2 + f(x - epsilon)) / math.pow(epsilon, 2)
   else -- forward
      return (f(x + epsilon * 2) - f(x + epsilon) * 2 + f(x))           / math.pow(epsilon, 2)
   end
end

return calculus
