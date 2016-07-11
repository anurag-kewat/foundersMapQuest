//Lets require/import the HTTP module
var http = require('http');
var path = require('path');
var express = require('express');
var app = express();

app.use(express.static(path.join(__dirname, 'public')));
app.use('/', express.static(__dirname + '/'));

app.listen(4000);
console.log('Listening.. on port 4000');