function [N, xn, fm, dfm, E] = newton(f_str, x0, Tol, niter)
    syms x
    f = str2sym(['@(x)' f_str]);
    df = diff(f);
    c = 0;
    fm(c+1) = eval(subs(f, x0));
    fe = fm(c+1);
    dfm(c+1) = eval(subs(df, x0));
    dfe = dfm(c+1);
    E(c+1) = Tol + 1;
    error = E(c+1);
    xn(c+1) = x0;
    N(c+1) = c;
    while error > Tol && c < niter
        xn(c+2) = x0 - fe / dfe;
        fm(c+2) = eval(subs(f, xn(c+2)));
        fe = fm(c+2);
        dfm(c+2) = eval(subs(df, xn(c+2)));
        dfe = dfm(c+2);
        E(c+2) = abs(xn(c+2) - x0);
        error = E(c+2);
        x0 = xn(c+2);
        N(c+2) = c+1;
        c = c + 1;
    end
    if fe == 0
       fprintf('%f es raiz de f(x) \n', x0)
    elseif error < Tol
       fprintf('%f es una aproximación de una raiz de f(x) con una tolerancia= %f \n', x0, Tol)
    elseif dfe == 0
       fprintf('%f es una posible raiz múltiple de f(x) \n', x0)
    else 
       fprintf('Fracasó en %f iteraciones \n', niter) 
    end
end