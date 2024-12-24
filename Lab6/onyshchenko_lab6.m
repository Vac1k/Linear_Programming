costs_1 = [
    30, 24, 11, 12, 25;
    26,  4, 29, 20, 24;
    27, 14, 14, 10, 18;
     6, 14, 28,  8,  2
];

supply_1 = [21; 19; 15; 25];
demand_1 = [15; 15; 15; 15; 20];

costs_2 = [
     5,  4, 20,  5, 14;
    19, 20,  2,  4,  5;
     9,  6,  8, 19,  1;
     7, 15, 20,  6, 11
];

capacities = [
     5, 20, 14, 25, 13;
    19, 22, 15,  4, 12;
     6,  8, 15,  5, 10;
    14,  7,  2, 23, 20
];

supply_2 = [60; 50; 40; 20];
demand_2 = [10; 50; 40; 50; 20];


disp('Solving transportation problem without capacity constraints:');
try
    [x_no_capacity, cost_no_capacity] = transportation_problem_no_capacity(costs_1, supply_1, demand_1);
    fprintf("%s\n", repmat("=", 1, 60));
    fprintf("%s\n", repmat(" ", 1, 15), "Результати розв'язання транспортної задачі");
    fprintf("%s\n", repmat("=", 1, 60));
    disp(x_no_capacity);
    fprintf("\nМатриця розв'язку:\n");
    fprintf("%s\n", repmat("-", 1, 60));
    for i = 1:size(x_no_capacity, 1)
        fprintf(" %8.2f |", x_no_capacity(i, :));
        fprintf("\n");
    end
    fprintf("%s\n", repmat("-", 1, 60));

    fprintf("\nЗагальна вартість перевезення:\n");
    fprintf("Вартість: %.2f одиниць\n", cost_no_capacity);
    fprintf("%s\n", repmat("-", 1, 60));

    fprintf("\nДеталі постачань (постачальник -> споживач):\n");
    for i = 1:size(x_no_capacity, 1)
        for j = 1:size(x_no_capacity, 2)
            if x_no_capacity(i, j) > 0
                fprintf("Постачальник P%d -> Споживач S%d: %.2f одиниць\n", i, j, x_no_capacity(i, j));
            end
        end
    end

    fprintf("%s\n", repmat("=", 1, 60));

catch err
    disp('Error in solving transportation problem without capacity constraints:');
    disp(err.message);
end


disp('Solving transportation problem with capacity constraints:');
try
    [x_with_capacity, cost_with_capacity] = transportation_problem_with_capacity(costs_2, supply_2, demand_2, capacities);
    fprintf("%s\n", repmat("=", 1, 60));
    fprintf("%s\n", repmat(" ", 1, 15), "Результати розв'язання транспортної задачі");
    fprintf("%s\n", repmat("=", 1, 60));

    fprintf("\nМатриця обмеження:\n");
    fprintf("%s\n", repmat("-", 1, 60));
    for i = 1:size(capacities, 1)
        fprintf(" %8.2f |", capacities(i, :));
        fprintf("\n");
    end
    fprintf("%s\n", repmat("-", 1, 60));

    fprintf("\nМатриця розв'язку:\n");
    fprintf("%s\n", repmat("-", 1, 60));
    for i = 1:size(x_with_capacity, 1)
        fprintf(" %8.2f |", x_with_capacity(i, :));
        fprintf("\n");
    end
    fprintf("%s\n", repmat("-", 1, 60));

    fprintf("\nЗагальна вартість перевезення:\n");
    fprintf("Вартість: %.2f одиниць\n", cost_with_capacity);
    fprintf("%s\n", repmat("-", 1, 60));

    fprintf("\nДеталі постачань (постачальник -> споживач):\n");
    for i = 1:size(x_with_capacity, 1)
        for j = 1:size(x_with_capacity, 2)
            if x_with_capacity(i, j) > 0
                fprintf("Постачальник P%d -> Споживач S%d: %.2f одиниць\n", i, j, x_with_capacity(i, j));
            end
        end
    end

    fprintf("%s\n", repmat("=", 1, 60));

catch err
    disp('Error in solving transportation problem with capacity constraints:');
    disp(err.message);
end
