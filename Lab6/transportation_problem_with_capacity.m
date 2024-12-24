function [x, cost, error] = transportation_problem_with_capacity(C, a, b, D)
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

  large_value = 1e6;
  D_with_capacity = D;
  D_with_capacity(isinf(D)) = large_value;

  lb = zeros(m * n, 1);
  ub = reshape(D_with_capacity', 1, numel(D_with_capacity))';


  ctype = repmat('S', 1, m + n);
  vartype = repmat('C', 1, m * n);
  sense = 1;

  param.msglev = 1;
  results = glpk(c, A_eq, b_eq, lb, ub, ctype, vartype, sense, param);

  x = transpose(reshape(results, n, m));

  cost = dot(c, results);


  % disp('Розв’язок з обмеженнями на пропускну здатність:');
  % disp(x);
  % disp('Мінімальні витрати:');
  % disp(cost);
end


% C_with_capacity = [9 1 8 7 8;
%                    8 1 6 9 5;
%                    20 8 15 14 19;
%                    12 6 10 10 12;
%                    0 0 0 0 0];
% a_with_capacity = [26 28 39 75 10];
% D_with_capacity = [14 10 15 20 18;
%                    19 8 15 18 13;
%                    11 23 18 30 16;
%                    9 10 11 24 32;
%                    inf inf inf inf inf];
% b_with_capacity = [3 46 25 49 55];
% expected_cost_with_capacity = 1447;

% [x_with_capacity, cost_with_capacity, error_with_capacity] = transportation_problem_with_capacity(C_with_capacity, a_with_capacity, b_with_capacity, D_with_capacity, expected_cost_with_capacity);

