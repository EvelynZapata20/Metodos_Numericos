import os
import matlab.engine
from flask import Flask, render_template, request,send_file
import pandas as pd
import openpyxl

separador = os.path.sep 
dir_actual = os.path.dirname(os.path.abspath(__file__))
dir = separador.join(dir_actual.split(separador)[:-1])+'\matlab'

eng = matlab.engine.start_matlab()

app = Flask(__name__, static_url_path='/static')

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

@app.route('/secante', methods=['GET', 'POST'])
def secante():
    if request.method == 'POST':
            f= str(request.form['f']) 
            x0 = float(request.form['x0'])
            x1 = float(request.form['x1'])  
            tol = float(request.form['tol'])
            Terror = int(request.form['Terror'])
            niter = int(request.form['niter'])
            
            eng.addpath(dir)

            respuesta = eng.secante(f, x0, x1, tol, niter, Terror)
            df = pd.read_csv('tables/tabla_secante.csv')
            df = df.astype(str)
            data = df.to_dict(orient='records')

            # Lee el archivo CSV
            df = pd.read_csv('tables/tabla_secante.csv')
            # Escribe los datos en un nuevo archivo Excel
            df.to_excel('tables/tabla_secante.xlsx', index=False) 

            #Gráfica
            imagen_path = '../static/grafica_secante.png'  # Ruta de la imagen
            return render_template('resultado_secante.html',respuesta=respuesta, data=data,imagen_path=imagen_path)
        
    return render_template('formulario_secante.html')

@app.route('/secante/descargar', methods=['POST'])
def descargar_archivo():
    # Ruta del archivo que se va a descargar
    archivo_path = 'tables/tabla_secante.xlsx'

    # Enviar el archivo al cliente para descargar
    return send_file(archivo_path, as_attachment=True)

@app.route('/rf', methods=['GET', 'POST'])
def reglaFalsa():
    if request.method == 'POST':
            f= str(request.form['f']) 
            x0 = float(request.form['x0'])
            x1 = float(request.form['x1'])  
            tol = float(request.form['tol'])
            Terror = int(request.form['Terror'])
            niter = int(request.form['niter'])
            
            eng.addpath(dir)

            respuesta = eng.rf(f, x0, x1, tol, niter, Terror)
            print(respuesta[0])
            df = pd.read_csv('tables/tabla_reglaFalsa.csv')
            df = df.astype(str)
            data = df.to_dict(orient='records')

            # Lee el archivo CSV
            df = pd.read_csv('tables/tabla_reglaFalsa.csv')
            # Escribe los datos en un nuevo archivo Excel
            df.to_excel('tables/tabla_reglaFalsa.xlsx', index=False) 

            #Gráfica
            imagen_path = '../static/grafica_reglaFalsa.png'  # Ruta de la imagen
            return render_template('resultado_reglaFalsa.html',respuesta=respuesta, data=data,imagen_path=imagen_path)
        
    return render_template('formulario_reglaFalsa.html')

@app.route('/rf/descargar', methods=['POST'])
def descargar_archivorf():
    # Ruta del archivo que se va a descargar
    archivo_path = 'tables/tabla_reglaFalsa.xlsx'

    # Enviar el archivo al cliente para descargar
    return send_file(archivo_path, as_attachment=True)

if __name__ == '__main__':
    app.run(debug=True)
    
