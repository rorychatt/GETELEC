import { processIvDataInput } from "./ivDataInput.js"

function main() {

    let socket = io();
    
    let voltage, current, workFunction, voltageMult, currentMult, workFunctionMult, result;

    let button = document.getElementById("enterButton");

    button.addEventListener("click", checkValidity);

    const ctx = document.getElementById('myChart').getContext('2d');

    const indicatorOptions = {

        radius: 4,
        borderWidth: 1,
        borderColor: 'red',
        backgroundColor: 'transparent'

      };
      
      // Override getLabelAndValue to return the interpolated value
      const getLabelAndValue = Chart.controllers.line.prototype.getLabelAndValue;

      Chart.controllers.line.prototype.getLabelAndValue = function(index) {

        if (index === -1) {

          const meta = this.getMeta();
          const pt = meta._pt;
          const vScale = meta.vScale;
          const xScale = meta.xScale;

          return {

            label: '',
            value: "x: " + Math.round(xScale.getValueForPixel(pt.x) * 10000 ) / 10000 + 
            ", y: " + Math.round(vScale.getValueForPixel(pt.y) * 10000 ) / 10000

          };

        }

        return getLabelAndValue.call(this, index);

      }
      
      // The interaction mode
      Chart.Interaction.modes.interpolate = function(chart, e, option) {

        const x = e.x;
        const items = [];
        const metas = chart.getSortedVisibleDatasetMetas();

        for (let i = 0; i < metas.length; i++) {

          const meta = metas[i];
          const pt = meta.dataset.interpolate({
            x
          }, "x");

          if (pt) {

            const element = new Chart.elements.PointElement({ ...pt,
              options: { ...indicatorOptions
              }
            });

            meta._pt = element;

            items.push({

              element,
              index: -1,
              datasetIndex: meta.index

            });
            
          } else {

            meta._pt = null;

          }
        }

        return items;

      };
      
      // Plugin to draw the indicators
      Chart.register({

        id: 'indicators',

        afterDraw(chart) {

          const metas = chart.getSortedVisibleDatasetMetas();

          for (let i = 0; i < metas.length; i++) {

            const meta = metas[i];

            if (meta._pt) {

              meta._pt.draw(chart.ctx);

            }

          }

        },

        afterEvent(chart, args) {

          if (args.event.type === 'mouseout') {

            const metas = chart.getSortedVisibleDatasetMetas();

            for (let i = 0; i < metas.length; i++) {

              metas[i]._pt = null;

            }

            args.changed = true;
            
          }
          
        }
      })

    const data = [{ x: 0.03, y: 12121 }, { x: 0.04, y: 2.21 }, { x: 0.045, y: 0.3 },
        { x: 0.05, y: 2 }, { x: 0.06, y: 2.3 }, { x: 0.075, y: 2.57 }]

    let regressionData;

    let myChart = new Chart(ctx, {

        data: {

            datasets: [

                {
                    label: "Fitted line",
                    fill: false,
                    lineTension: 0,
                    borderColor: "rgb(0, 79, 32)",
                    backgroundColor: "rgb(0, 79, 32)",
                    data: data,
                    type: 'scatter',
                    showLine: true,
                    pointRadius: 0,
                    pointHoverRadius: 0,
                    interpolate: true

                },

                {
                    label: "Input data points",
                    fill: false,
                    lineTension: 0.1,
                    borderColor: "rgb(145, 64, 2)",
                    backgroundColor: "rgb(145, 64, 2)",
                    type: 'scatter',
                    data: regressionData,
                    interpolate: false
        
                }

            ]
        },

        options: {

            fill: false,
            lineTension: 0.1,

            interaction:{
                intersect: false,
                mode: 'interpolate',
                axis: "x"

            },

            scales: {
                y: {

                    title: {

                        display: true,
                        text: "Current"

                    },

                    type: "logarithmic",
                    position: "bottom",

                    ticks: {

                        callback: function (value, index, ticks) {

                            if (value === 1000000) {

                                return "1 [MA]"

                            }

                            if (value === 100000) {

                                return "100 [kA]"

                            }

                            if (value === 10000) {

                                return "10 [kA]"

                            }

                            if (value === 1000) {

                                return "1 [kA]"

                            }

                            if (value === 100) {

                                return "100 [A]"

                            }

                            if (value === 10) {

                                return "10 [A]"

                            }

                            if (value === 1) {

                                return "1 [A]"

                            }

                            if (value === 0.1){

                                return "100 [mA]"

                            }

                            if(value === 0.01){

                                return "10 [mA]"

                            }

                            if(value === 0.001){

                                return "1 [mA]"

                            }
                            
                            return null
                        }
                    }

                },

                x: {

                    title: {

                        text: "1 / Local Field, [1/(V/nm)]",
                        display: true
                    },

                    type: "linear",
                    position: "bottom",
                    ticks: {

                        callback: function (value, index, ticks) {

                            if(String(value).length > 4){
                                value = Math.round( value * 100) / 100;
                            }

                            return value;
                        }

                    }

                },
            },

            plugins: {

                tooltip: {

                    mode: 'interpolate',
                    intersect: false,
                    enabled: true

                },

                title: {

                    display: true,
                    text: "Radius: 50.000 nm, β: 0.017306 nm^-1, σAeff: 3.4500 nm^2",
                    font: {
                        size: 24
                    }

                },

                zoom:{

                    zoom:{

                        wheel: {enabled: true},
                        pinch: {enabled: false},
                        drag: {enabled: true, modifierKey: 'ctrl'},
                        mode:'xy'

                    },

                    pan:{

                        enabled: true,
                        mode: 'xy'

                    },

                    limits: {

                        x: {min: 0, max: 0.4},
                        y: {min: -100, max: 5e4}

                    }
                },

                hover:{

                    intercept: false

                }
            }
        },

        tooltips: {

            mode: "interpolate",
            intersect: true

        },

        plugins: [
            //tooltipLine
        ]     
    });

    function checkValidity(){

        if(errorDivs.length > 0){

            errorDivs.forEach(div =>{
                div.remove();
            })

            errorDivs = [];

        }

        voltage = document.getElementById("voltage_in").value;
        current = document.getElementById("current_in").value;
        workFunction = document.getElementById("work_function_in").value;

        voltageMult = document.getElementById("voltage_mult_in").value;
        currentMult = document.getElementById("current_mult_in").value;
        workFunctionMult = document.getElementById("work_function_mult_in").value;


        if (voltage == "") voltage = "2.413e+02, 2.511e+02, 2.622e+02, 2.706e+02, 2.803e+02, 2.915e+02, 2.999e+02, 3.096e+02, 3.208e+02, 3.305e+02, 3.403e+02, 3.515e+02, 3.612e+02, 3.710e+02, 3.808e+02, 3.891e+02, 4.003e+02, 4.100e+02, 4.184e+02, 4.338e+02, 4.491e+02, 4.644e+02, 4.826e+02, 4.993e+02";
        if(current == "") current = "8.719e-01, 1.582e+00, 2.967e+00, 5.038e+00, 8.555e+00, 1.406e+01, 2.309e+01, 3.670e+01, 5.643e+01, 8.678e+01, 1.249e+02, 1.797e+02, 2.502e+02, 3.371e+02, 4.540e+02, 6.116e+02, 7.459e+02, 9.720e+02, 1.267e+03, 1.764e+03, 2.376e+03, 3.096e+03, 4.310e+03, 5.617e+03";
        if(workFunction == "") workFunction = "4.5";

        let _voltage = processIvDataInput(voltage);
        let _current = processIvDataInput(current);

        let _workFunction = workFunction;

        for(let i = 0; i < _voltage.length; i++){
            _voltage[i] = _voltage[i] * voltageMult;
        }

        for(let i = 0; i < _current.length; i++){
            _current[i] = _current[i] * currentMult;
        }

        _workFunction = _workFunction * workFunctionMult;
        
        let canCompute = true;

        if(_voltage.length != _current.length){

            if(_voltage.length > _current.length){

                raiseInputError("2000");
                canCompute = false;

            } else if (_current.length > _voltage.length) {

                canCompute = false;
                raiseInputError("2001");

            }


        } else if ((_current.length < 3 || _voltage.length < 3) && (canCompute == true)){
           
            canCompute = false;
            raiseInputError("2005");
        
        
        } else {

            if(canCompute == true){

                _voltage.forEach(voltage => {

                    if((voltage < 0 || voltage > 100000 ) && (canCompute == true)) {
    
                        canCompute = false;
                        raiseInputError("2002");
                    
                    }
                    
    
                });
    
                _current.forEach(current => {
    
                    if((current < 0 || current > 10000) &&(canCompute == true)) {
                        
                        canCompute = false;
                        raiseInputError("2003");
    
                    };
    
                });
    
                if((parseFloat(_workFunction) < 0.5 || parseFloat(_workFunction) > 10) && (canCompute == true)) {
    
                    raiseInputError("2004");
                    canCompute = false;
                    
                };
    
                let data = [_voltage, _current, _workFunction];

                console.log(data);
    
                if(canCompute) socket.emit('calculateIv', data);
    

            }

        }
    }

    socket.on('calculatedData', (arg) => {

        result = processServerOut(arg);
        updateGraph(result);

    })

    socket.on('logServerSideError', (arg) => {

        alert("Got an error from server while computing data. Check console for more info.");
        console.log("Error server-side: ");
        console.log(arg);

    })

    function updateGraph(dict){

        const rad = Math.round( dict.Radius * 1000 ) / 1000;
        const beta = Math.round( dict.beta * 100000 ) / 100000;
        const sigmaAeff = Math.round( dict.sigma_Aeff * 1000 ) / 1000;

        const xData = dict.xplot_line;
        const yData = dict.yplot_line;

        const xReg = dict.xplot_mrk;
        const yReg = dict.yplot_mrk;

        updateTitle();
        updateAxes();
        updatePoints();
        updateRegressionLine();

        function updateRegressionLine(){

            const regressionPoints = createPoints(xReg, yReg);

            let dataSet = myChart.data.datasets[1];

            regressionPoints.forEach(point =>{
                dataSet.data.push(point);
            })

            myChart.update();

        }

        function updateTitle(){

            if( inVoltageMode ) {myChart.options.plugins.title.text = "Radius: " + rad + " nm, β: " + beta + " nm^-1, σAeff: " + sigmaAeff + " nm^2"; return;}
            else { myChart.options.plugins.title.text = "Radius: " + rad + " nm, β: " + beta + ", σAeff: " + sigmaAeff + " nm^2";}

        }

        function updateAxes(){

        }

        function updatePoints(){

            myChart.data.labels.pop();

            myChart.data.datasets.forEach((dataset) => {

                dataset.data = null;

            });

            myChart.update();

            let dataSet = myChart.data.datasets[0];

            const points = createPoints(xData, yData)

            points.forEach((point) => {

                dataSet.data.push(point);

            })

            myChart.update();
        }
        
        function createPoints(xS, yS){

            let res = [];

            for(let i = 0; i < xS.length; i++){

                res.push({x: xS[i], y: yS[i]});

            }
            
            return res;
        }

    }

}

