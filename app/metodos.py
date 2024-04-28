import os
from flask import Flask, render_template, request
import matlab.engine


separador = os.path.sep 
dir_actual = os.path.dirname(os.path.abspath(__file__))
dir = separador.join(dir_actual.split(separador)[:-1])+'\matlab'

eng = matlab.engine.start_matlab()

app = Flask(__name__)


import numpy as np


@app.route('/', methods=['GET', 'POST'])
def punto_fijo():
    if request.method == 'POST':
        f= str(request.form['f']) 
        g= str(request.form['g'])
        x = float(request.form['x'])  
        tol = float(request.form['tol'])
        niter = int(request.form['niter'])
        
        eng.addpath(dir)
        [N, xn, fm, E]= eng.pf(f, g, x, tol, niter, nargout=4)
        N, xn, fm, E = list(N[0]), list(xn[0]), list(fm[0]), list(E[0])
        length = len(N)
        return render_template('resultado.html', N=N, xn=xn, fm=fm, E=E, length=length)
        
    return render_template('formulario_pf.html')

@app.route('/newton', methods=['GET', 'POST'])
def newton():
    if request.method == 'POST':
        f= str(request.form['f']) 
        x = float(request.form['x'])  
        tol = float(request.form['tol'])
        niter = int(request.form['niter'])

        eng.addpath(dir)
        [N, xn, fm, dfm, E] = eng.newton(f, x, tol, niter, nargout=5)
        N, xn, fm, dfm, E = list(N[0]), list(xn[0]), list(fm[0]), list(dfm[0]), list(E[0])
        length = len(N)
        return render_template('resultado_newton.html', N=N, xn=xn, fm=fm, dfm=dfm, E=E, length=length)
    
    return render_template('formulario_newton.html')

if __name__ == '__main__':
    app.run(debug=True)
