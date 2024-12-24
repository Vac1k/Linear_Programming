
x0 = [-1; -1];
num_round = 4;

function y = f(x)
    y = (6*x(1) + 2 * x(1) ^ 2 - 2 * x(1)*x(2) + 2 * x(2)^2);
end

function grad = der(f, x, delta)
    if nargin < 3
        delta = 1e-6;
    end
    n = length(x);
    grad = zeros(n, 1);
    for i = 1:n
        e = zeros(n, 1);
        e(i) = delta;
        grad(i) = (f(x + e) - f(x - e)) / (2 * delta);
    end
end

function t = line_search(f, x, grad, alpha, beta, c)
    if nargin < 4
        alpha = 1.0;
    end
    if nargin < 5
        beta = 0.5;
    end
    if nargin < 6
        c = 1e-4;
    end
    t = alpha;
    while f(x - t * grad) > f(x) - c * t * (grad' * grad)
        t = t * beta;
    end
end

function min_x = steepest_descent(f, x0)
    tol = 1e-6;
    max_iter = 1000;
    alpha = 1.0;
    beta = 0.5;
    c = 1e-4;
    
    x = x0;
    for k = 1:max_iter
        grad = der(f, x);
        if norm(grad) < tol
            break;
        end
        t = line_search(f, x, grad, alpha, beta, c);
        x = x - t * grad;
    end
    min_x = x;
end

function y = round_to(x, num_places)
    factor = 10^num_places;
    y = round(x * factor) / factor;
end

options = optimset('TolX', 1e-8, 'TolFun', 1e-8);
result = fminsearch(@f, x0, options);

fprintf("Nelder-Mead Method\n");
fprintf("Minimum found at: [%f, %f]\n", round_to(result(1), num_round), round_to(result(2), num_round));
fprintf("Function value at minimum: %f\n", round_to(f(result), num_round));

min_x = steepest_descent(@f, x0);

fprintf("Steepest Descent Method\n");
fprintf("Minimum found at: [%f, %f]\n", round_to(min_x(1), num_round), round_to(min_x(2), num_round));
fprintf("Function value at minimum: %f\n", round_to(f(min_x), num_round));
