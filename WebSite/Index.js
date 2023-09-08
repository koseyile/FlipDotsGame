var http = require('http'),
    socketio = require('socket.io'),
    fs = require('fs'),
    osc = require('osc-min'),
    dgram = require('dgram'),
    remote_osc_ip;

const content = require('fs').readFileSync(__dirname + '/index.html', 'utf8');

const httpServer = require('http').createServer((req, res) => {
  // serve the index.html file
  res.setHeader('Content-Type', 'text/html');
  res.setHeader('Content-Length', Buffer.byteLength(content));
  res.end(content);
});

const io = require('socket.io')(httpServer);

var udp_server = dgram.createSocket('udp4', function(msg, rinfo) {

  var osc_message;
  try {
    osc_message = osc.fromBuffer(msg);
  } catch(err) {
    return console.log('Could not decode OSC message');
  }

  if(osc_message.address != '/socketio') {
    return console.log('Invalid OSC address');
  }

  remote_osc_ip = rinfo.address;
  console.log('udp4 remote_osc_ip:'+remote_osc_ip);

  io.emit('osc', {
    x: parseInt(osc_message.args[0].value) || 0
  });

});



/*
io.on('connection', socket => {
  console.log('connect');
});
*/

/*
io.on('connection', socket => {
  let counter = 0;
  setInterval(() => {
    socket.emit('hello', ++counter);
  }, 1000);
});
*/

io.on('connection', socket => {
  console.log('connect');
  
  socket.on('browser', function(data) {

    
    console.log('browser');

    if(! remote_osc_ip) {
      return;
    }

    console.log('remote_osc_ip:'+remote_osc_ip);

    var osc_msg = osc.toBuffer({
      oscType: 'message',
      address: '/socketio',
      args:[{
        type: 'integer',
        value: parseInt(data.x) || 0
      },
      {
        type: 'integer',
        value: parseInt(data.y) || 0
      }]
    });

    udp_server.send(osc_msg, 0, osc_msg.length, 9999, remote_osc_ip);
    console.log('Sent OSC message to %s:9999', remote_osc_ip);

  });




  
  socket.on('hey', data => {
    //console.log('hey', data);
  })

});



httpServer.listen(3000, () => {
  console.log('go to http://localhost:3000');
});

udp_server.bind(9998);
console.log('Starting UDP server on UDP port 9998');

