//Lets require/import the HTTP module
var http = require('http');
var path = require('path');
var express = require('express');

var exec = require('child_process').exec;
var cmd = 'coffee --watch --join js/bundle.js --compile coffee/*.coffee';
exec(cmd)

var app = express();

app.use(express.static(path.join(__dirname, 'public')));
app.use('/', express.static(__dirname + '/'));

app.listen(4000);
console.log('Listening.. on port 4000');