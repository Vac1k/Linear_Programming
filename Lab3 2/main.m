
function main()
  % Main script to solve the differential equation
  x0 = 1;
  y0 = -1;
  z0 = 0;
  x_end = 2;
  h = 0.1;

  methods = {@runge_kutta_2nd_order, @runge_kutta_3rd_order, @runge_kutta_4th_order};
  method_names = {'2nd Order Runge-Kutta', '3rd Order Runge-Kutta', '4th Order Runge-Kutta'};

  x_values_analytical = linspace(x0, x_end, (x_end - x0) / h + 1);
  y_values_analytical = arrayfun(@main_y_analytical, x_values_analytical);

  figure;
  plot(x_values_analytical, y_values_analytical, 'k--', 'DisplayName', 'Analytical Solution');
  hold on;

  for i = 1:length(methods)
    [x_values, y_values] = methods{i}(@main_f1, @main_f2, x0, y0, z0, h, x_end);
    plot(x_values, y_values, 'DisplayName', method_names{i});
  end

  xlabel('x');
  ylabel('y');
  legend;
  grid on;
  title('Solution of the differential equation using different Runge-Kutta Methods and Analytical Solution');
  saveas(gcf, 'runge_kutta_comparison.png');

  for i = 1:length(methods)
    [x_values, y_values] = methods{i}(@main_f1, @main_f2, x0, y0, z0, h, x_end);
    errors = abs(y_values - y_values_analytical);
    error_norm = norm(errors);
    fprintf('Error for %s: %f\n', method_names{i}, error_norm);
  end
end

function dzdt = main_f1(x, y, z)
  dzdt = z;
end

function dydt = main_f2(x, y, z)
  dydt = 2 * exp(e) + 2 * z;
end

function result = main_y_analytical(x)
  result = 0.5 * (exp(e) * (1 - 2 * x) + exp(2 * x + e - 2) - 2);
end

function [x_values, y_values] = runge_kutta_2nd_order(f1, f2, x0, y0, z0, h, x_end)
  n = (x_end - x0) / h + 1;
  x = linspace(x0, x_end, n);
  y = zeros(1, n);
  z = zeros(1, n);
  y(1) = y0;
  z(1) = z0;

  for i = 2:n
    k1y = h * f1(x(i-1), y(i-1), z(i-1));
    k1z = h * f2(x(i-1), y(i-1), z(i-1));
    k2y = h * f1(x(i-1) + h, y(i-1) + k1y, z(i-1) + k1z);
    k2z = h * f2(x(i-1) + h, y(i-1) + k1y, z(i-1) + k1z);
    y(i) = y(i-1) + (k1y + k2y) / 2;
    z(i) = z(i-1) + (k1z + k2z) / 2;
  end

  x_values = x;
  y_values = y;
end

function [x_values, y_values] = runge_kutta_3rd_order(f1, f2, x0, y0, z0, h, x_end)
  n = (x_end - x0) / h + 1;
  x = linspace(x0, x_end, n);
  y = zeros(1, n);
  z = zeros(1, n);
  y(1) = y0;
  z(1) = z0;

  for i = 2:n
    k1y = h * f1(x(i-1), y(i-1), z(i-1));
    k1z = h * f2(x(i-1), y(i-1), z(i-1));
    k2y = h * f1(x(i-1) + h/2, y(i-1) + k1y/2, z(i-1) + k1z/2);
    k2z = h * f2(x(i-1) + h/2, y(i-1) + k1y/2, z(i-1) + k1z/2);
    k3y = h * f1(x(i-1) + h, y(i-1) - k1y + 2 * k2y, z(i-1) - k1z + 2 * k2z);
    k3z = h * f2(x(i-1) + h, y(i-1) - k1y + 2 * k2y, z(i-1) - k1z + 2 * k2z);
    y(i) = y(i-1) + (k1y + 4 * k2y + k3y) / 6;
    z(i) = z(i-1) + (k1z + 4 * k2z + k3z) / 6;
  end

  x_values = x;
  y_values = y;
end

function [x_values, y_values] = runge_kutta_4th_order(f1, f2, x0, y0, z0, h, x_end)
  n = (x_end - x0) / h + 1;
  x = linspace(x0, x_end, n);
  y = zeros(1, n);
  z = zeros(1, n);
  y(1) = y0;
  z(1) = z0;

  for i = 2:n
    k1y = h * f1(x(i-1), y(i-1), z(i-1));
    k1z = h * f2(x(i-1), y(i-1), z(i-1));
    k2y = h * f1(x(i-1) + h/2, y(i-1) + k1y/2, z(i-1) + k1z/2);
    k2z = h * f2(x(i-1) + h/2, y(i-1) + k1y/2, z(i-1) + k1z/2);
    k3y = h * f1(x(i-1) + h/2, y(i-1) + k2y/2, z(i-1) + k2z/2);
    k3z = h * f2(x(i-1) + h/2, y(i-1) + k2y/2, z(i-1) + k2z/2);
    k4y = h * f1(x(i-1) + h, y(i-1) + k3y, z(i-1) + k3z);
    k4z = h * f2(x(i-1) + h, y(i-1) + k3y, z(i-1) + k3z);
    y(i) = y(i-1) + (k1y + 2*k2y + 2*k3y + k4y) / 6;
    z(i) = z(i-1) + (k1z + 2*k2z + 2*k3z + k4z) / 6;
  end

  x_values = x;
  y_values = y;
end
