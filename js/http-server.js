const http = require("node:http");

const server = http.createServer((req, res) => {
  res.writeHead(200, {'Content-Type': 'application/json'});
  /*
    code...
  */
});

const PORT = process.env.PORT || 3000;
const HOST = 'localhost';

server.listen(PORT, HOST, () => { // Server ko listen karne ke liye kahna
    console.log(`Server is running at http://${HOST}:${PORT}/`);
});
