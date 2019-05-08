var socket;
//ip address for web socket communication with server.
socket = io.connect('127.0.0.1:3000');

function receivedID(data) {
  thisID = data;
  console.log(thisID);
};