let errorDivs = [];
let inVoltageMode = true;

main();
loadEventListeners();

function processServerOut(arg){
    try{ arg = JSON.parse(arg); return arg} catch (e){ console.log(e)}
}

function loadEventListeners(){

    let voltageUnitDiv = document.getElementById("voltage_mult_in");

    const opt1 = ["[V]", "[kV]"];
    const opt2 = ["[V/m]", "[kV/m]"];

    document.getElementById('voltageSelectDiv').addEventListener('change', function() {

        console.log(voltageSelectDiv.value);
        console.log(voltageUnitDiv.text);
        console.log(voltageUnitDiv.options);


        if(voltageSelectDiv.value == 1){
            
            voltageUnitDiv.options[0].text = opt1[0];
            voltageUnitDiv.options[1].text = opt1[1];
            inVoltageMode = true;

        }

        if(voltageSelectDiv.value == 2){

            voltageUnitDiv.options[0].text = opt2[0];
            voltageUnitDiv.options[1].text = opt2[1];
            inVoltageMode = false;

        }


      });

}

export function raiseInputError(id){

    switch(id){

        case "2000": addErrorDiv("Can not create graph as in voltage data there are more points than in current data"); break;
        case "2001": addErrorDiv("Can not create graph as in current data there are more points than in voltage data"); break;
        case "2002": addErrorDiv("One of the voltage values is out of bounds 0 < x < 100'000 V"); break;
        case "2003": addErrorDiv("One of the current values is out of bounds 0 < x < 10'000 A"); break;
        case "2004": addErrorDiv("Work function value is out of bounds 0.5 < x < 10 eV"); break;
        case "2005": addErrorDiv("One must enter at least 3 points for voltage and current data"); break;
        case "2006": addErrorDiv("One of the input lines has no separator between values! Check console for more info"); break;
        case "2007": addErrorDiv("One of the input lines has a data of unknown type! Check console for more info"); break;
        default: addErrorDiv("Unknown error"); 
    }

    function addErrorDiv(message){

        console.log(message);

        const template = `
        <section class="container showcase alert alert-danger alert-dismissible my-auto animated bounceInLeft">
            <strong class="mx-2">Error!</strong> ${message}!
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </section>
        `;

        let relativeDiv = document.getElementById("myChart");
        let errorDiv = document.createElement("div");
        errorDiv.innerHTML = template;

        let section = errorDiv.children[0];

        errorDivs.push(section)

        insertAfter(section, relativeDiv);

    }   


}

function insertAfter(newNode, existingNode) {

    existingNode.parentNode.insertBefore(newNode, existingNode.nextSibling);

}