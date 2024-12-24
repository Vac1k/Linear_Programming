function main()
    % Input data
    A = [1.02, -0.25, -0.30; -0.41, 1.13, -0.15; -0.25, -0.14, 1.21];
    b = [0.515; 1.555; 2.780];

    % Exact solution
    exact_solution = A \ b;

    % Execute Gauss method
    gauss_solution = gauss_method(A, b);
    gauss_error = calculate_error(A, gauss_solution, b);
    gauss_coord_accuracy = calculate_coordinate_accuracy(exact_solution, gauss_solution);

    fprintf("Solution using Gauss method:\n");
    disp(gauss_solution);
    fprintf("Error of Gauss method: %.6f\n", gauss_error);
    fprintf("Coordinate-wise accuracy of Gauss method:\n");
    disp(gauss_coord_accuracy);

    % Execute LU factorization method
    lu_solution = lu_factorization(A, b);
    lu_error = calculate_error(A, lu_solution, b);
    lu_coord_accuracy = calculate_coordinate_accuracy(exact_solution, lu_solution);

    fprintf("Solution using LU factorization:\n");
    disp(lu_solution);
    fprintf("Error of LU factorization: %.6f\n", lu_error);
    fprintf("Coordinate-wise accuracy of LU factorization:\n");
    disp(lu_coord_accuracy);
endfunction

function gauss_solution = gauss_method(A, b)
    n = length(b);
    % Forward elimination
    for k = 1:n
        for i = k+1:n
            factor = A(i, k) / A(k, k);
            A(i, k:n) = A(i, k:n) - factor * A(k, k:n);
            b(i) = b(i) - factor * b(k);
        end
    end

    % Back substitution
    gauss_solution = zeros(n, 1);
    for i = n:-1:1
        gauss_solution(i) = (b(i) - A(i, i+1:n) * gauss_solution(i+1:n)) / A(i, i);
    end
endfunction

function lu_solution = lu_factorization(A, b)
    n = size(A, 1);
    L = eye(n);
    U = A;

    % LU factorization
    for k = 1:n
        for i = k+1:n
            factor = U(i, k) / U(k, k);
            L(i, k) = factor;
            U(i, k:n) = U(i, k:n) - factor * U(k, k:n);
        end
    end

    % Solving L * y = b
    y = zeros(n, 1);
    for i = 1:n
        y(i) = b(i) - L(i, 1:i-1) * y(1:i-1);
    end

    % Solving U * x = y
    lu_solution = zeros(n, 1);
    for i = n:-1:1
        lu_solution(i) = (y(i) - U(i, i+1:n) * lu_solution(i+1:n)) / U(i, i);
    end
endfunction

function error = calculate_error(A, x, b)
    % Calculate error as the norm of the residual vector
    residual = A * x - b;
    error = norm(residual);
endfunction

function coord_accuracy = calculate_coordinate_accuracy(exact_solution, approx_solution)
    % Calculate coordinate-wise accuracy
    coord_accuracy = abs(exact_solution - approx_solution);
endfunction

