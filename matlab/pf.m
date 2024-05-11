function [r, N, xn, fm, E] = pf(f_str, g_str, x0, Tol, niter)
    f = str2func(['@(x)' f_str]);
    g = str2func(['@(x)' g_str]);
    
    c = 0;
    fm(c+1) = f(x0);
    fe = fm(c+1);
    E(c+1) = Tol + 1;
    error = E(c+1);
    xn(c+1) = x0;
    N(c+1) = c;
    
    while error > Tol && fe ~= 0 && c < niter
        xn(c+2) = g(x0);
        fm(c+2) = f(xn(c+2));
        fe = fm(c+2);
        E(c+2) = abs(xn(c+2) - x0);
        error = E(c+2);
        x0 = xn(c+2);
        N(c+2) = c+1;
        c = c+1;
    end
    
    if fe == 0
        r= sprintf('%f es raíz de f(x)\n', x0);
    elseif error < Tol
        r= sprintf('%f es una aproximación de una raíz de f(x) con una tolerancia= %f\n', x0, Tol);
    else
        r= sprintf('Fracasó en %f iteraciones\n', niter);
    end

    currentDir = fileparts(mfilename('fullpath'));

    tablesDir = fullfile(currentDir, '..', 'app', 'tables');
    mkdir(tablesDir);
    cd(tablesDir);
    csv_file_path = fullfile(tablesDir, 'tabla_pf.csv');
    T = table(N', xn', fm', E', 'VariableNames', {'Iteration', 'xn', 'fxn', 'E'}); 
    writetable(T, csv_file_path);


    fig = figure('Visible', 'off');
    xplot = linspace(min(x0) - 10, max(x0) + 10, 1000);
    hold on
    yline(0);
    plot(xplot, eval(subs(f, xplot)));
    scatter(xn(end), f(xn(end)), 'r', 'filled'); 
    img = getframe(gcf);
    staticDir = fullfile(currentDir, '..', 'app', 'static');
    mkdir(staticDir);
    imgPath = fullfile(staticDir, 'grafica_pf.png');
    imwrite(img.cdata, imgPath);
    
    hold off
    close(fig);

end
