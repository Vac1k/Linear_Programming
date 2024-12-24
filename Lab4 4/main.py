import numpy as np
from scipy.optimize import minimize

# Параметри для округлення результатів
ROUNDING_DIGITS = 4

true_res = -47/9

# Функція, яку потрібно мінімізувати
def target_function(variables):
    x, y = variables
    return 3*x**2 - x + y**3 - 3 * y ** 2 - 1

# Початкова точка для оптимізації
initial_point = np.array([-1, -1])

# Верифікація вхідних даних
def verify_input_data(func, initial_point):
    if not callable(func):
        raise ValueError("Цільова функція має бути викликуваним об'єктом (функцією).")
    if not isinstance(initial_point, np.ndarray):
        raise ValueError("Початкова точка має бути масивом NumPy.")
    if initial_point.size == 0:
        raise ValueError("Початкова точка не може бути порожньою.")
    if not np.issubdtype(initial_point.dtype, np.number):
        raise ValueError("Усі координати початкової точки мають бути числами.")


verify_input_data(target_function, initial_point)

# Обчислення градієнта за допомогою центральної різниці
def compute_gradient(f, x, delta = 1e-6):
  if isinstance(x, list) or isinstance(x, np.ndarray):
    deltas = np.diag([delta] * len(x))
    return np.array([(f(x+d) - f(x-d)) / (2 * delta) for d in deltas])
  else:
    return (f(x+delta) - f(x-delta))/(2*delta)

# Метод зворотного пошуку для визначення довжини кроку
def backtracking_line_search(func, point, gradient, initial_step=1.0, reduction_factor=0.5, tolerance=1e-4):
    step = initial_step
    while func(point - step * gradient) > func(point) - tolerance * step * np.dot(gradient, gradient):
        step *= reduction_factor
        if step < 1e-8:  # Запобігання надто малим крокам
            break
    return step

# Алгоритм найшвидшого спуску
def gradient_descent(func, start_position, convergence_threshold=1e-6, max_iterations=10000):
    current_position = np.copy(start_position)
    for step_count in range(max_iterations):
        gradient = compute_gradient(func, current_position)
        gradient_norm = np.linalg.norm(gradient)

        # # Перевірка, чи градієнт занадто малий
        # if gradient_norm < 1e-8:
        #     print(f"Градієнт занадто малий: {gradient_norm:.8f}")
        #     break

        step_size = backtracking_line_search(func, current_position, gradient)
        new_position = current_position - step_size * gradient

        # Перевірка збіжності
        displacement = np.linalg.norm(new_position - current_position)
        if displacement < convergence_threshold:
            print(f"Алгоритм збігся за {step_count + 1} ітерацій.")
            print(f"Точність розв'язку: {displacement:.8f}")
            return new_position

        current_position = new_position

    print("Досягнуто максимальної кількості ітерацій без збіжності.")
    return current_position

# Оптимізація методом Нелдера-Міда
nelder_mead_result = minimize(
    target_function,
    initial_point,
    method='Nelder-Mead',
    tol=1e-6,
    options={'xatol': 1e-8, 'fatol': 1e-8}
)

print("Оптимізація методом Нелдера-Міда:")
print(f"Кількість ітерацій: {nelder_mead_result.nit}")
print(f"Мінімум знайдено в точці: {np.round(nelder_mead_result.x, ROUNDING_DIGITS)}")
print(f"Значення функції в мінімумі: {np.round(nelder_mead_result.fun, ROUNDING_DIGITS)}")
print(f"Точність за значенням: {np.round(np.abs(true_res - nelder_mead_result.fun), ROUNDING_DIGITS)}")
print()
# Оптимізація градієнтним спуском
print("Оптимізація методом градієнтного спуску:")
optimal_position = gradient_descent(target_function, initial_point)
print(f"Мінімум знайдено в точці: {np.round(optimal_position, ROUNDING_DIGITS)}")
print(f"Значення функції в мінімумі: {np.round(target_function(optimal_position), ROUNDING_DIGITS)}")
print(f"Точність за значенням: {np.round(np.abs(true_res - target_function(optimal_position)), ROUNDING_DIGITS)}")

true_res = -6

# Функція, яку потрібно мінімізувати
def target_function(variables):
    x, y = variables
    return 6*x + 2 * x**2 - 2 * x * y + 2 * y ** 2

# Початкова точка для оптимізації
initial_point = np.array([-1, -1])


verify_input_data(target_function, initial_point)
# Оптимізація методом Нелдера-Міда
nelder_mead_result = minimize(
    target_function,
    initial_point,
    method='Nelder-Mead',
    tol=1e-6,
    options={'xatol': 1e-8, 'fatol': 1e-8}
)

print("Оптимізація методом Нелдера-Міда:")
print(f"Кількість ітерацій: {nelder_mead_result.nit}")
print(f"Мінімум знайдено в точці: {np.round(nelder_mead_result.x, ROUNDING_DIGITS)}")
print(f"Значення функції в мінімумі: {np.round(nelder_mead_result.fun, ROUNDING_DIGITS)}")
print(f"Точність за значенням: {np.round(np.abs(true_res - nelder_mead_result.fun), ROUNDING_DIGITS)}")
print()
# Оптимізація градієнтним спуском
print("Оптимізація методом градієнтного спуску:")
optimal_position = gradient_descent(target_function, initial_point)
print(f"Мінімум знайдено в точці: {np.round(optimal_position, ROUNDING_DIGITS)}")
print(f"Значення функції в мінімумі: {np.round(target_function(optimal_position), ROUNDING_DIGITS)}")
print(f"Точність за значенням: {np.round(np.abs(true_res - target_function(optimal_position)), ROUNDING_DIGITS)}")
