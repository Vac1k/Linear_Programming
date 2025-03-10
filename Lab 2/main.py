# -*- coding: utf-8 -*-
"""Untitled0.ipynb

Automatically generated by Colab.

Original file is located at
    https://colab.research.google.com/drive/1Mq3rwmfA7tMwM3bX68-CNLe_wlB1Tmuu
"""

import numpy as np
import pandas as pd
from scipy.interpolate import lagrange

# Вхідні дані
def integrand(x):
    return x / (x + 3) ** 2

def antiderivative(x):
    return 3 / (x + 3) + np.log(x + 3)

a, b = 0, 2          # Проміжок інтегрування
n = 40               # Кількість частин розбиття
h = (b - a) / n      # Крок h

# Функція для перевірки вхідних даних
def validate_inputs(a, b, n, integrand, antiderivative):
    if a >= b:
        raise ValueError("Нижня межа інтегрування має \
        бути меншою за верхню.")
    if not isinstance(n, int) or n <= 0:
        raise ValueError("Кількість частин розбиття має \
        бути додатнім цілим числом.")
    if not callable(integrand) or not callable(antiderivative):
        raise ValueError("Підінтегральна функція та первісна \
        функція мають бути визначеними функціями.")
    print("Вхідні дані коректні.")

# Перевірка вхідних даних
validate_inputs(a, b, n, integrand, antiderivative)

# Метод трапецій
def trapezoidal_rule(func, a, b, n):
    h = (b - a) / n
    x = np.linspace(a, b, n + 1)
    y = func(x)
    integral = h * (0.5 * y[0] + np.sum(y[1:n]) + 0.5 * y[n])
    return integral

# Метод Сімпсона
def simpsons_rule(func, a, b, n):
    if n % 2 == 1:  # Метод Сімпсона вимагає парної кількості частин
        n += 1
    h = (b - a) / n
    x = np.linspace(a, b, n + 1)
    y = func(x)
    integral = (h / 3) * (y[0] + 4 * np.sum(y[1:n:2]) + 2 *
                          np.sum(y[2:n-1:2]) + y[n])
    return integral

def lagrange_derivative(x_points, y_points, x_value):
    # Знаходимо індекс найближчої точки до x_value
    idx = np.searchsorted(x_points, x_value)

    # Визначаємо початок і кінець вікна (5 точок) для інтерполяції
    start_idx = max(0, idx - 2)
    end_idx = min(len(x_points), idx + 3)

    # Вибір підмножини точок для побудови інтерполяційного полінома
    x_subset = x_points[start_idx:end_idx]
    y_subset = y_points[start_idx:end_idx]

    # Створення інтерполяційного полінома Лагранжа та його похідної
    poly_interp = lagrange(x_subset, y_subset)
    poly_derivative = np.polyder(np.poly1d(poly_interp))

    # Обчислення похідної в точці x_value
    return float(poly_derivative(x_value))

# Обчислення інтегралів
integral_trapezoidal = trapezoidal_rule(integrand, a, b, n)
integral_simpson = simpsons_rule(integrand, a, b, n)

# Аналітичне значення інтегралу за допомогою первісної функції
analytical_integral = antiderivative(b) - antiderivative(a)

# Похибки для методів інтегрування
error_trapezoidal = abs(integral_trapezoidal - analytical_integral)
error_simpson = abs(integral_simpson - analytical_integral)

# Таблиця результатів для методів трапецій та Сімпсона
integration_results = pd.DataFrame({
    "Метод": ["Трапецій", "Сімпсона"],
    "Чисельний інтеграл": [integral_trapezoidal, integral_simpson],
    "Аналітичний інтеграл": [analytical_integral, analytical_integral],
    "Похибка": [error_trapezoidal, error_simpson]
})

# Точки для методу Лагранжа (всі точки розбиття)
x_points = np.linspace(a, b, n + 1)
y_points = antiderivative(x_points)  # Значення первісної функції

# Таблиця результатів для методу Лагранжа
lagrange_results = []
for x in x_points:
    derivative_lagrange = lagrange_derivative(x_points, y_points, x)
    analytical_derivative = integrand(x)
    error_derivative = abs(derivative_lagrange - analytical_derivative)
    lagrange_results.append([x, derivative_lagrange,
                             analytical_derivative, error_derivative])

lagrange_results_df = pd.DataFrame(lagrange_results,
                                   columns=["Точка", "Чисельна похідна",
                                            "Аналітична похідна", "Похибка"])

# Виведення результатів
print("Таблиця результатів для методів Трапецій та Сімпсона:")
print(integration_results)
print("\nТаблиця результатів для методу Лагранжа:")
print(lagrange_results_df)

import numpy as np
import pandas as pd

# Вхідні дані
def integrand(x):
    return x / (x + 3) ** 2

def antiderivative(x):
    return 3 / (x + 3) + np.log(x + 3)

# Функція для перевірки вхідних даних
def validate_inputs(a, b, n, integrand, antiderivative):
    if a >= b:
        raise ValueError("Нижня межа інтегрування має бути меншою за верхню.")
    if not isinstance(n, int) or n <= 0:
        raise ValueError("Кількість частин розбиття має бути додатнім цілим числом.")
    if not callable(integrand) or not callable(antiderivative):
        raise ValueError("Підінтегральна функція та первісна функція мають бути визначеними функціями.")
    print("Вхідні дані коректні.")

# Функція тестування крайових випадків
def test_cases():
    cases = [
        {"a": 0, "b": 2, "n": 40, "description": "Нормальний випадок з коректними значеннями"},
        {"a": 2, "b": 2, "n": 40, "description": "Неправильний інтервал: a дорівнює b"},
        {"a": 2, "b": 0, "n": 40, "description": "Неправильний інтервал: a більше за b"},
        {"a": 0, "b": 2, "n": -10, "description": "Неправильна кількість частин: n негативне"},
        {"a": 0, "b": 2, "n": 3.5, "description": "Неправильна кількість частин: n неціле число"},
        {"a": 0, "b": 2, "n": 40, "integrand": None, "description": "Відсутня підінтегральна функція"},
        {"a": 0, "b": 2, "n": 40, "antiderivative": None, "description": "Відсутня первісна функція"},
    ]

    for case in cases:
        print("\n" + "="*40)
        print(f"Тест-кейс: {case['description']}")
        print(f"Вхідні дані: a = {case.get('a')}, b = {case.get('b')}, n = {case.get('n')}")

        # Перевірка вхідних даних з обробкою виключень
        try:
            validate_inputs(
                a=case.get("a"),
                b=case.get("b"),
                n=case.get("n"),
                integrand=case.get("integrand", integrand),
                antiderivative=case.get("antiderivative", antiderivative)
            )
            print("Результат: Вхідні дані коректні.")
        except ValueError as e:
            print(f"Результат: Помилка - {e}")
        print("="*40)

# Запуск тестових випадків
test_cases()

