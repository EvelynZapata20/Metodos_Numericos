function [T, s, E, fm] = Biseccion(func, xi, xs, Tol, niter)
    syms x

    f = str2sym(func);

    fi = eval(subs(f, xi));
    fs = eval(subs(f, xs));

    if fi == 0
        s = xi;
        E = 0;
        fprintf('%f es raiz de f(x)', xi)
    elseif fs == 0
        s = xs;
        E = 0;
        fprintf('%f es raiz de f(x)', xs)
    elseif fs * fi < 0
        c = 0;
        xm = (xi + xs) / 2;
        fm(c + 1) = eval(subs(f, xm));
        fe = fm(c + 1);
        E(c + 1) = Tol + 1;
        error = E(c + 1);

        Iteration = [];
        a = [];
        b = [];
        Xm = [];
        func = [];
        Error = [];

        while error > Tol && fe ~= 0 && c < niter
            Iteration = [Iteration, c];
            a = [a, xi];
            b = [b, xs];
            Xm = [Xm, xm];
            func = [func, fe];
            Error = [Error, error];

            if fi * fe < 0
                xs = xm;
                fs = eval(subs(f, xs));
            else
                xi = xm;
                fi = eval(subs(f, xi));
            end
            xa = xm;
            xm = (xi + xs) / 2;
            fm(c + 2) = eval(subs(f, xm));
            fe = fm(c + 2);
            E(c + 2) = abs(xm - xa);
            error = E(c + 2);
            c = c + 1;
        end

        tabla = table(Iteration', a', Xm', b', func', Error', 'VariableNames', {'Iteration', 'a', 'xi', 'b', 'f(xi)', 'Error'});
        % Guardar la tabla en un archivo CSV
        writetable(tabla, 'tabla_biseccion.csv');

        fig = figure('Visible', 'off');
        xplot = linspace(min(xi, xs) - 10, max(xi, xs) + 10, 1000);
        hold on
        yline(0);
        plot(xplot, eval(subs(f, xplot)));
        scatter(Xm(end), eval(subs(f, Xm(end))), 'r', 'filled');
        imgPath = 'grafica_biseccion.png';
        saveas(fig, imgPath);
        hold off
        close(fig);

        T = tabla;
        s = xm;
        if fe == 0
            r= printf('%f es raiz de f(x)', xm)
        elseif error < Tol
            fprintf('%f es una aproximación de una raiz de f(x) con una tolerancia= %f', xm, Tol)
        else
            fprintf('Fracasó en %f iteraciones', niter)
        end
    else
        fprintf('El intervalo es inadecuado')
    end
end
