function [x, cost, error] = transportation_problem_no_capacity(C, a, b)
  m = length(a);
  n = length(b);

  c = reshape(C', 1, numel(C))';

  A_eq = zeros(m + n, m * n);
  b_eq = [a(:); b(:)];

  for i = 1:m
    A_eq(i, (i-1)*n + 1:i*n) = 1;
  end

  for j = 1:n
    A_eq(m + j, j:n:end) = 1;
  end

  lb = zeros(m * n, 1);
  ub = [];

  ctype = repmat('S', 1, m + n);
  vartype = repmat('C', 1, m * n);
  sense = 1;

  param.msglev = 1;
  results = glpk(c, A_eq, b_eq, lb, ub, ctype, vartype, sense, param);

  x = transpose(reshape(results, n, m));
  disp(x);
  cost = dot(c, results);
end
