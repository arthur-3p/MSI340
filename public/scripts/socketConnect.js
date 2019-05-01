var socket;

socket = io.connect('http://192.168.1.209:3000');

function receivedID(data) {
  thisID = data;
  console.log(thisID);
};
