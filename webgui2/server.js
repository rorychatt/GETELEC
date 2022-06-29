const express = require("express");
const https = require("https");

const app = express();

const {
  PythonShell
} = require('python-shell');
const winston = require('winston');

const httpsOptions = {
  key:  __dirname + "/key.pem",
  cert: __dirname + "/cert.pem"
}

https.createServer({key: httpsOptions.key, cert: httpsOptions.cert}, app).listen(4000, ()=>{
  console.log(updateTime() + 'server is running at port 4000')
});

const readline = require('readline').createInterface({
  input: process.stdin,
  output: process.stdout
});

app.use(express.static(__dirname));
app.get('/', (req, res) => {

  res.sendFile(__dirname + '/index.html');

});

const logger = winston.createLogger({

  level: 'info',
  format: winston.format.json(),
  defaultMeta: {
    service: 'user-service'
  },
  transports: [
    //
    // - Write all logs with importance level of `error` or less to `error.log`
    // - Write all logs with importance level of `info` or less to `combined.log`
    //
    new winston.transports.File({
      filename: 'error.log',
      level: 'error'
    }),

  ]

});

if (process.env.NODE_ENV !== 'production') {

  logger.add(new winston.transports.Console({

    format: winston.format.simple(),

  }));

}

let io = require("socket.io")(server);

let time;

io.sockets.on('connection', function (socket) {

  console.log(updateTime() + socket.id + " has connected. ");

  socket.on('disconnect', function () {
    console.log(updateTime() + socket.id + " has disconnected. ");
  });

  socket.on('logData', (data) => {
    console.log(updateTime() + JSON.stringify(data));
  });

  socket.on('calculateIv', (data) => {

    const params = JSON.stringify({
      "Voltage": data[0],
      "Current": data[1],
      "Work_function": data[2]
    });

    const options = {

      scriptPath: "",
      args: [params]

    }

    PythonShell.run("ivCalc.py", options, (err, res) => {

      let result;

      if (err) {

        console.log(updateTimeError() + socket.id + " " + err);
        let errorMsg = updateTimeError() + err;
        logger.log('error', errorMsg);
        socket.emit('logServerSideError', err);

      } else if (res) {

        for (let i = 0; i < res.length; i++) {

          if (res[i][0] == "{") {
            result = res[i];
          } else {

            console.log(updateTimePy() + socket.id + " " + res[i]);

          }

        }

        socket.emit('calculatedData', result);

      }
    })
  })

})

//Console recursive input 

let init = true;
askInputInConsole();

// MAIN LOOP

function askInputInConsole() {

  if (init == true) {

    readline.question(updateTime() + "Awaiting input... type q to stop server. \n", data => {

      mainLoopInput(data);
      init = false;
      askInputInConsole();

    })

  } else {

    readline.question("", data => {

      mainLoopInput(data);

      askInputInConsole();

    })

  }

}

// Below are functions used by main loop 

function disconnectAllSockets() {

  Object.keys(io.sockets.sockets).forEach(function (s) {

    let socketId = io.sockets.sockets[s].id;
    io.sockets.sockets[s].disconnect(true);
    console.log(updateTime() + "Successfully disconnected following sockets: " + socketId);

  });

}


function updateTime() {

  let date_ob = new Date();
  let hours = date_ob.getHours();
  let minutes = date_ob.getMinutes();
  let seconds = date_ob.getSeconds();
  time = "\x1b[36m[" + hours + ":" + minutes + ":" + seconds + " INFO]:\x1b[0m ";

  return time;

}

function updateTimeError() {

  let date_ob = new Date();
  let hours = date_ob.getHours();
  let minutes = date_ob.getMinutes();
  let seconds = date_ob.getSeconds();
  time = "\x1b[31m[" + hours + ":" + minutes + ":" + seconds + " INFO]:\x1b[0m ";

  return time;

}

function updateTimePy() {

  let date_ob = new Date();
  let hours = date_ob.getHours();
  let minutes = date_ob.getMinutes();
  let seconds = date_ob.getSeconds();
  time = "\x1b[32m[" + hours + ":" + minutes + ":" + seconds + " PY]:\x1b[0m ";

  return time;

}

function mainLoopInput(data) {

  switch (data) {

    case "q":
      process.exit(1);
    case "stop":
      process.exit(1);
    case "exit":
      process.exit(1);
    case "clients":
      console.log(updateTime() + "Connected clients: " + io.sockets.clients());
      break;
    case "kickAll":
      disconnectAllSockets();
      break; //might not work

    default:
      console.log(updateTime() + "Unknown command: " + data);

  }

}