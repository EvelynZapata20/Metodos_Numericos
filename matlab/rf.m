function [respuesta] = ReglaFalsa(func,x0,x1,Tol,niter,Terror)

    f = str2func(['@(x)' func]);
    c=0;
    xi(c+1)=x0;
    xs(c+1)=x1;
    fi(c+1)=eval(subs(f,x0));
    fs(c+1)=eval(subs(f,x1));
    %raíces inmediatas
    if fi(c+1)==0
        xm(c+1)=xi(c+1);
        fm(c+1)=eval(subs(f,xm(c+1)));
        E(c+1)=0;
        respuesta=sprintf('el límite inferior %f es raiz de f(x)',xi(c+1))
        T = table((0:1:c)', xm', xi', xs', fm', fi' , fs', E', VariableNames=["n","x_m","x_i","x_s","f_m","f_i","f_s","E"]);
    elseif fs(c+1)==0
        xm(c+1)=xs(c+1);
        fm(c+1)=eval(subs(f,xm(c+1)));
        E(c+1)=0;
        respuesta=sprintf('el límite superior %f es raiz de f(x)',xs(c+1))
        T = table((0:1:c)', xm', xi', xs', fm', fi' , fs', E', VariableNames=["n","x_m","x_i","x_s","f_m","f_i","f_s","E"]);
    %certeza de raíz
    elseif fs(c+1)*fi(c+1)<0
        fi(c+1)=eval(subs(f,xi));
        fs(c+1)=eval(subs(f,xs));
        %hallamos la pendiente
        p=(fs(c+1)-fi(c+1))/(xs(c+1)-xi(c+1));
        %despejamos x
        xm(c+1)=(p*xi(c+1)-fi(c+1))/p;
        fm(c+1)=eval(subs(f,xm(c+1)));
        fe=fm(c+1);
        E(c+1)=Tol+1;
        error=E(c+1);
        while error>Tol && fe~=0 && c<niter
            %verificamos quien es el x_ que debe actualizarse
            if fi(c+1)*fe<0
                xs(c+2)=xm(c+1);
                fs(c+2)=eval(subs(f,xs(c+2)));
                xi(c+2)=xi(c+1);
                fi(c+2)=fi(c+1);
            else
                xi(c+2)=xm(c+1);
                fi(c+2)=eval(subs(f,xi(c+2)));
                xs(c+2)=xs(c+1);
                fs(c+2)=fs(c+1);
            end
            %hallamos la pendiente
            p=(fs(c+2)-fi(c+2))/(xs(c+2)-xi(c+2));
            %despejamos x
            xm(c+2)=(p*xi(c+2)-fi(c+2))/p;
            fm(c+2)=eval(subs(f,xm(c+2)));
            fe=fm(c+2);
            if Terror==0
                E(c+2)=abs(xm(c+2)-xm(c+1));
            else
                E(c+2)=abs((xm(c+2)-xm(c+1))/xm(c+2));
            end
            error=E(c+2);
            c=c+1;
        end
        if fe==0 
           respuesta=sprintf('%f es raiz exacta de f(x), lograda en en %d iteraciones',xm(c+1),c)
           E(c+2)=0
            T = table((0:1:c)', xm', xi', xs', fm', fi' , fs', E', VariableNames=["n","x_m","x_i","x_s","f_m","f_i","f_s","E"]);
        elseif error<Tol
           respuesta=sprintf('\n%f es una aproximación de una raiz de f(x) con una tolerancia= %f en %d iteraciones',xm(c+1),Tol,c)
            T = table((0:1:c)', xm', xi', xs', fm', fi' , fs', E', VariableNames=["n","x_m","x_i","x_s","f_m","f_i","f_s","E"]);
        else
           respuesta=sprintf('Fracasó en %f iteraciones',niter)

           T = table(niter, VariableNames=["iteraciones"]);
        end
    else %no certeza de raíz
        xm(c+1)=xi(c+1);
        fm(c+1)=fi(c+1);
        E(c+1)=100;
        respuesta=sprintf('El intervalo es inadecuado')         
        T = table(-1, VariableNames=["intervalo"]);
    end
    csv_file_path = "tables/tabla_reglaFalsa.csv";
        writetable(T, csv_file_path)
    fig = figure('Visible', 'off');
    xplot=((xm(c+1)-2):0.1:(xm(c+1)+2));
    hold on
    yline(0);
    plot(xplot,eval(subs(f,xplot)));
   img = getframe(gcf);
        imwrite(img.cdata, './static/grafica_reglaFalsa.png');
    hold off
    close(fig);
end