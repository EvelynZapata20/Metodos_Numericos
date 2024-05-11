import os
import matlab.engine
from flask import Flask, render_template, request, send_file
import pandas as pd

eng = matlab.engine.start_matlab()
app = Flask(__name__)

# Obtener la ruta absoluta del directorio 'matlab'
separador = os.path.sep 
dir_actual = os.path.dirname(os.path.abspath(__file__))
dir_matlab = separador.join(dir_actual.split(separador)[:-1])+'\matlab'
dir_tables = os.path.join(dir_actual, 'tables')

# HOME
@app.route('/')
def home():
    return render_template('home.html')

# SECCIÓN 

# Método del punto fijo
@app.route('/punto_fijo', methods=['GET', 'POST'])
def punto_fijo():
    if request.method == 'POST':
        f = str(request.form['f']) 
        g = str(request.form['g'])
        x = float(request.form['x'])  
        tol = float(request.form['tol'])
        niter = int(request.form['niter'])
        
        eng.addpath(dir_matlab)
        [r, N, xn, fm, E] = eng.pf(f, g, x, tol, niter, nargout=5)
        N, xn, fm, E = list(N[0]), list(xn[0]), list(fm[0]), list(E[0])
        length = len(N)

        df = pd.read_csv(os.path.join(dir_tables, 'tabla_pf.csv'))
        df = df.astype(str)
        data = df.to_dict(orient='records')
        df.to_excel(os.path.join(dir_tables, 'tabla_pf.xlsx'), index=False) 

        imagen_path = os.path.join('static', 'grafica_pf.png')

        return render_template('resultado.html', r=r, N=N, xn=xn, fm=fm, E=E, length=length, data=data, imagen_path=imagen_path)

    return render_template('formulario_pf.html')

@app.route('/pf/descargar', methods=['POST'])
def descargar_archivo_pf():
    archivo_path = os.path.join(dir_tables, 'tabla_pf.xlsx')
    return send_file(archivo_path, as_attachment=True)

# Método de Bisección
@app.route('/biseccion', methods=['GET', 'POST'])
def biseccion():
    pass

if __name__ == '__main__':
    app.run(debug=True)
