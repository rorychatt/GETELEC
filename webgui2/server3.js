const express = require('express');
const https = require('https');
const path = require('path');
const fs = require('fs');

const app = express();

app.use('/', (req, res, next) => {

    res.sendFile(__dirname + '/index.html');

});

const sslServer = https.createServer({
    key: fs.readFileSync(path.join(__dirname, 'certificate', 'key.pem')),
    cert: fs.readFileSync(path.join(__dirname, 'certificate', 'crt.pem'))
})

sslServer.listen(3212, () => console.log("SSL running on port 3212"));