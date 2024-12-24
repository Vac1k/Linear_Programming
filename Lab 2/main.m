% main.m
% Основна програма для чисельного інтегрування та диференціювання

% Вхідні дані
a = 0;                  % Нижня межа інтегрування
b = 2;                  % Верхня межа інтегрування
n = 40;                 % Кількість частин розбиття
h = (b - a) / n;        % Крок розбиття

% Підінтегральна функція
function y = integrand(x)
    y = x ./ (x + 3).^2;
endfunction

% Первісна функція для аналітичного інтегрування
function y = antiderivative(x)
    y = 3 ./ (x + 3) + log(x + 3);
endfunction

% Метод трапецій для чисельного інтегрування
function integral = trapezoidal_rule(func, a, b, n)
    h = (b - a) / n;
    x = linspace(a, b, n + 1);
    y = func(x);
    integral = h * (0.5 * y(1) + sum(y(2:end-1)) + 0.5 * y(end));
endfunction

% Метод Сімпсона для чисельного інтегрування
function integral = simpsons_rule(func, a, b, n)
    if mod(n, 2) == 1
        n = n + 1;  % Метод Сімпсона вимагає парного значення n
    endif
    h = (b - a) / n;
    x = linspace(a, b, n + 1);
    y = func(x);
    integral = (h / 3) * (y(1) + 4 * sum(y(2:2:end-1)) + 2 * sum(y(3:2:end-2)) + y(end));
endfunction

% Додамо функцію для обчислення похідної полінома
function derivative_coeffs = polynomial_derivative(coeffs)
    % Обчислює коефіцієнти похідної полінома, заданого коефіцієнтами
    n = length(coeffs);
    derivative_coeffs = coeffs(1:n-1) .* (n-1:-1:1);
endfunction

% Метод Лагранжа для чисельного диференціювання
function result = lagrange_derivative(x_vals, y_vals, x_target)
    % Обчислює чисельну похідну полінома Лагранжа в точці x_target
    % з використанням підмножини сусідніх точок із вікном у 5 точок.

    % Визначаємо індекс найближчої точки до x_target
    [~, idx] = min(abs(x_vals - x_target));

    % Визначаємо межі вікна для інтерполяції (5 точок навколо x_target)
    idx_start = max(1, idx - 2);
    idx_end = min(length(x_vals), idx + 2);

    % Формуємо підмножину точок для інтерполяції
    x_subset = x_vals(idx_start:idx_end);
    y_subset = y_vals(idx_start:idx_end);

    % Обчислення коефіцієнтів інтерполяційного полінома Лагранжа
    poly_coeffs = polyfit(x_subset, y_subset, length(x_subset) - 1);
    
    % Обчислення похідної полінома
    poly_derivative = polynomial_derivative(poly_coeffs);

    % Оцінка похідної в точці x_target
    result = polyval(poly_derivative, x_target);
endfunction

% Обчислення чисельного інтегралу методами трапецій та Сімпсона
integral_trapezoidal = trapezoidal_rule(@integrand, a, b, n);
integral_simpson = simpsons_rule(@integrand, a, b, n);

% Аналітичне значення інтегралу за допомогою первісної функції
analytical_integral = antiderivative(b) - antiderivative(a);

% Похибки для методів інтегрування
error_trapezoidal = abs(integral_trapezoidal - analytical_integral);
error_simpson = abs(integral_simpson - analytical_integral);

% Точки для методу Лагранжа (всі точки розбиття)
x_points = linspace(a, b, n + 1);
y_points = antiderivative(x_points);  % Значення первісної функції
lagrange_results = zeros(n + 1, 3);   % Ініціалізація масиву для збереження результатів

% Обчислення похідної методом Лагранжа та порівняння з аналітичною похідною
for i = 1:(n + 1)
    x = x_points(i);
    derivative_lagrange = lagrange_derivative(x_points, y_points, x);
    analytical_derivative = integrand(x);
    error_derivative = abs(derivative_lagrange - analytical_derivative);
    lagrange_results(i, :) = [x, derivative_lagrange, error_derivative];
endfor

% Виведення результатів для чисельного інтегрування
disp("Чисельний інтеграл методом трапецій:");
disp(integral_trapezoidal);
disp("Похибка методу трапецій:");
disp(error_trapezoidal);

disp("Чисельний інтеграл методом Сімпсона:");
disp(integral_simpson);
disp("Похибка методу Сімпсона:");
disp(error_simpson);

% Виведення результатів для методу Лагранжа
disp("Результати чисельного диференціювання методом Лагранжа:");
disp(" Точка       Чисельна похідна       Похибка");
disp(lagrange_results);
