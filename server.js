// Server for final showcase for BACRMT @ Falmouth Uni.
// Recieves the slider data from each client and averages each slider value,
// then forwards these averages to SuperCollider.

//Node Packages to include
const express = require('express');
const socket = require('socket.io');
const osc = require('osc');

//Start server on local IP port 3000, share public folder
const app = express();
const server = app.listen(3000);
let io = socket(server);
app.use(express.static('public'));

var udpPort = new osc.UDPPort({
    // This is the port we're listening on.
    localAddress: "127.0.0.1",
    localPort: 57121,

    // This is where sclang is listening for OSC messages.
    remoteAddress: "127.0.0.1",
    remotePort: 57120,
    metadata: true
});
// Open the socket.
udpPort.open();

//Litle message to myself to let me know server is running in Terminal
console.log("Congratulations Arthur, the server is running.");

//Variables
let total = 0;
let array1 = [0];
let array2 = [0];
let array3 = [0];
let array1sum = 0;
let array2sum = 0;
let array3sum = 0;
let slider1average = 0;
let slider2average = 0;
let slider3average = 0;

//when a new client connects through WebSocket
io.sockets.on('connect', newConnection);

function newConnection(socket) {

  function indexNumberFunc(array, value) {
    return array.push(value);
  };

  let value1 = 0;
  let value2 = 0;
  let value3 = 0;
  let value1parsed = 0;
  let value2parsed = 0;
  let value3parsed = 0;
  let indexNum = indexNumberFunc(array1, value1)-1;

  total = io.engine.clientsCount;
  console.log('new connection: ' + socket.id);
  console.log('number connected: ' + total);
  socket.emit('youID', socket.id);
  console.log('indexnum: ' + indexNum);
  // console.log(array1);

  //when new data is received from slider1, call slider1 function
  socket.on('slider1/'+socket.id, slider1);
  function slider1(data) {
    value1 = data;
    value1parsed = parseInt(value1, 10);
    array1.splice(indexNum, 1, value1parsed);
  };

  //when new data is received from slider2, call slider2 function
  socket.on('slider2/'+socket.id, slider2);
  function slider2(data) {
    value2 = data;
    value2parsed = parseInt(value2, 10);
    array2.splice(indexNum, 1, value2parsed);
  };

  //when new data is received from slider1, call slider1 function
  socket.on('slider3/'+socket.id, slider3);
  function slider3(data) {
    value3 = data;
    value3parsed = parseInt(value3, 10);
    array3.splice(indexNum, 1, value3parsed);
  };

  //when this client disconnects, call deadConnection function
  socket.on('disconnect', deadConnection);
  function deadConnection() {
      array1.splice(indexNum, 1, 0);
      array2.splice(indexNum, 1, 0);
      array3.splice(indexNum, 1, 0);
      // let deleteThisIndex = array1.indexOf(-1);
      // if (deleteThisIndex === indexNum) {
      //   array1.splice(indexNum, 1);
      // };
      // if (deleteThisIndex < indexNum) {
      //   indexNum = indexNum - 1;
      // };
      total = io.engine.clientsCount;
      console.log('dead connection ' + socket.id);
      console.log('dead indexNum: ' + indexNum);
      console.log('disconnect array1: '+ array1);
      console.log('disconnect array2: '+ array2);
      console.log('disconnect array3: '+ array3);
      console.log('total connected ' + total);
    };
};

setInterval(function recur() {
  function sum(acc, val) {
      return acc + val;
    };

    array1sum = array1.reduce(sum);
    array2sum = array2.reduce(sum);
    array3sum = array3.reduce(sum);

    if (total === 0) {
      slider1average = 0;
      slider2average = 0;
      slider3average = 0;

    } else {
      slider1average = array1sum/total;
      slider2average = array2sum/total;
      slider3average = array3sum/total;
    };

  // console.log(slider1average, slider2average, slider3average);

  var msg = {
        address: "/oscjs",
        args: [
            {
                type: "f",
                value: slider1average

            },
            {
              type: "f",
              value: slider2average
            },
            {
              type: "f",
              value: slider3average
            }
        ]
    };

    // console.log("Sending message", msg.address, msg.args, "to", udpPort.options.remoteAddress + ":" + udpPort.options.remotePort);
    udpPort.send(msg);
}, 100);
