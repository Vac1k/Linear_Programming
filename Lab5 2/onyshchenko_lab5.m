nutrient_contributions = [
    3, 1, 1;  % Product 1
    1, 2, 0;  % Product 2
    1, 6, 0;  % Product 3
];
nutrient_requirements = [9; 8; 12];
product_costs = [5; 6; 0];

[num_nutrients, num_products] = size(nutrient_contributions);

c = product_costs;
A = nutrient_contributions;
b = nutrient_requirements;

lb = zeros(num_products, 1);
ub = [];

sense = 1;

ctype = repmat('L', num_nutrients, 1);

vartype = repmat('C', num_products, 1);

[x, fval, status] = glpk(c, A, b, lb, ub, ctype, vartype, sense);

if status == 0
    fprintf('Optimal solution determined:\n');
    for i = 1:num_products
        fprintf('Variable Product_%d: %.2f\n', i, x(i));
    end
    fprintf('Objective Function Value (Total Cost): %.2f\n', fval);
else
    fprintf('Optimal solution not attained. Further analysis is required.\n');
end

