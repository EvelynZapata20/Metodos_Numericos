function [xi, errores] = multiple_roots(fn, xi, tol, k, et)
    % Validar el tipo de error
    if ~ismember(et, {'Decimales Correctos', 'Cifras Significativas'})
        error('El tipo de error no es valido');
    end

    % Convertir la función de entrada a una expresión simbólica y derivar
    syms x;
    fn = str2sym(fx);
    fn_1 = diff(fn, x);
    fn_2 = diff(fn_1, x);


    % Inicializar variables
    errores = [];
    error = tol + 1;
    n = 0;

    % Iteración principal del método
    while error > tol && n < k
        fxi = double(subs(fn, x, xi));
        fxi_1 = double(subs(fn_1, x, xi));
        fxi_2 = double(subs(fn_2, x, xi));

        if fxi == 0
            errores = [errores, 0];
            break;
        end

        xi_1 = xi - (fxi * fxi_1) / (fxi_1^2 - fxi * fxi_2);

        if strcmp(et, 'Decimales Correctos')
            error = abs(xi_1 - xi);
        else
            error = abs(xi_1 - xi) / abs(xi_1);
        end

        xi = xi_1;
        errores = [errores, error];
        n = n + 1;
    end
end
