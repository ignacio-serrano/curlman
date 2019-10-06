const http = require('http');
const Colors = require('./Colors.js');

function logRequest(req, incomingRequest) {
    var output = `${Colors.BlueFg}<Server> Received request: ${req.method} ${req.url}\n`;
    output += `\t== HEADERS ==\n`;
    for (var name in req.headers) {
        output += `\t${name}: ${req.headers[name]}\n`;
    }
    output += `\t== BODY ==\n\t`;
    if (incomingRequest.body.isEmpty) {
        output += '(EMPTY)';
    } else {
        output += incomingRequest.body.content;
    }
    output += Colors.Reset;
    console.log(output);
}

const testServer = http.createServer(function (req, res) {
    let incomingRequest = {
        body: {
            isEmpty: true,
            content: ''
        }
    }

    req.on('data', function(data) {
        incomingRequest.body.isEmpty = false;
        incomingRequest.body.content += data;
    });

    req.on('end', function() {
        logRequest(req, incomingRequest);
        res.writeHead(204);
        res.end();
        // var q = url.parse(req.url, true);
        // if (!receivedRequests[req.method] || receivedRequests[req.method][q.pathname] === undefined) {
        //     console.warn('WARNING: This is an unexpected request.');
        // } else {
        //     receivedRequests[req.method][q.pathname] = true;
        // }
        // if (req.method === 'POST' && req.url === '/api/identity-server/edison/protocol/openid-connect/token') {
        //     assertContentType(req, 'application/x-www-form-urlencoded');
        //     let requestParams = querystring.parse(body.content);
        //     if (Object.keys(requestParams).length === 0) {
        //         throw 'Missing request parameters';
        //     }
        //     if (requestParams['client_id'] !== 'edison') {
        //         throw `Expected parameter "client_id" with value "edison". Request parameters: ${JSON.stringify(requestParams, null, 3)}`;
        //     }
        //     if (requestParams['grant_type'] !== 'password') {
        //         throw `Expected parameter "grant_type" with value "password". Request parameters: ${JSON.stringify(requestParams, null, 3)}`;
        //     }
        //     if (requestParams['scope'] !== 'iks') {
        //         throw `Expected parameter "scope" with value "iks". Request parameters: ${JSON.stringify(requestParams, null, 3)}`;
        //     }
        //     if (requestParams['password'] !== '2b85c8f3ec1d68fed3f15d8a9cc6a74ebc9223b8be0a8867fd37701f8a55f11b') {
        //         throw `Expected parameter "password" with value "2b85c8f3ec1d68fed3f15d8a9cc6a74ebc9223b8be0a8867fd37701f8a55f11b". Request parameters: ${JSON.stringify(requestParams, null, 3)}`;
        //     }
        // } else if (req.method === 'POST' && req.url === '/v1/cards') {
        //     assertContentType(req, 'application/json');
        //     let jsonBody = JSON.parse(body.content);

        //     if (jsonBody.depotId !== 7752) {
        //         throw `Expected body.depotId to be 7752. Received ${jsonBody.depotId}.`;
        //     }
        // } else if (req.method === 'HEAD' && q.pathname === '/v2/push/EDISON/users/3042/destinations') {
        //     assertContentType(req, 'application/json');
        //     assertHeader(req, 'authorization', 'Bearer eyJhbGciOiJSUzI1NiIsInR5cCIgOiAiSldUIiwia2lkIiA6ICIifRtbRBtbREV2Q1ozT2VpOENNVWc2MGh5TDVVellJZFFGb0NmZlJoMTNZLXRXZTUySkEifQo.eyJqdGkiOiI4NmI1MzU3Zi01ZTQxLTQ5MmQtYTdkZS1mZTM4N2VjZWJhNzMiLCJleHAiOjE1NDU2NDM5MTAsIm5iZiI6MCwiaWF0IjoxNTQ1MDM5MTEwLCJpc3MiOiJodHRwczovL3B3ZGlnZDAyLnVrLmRiLmNvbTo4NDQzL2F1dGgvcmVhbG1zL2VkaXNvbiIsImF1ZCI6ImVkaXNvbiIsInN1YiI6IjMwNDQiLHR5cCI6IkJlYXJlciIsImF6cCI6ImVkaXNvbiIsImF1dGhfdGltZSI6MCwic2Vzc2lvbl9zdGF0ZSI6ImQ1ZDBiZmY2LTViYmQtNDZjYi1hYjM5LTY0Mzc3Njc1MWYzZCIsImFjciI6IjEiLCJjbGllbnRfc2Vzc2lvbiI6Ijk5ZGUxNGIzLWI2NTYtNGY2NC04YWJmLWYyNGNkN2JhOGM3YSIsImFsbG93ZWQtb3JpZ2lucyI6W10sInJlc291cmNlX2FjY2VzcyI6e30sInByaW5jaXBhbF9jbGFpbSI6InByZWZlcnJlZF91c2VybmFtZSIsImFtciI6ImlrcyIsImlrc3VpZCI6IjMwNDQiLCJyZWFsbSI6ZWRpc29uIiwicHJlZmVycmVkX3VzZXJuYW1lIjoiMzA0NCJ9.apsoidufmasodfaskldjfoasiduf0198fajsdofajsdfiq2983fpawo83lfj');
        //     assertHeader(req, 'x-masterlogsessionid', '792203');
        // } else if (req.method === 'PUT' && req.url === '/v1/cards/8c437ed6c9ba4684bc3d5c4cae0cd369/activate') {
        //     assertContentType(req, 'application/json');
        //     assertHeader(req, 'authorization', 'Bearer eyJhbGciOiJSUzI1NiIsInR5cCIgOiAiSldUIiwia2lkIiA6ICIifRtbRBtbREV2Q1ozT2VpOENNVWc2MGh5TDVVellJZFFGb0NmZlJoMTNZLXRXZTUySkEifQo.eyJqdGkiOiI4NmI1MzU3Zi01ZTQxLTQ5MmQtYTdkZS1mZTM4N2VjZWJhNzMiLCJleHAiOjE1NDU2NDM5MTAsIm5iZiI6MCwiaWF0IjoxNTQ1MDM5MTEwLCJpc3MiOiJodHRwczovL3B3ZGlnZDAyLnVrLmRiLmNvbTo4NDQzL2F1dGgvcmVhbG1zL2VkaXNvbiIsImF1ZCI6ImVkaXNvbiIsInN1YiI6IjMwNDQiLHR5cCI6IkJlYXJlciIsImF6cCI6ImVkaXNvbiIsImF1dGhfdGltZSI6MCwic2Vzc2lvbl9zdGF0ZSI6ImQ1ZDBiZmY2LTViYmQtNDZjYi1hYjM5LTY0Mzc3Njc1MWYzZCIsImFjciI6IjEiLCJjbGllbnRfc2Vzc2lvbiI6Ijk5ZGUxNGIzLWI2NTYtNGY2NC04YWJmLWYyNGNkN2JhOGM3YSIsImFsbG93ZWQtb3JpZ2lucyI6W10sInJlc291cmNlX2FjY2VzcyI6e30sInByaW5jaXBhbF9jbGFpbSI6InByZWZlcnJlZF91c2VybmFtZSIsImFtciI6ImlrcyIsImlrc3VpZCI6IjMwNDQiLCJyZWFsbSI6ZWRpc29uIiwicHJlZmVycmVkX3VzZXJuYW1lIjoiMzA0NCJ9.apsoidufmasodfaskldjfoasiduf0198fajsdofajsdfiq2983fpawo83lfj');
        //     assertHeader(req, 'x-masterlogsessionid', '792203');
        //     assertHeader(req, 'tan-version', 'v2');
        //     let jsonBody = JSON.parse(body.content);
        //     if (jsonBody.depotId !== 4452) {
        //         throw `Expected body.deptoId to be 4452. Received ${jsonBody.depotId}.`;
        //     }
        // } else if (req.method === 'POST' && req.url === '/v2/push/EDISON/tans/query') {
        //     assertContentType(req, 'application/json');
        //     let jsonBody = JSON.parse(body.content);
        //     //TODO: Here comes more fun.
        // } else if (req.method === 'GET' && req.url === '/v2/push/dev-utils/tanValue') {
        //     if (!q.query.tanId || q.query.tanId !== '5452') {
        //         throw `Expected query parameter "tanId" to be 5452. Received ${q.query.tanId}.`;
        //     }
        // } else if (req.method === 'POST' && req.url === '/v2/push/EDISON/tans/reply') {
        //     assertContentType(req, 'application/json');
        //     let jsonBody = JSON.parse(body.content);
        //     //TODO: Here comes more fun.
        // } else if (req.method === 'GET' && req.url === '/v2/push/EDISON/users/2042/tans/5452') {
        //     assertHeader(req, 'authorization', 'Bearer eyJhbGciOiJSUzI1NiIsInR5cCIgOiAiSldUIiwia2lkIiA6ICIifRtbRBtbREV2Q1ozT2VpOENNVWc2MGh5TDVVellJZFFGb0NmZlJoMTNZLXRXZTUySkEifQo.eyJqdGkiOiI4NmI1MzU3Zi01ZTQxLTQ5MmQtYTdkZS1mZTM4N2VjZWJhNzMiLCJleHAiOjE1NDU2NDM5MTAsIm5iZiI6MCwiaWF0IjoxNTQ1MDM5MTEwLCJpc3MiOiJodHRwczovL3B3ZGlnZDAyLnVrLmRiLmNvbTo4NDQzL2F1dGgvcmVhbG1zL2VkaXNvbiIsImF1ZCI6ImVkaXNvbiIsInN1YiI6IjMwNDQiLHR5cCI6IkJlYXJlciIsImF6cCI6ImVkaXNvbiIsImF1dGhfdGltZSI6MCwic2Vzc2lvbl9zdGF0ZSI6ImQ1ZDBiZmY2LTViYmQtNDZjYi1hYjM5LTY0Mzc3Njc1MWYzZCIsImFjciI6IjEiLCJjbGllbnRfc2Vzc2lvbiI6Ijk5ZGUxNGIzLWI2NTYtNGY2NC04YWJmLWYyNGNkN2JhOGM3YSIsImFsbG93ZWQtb3JpZ2lucyI6W10sInJlc291cmNlX2FjY2VzcyI6e30sInByaW5jaXBhbF9jbGFpbSI6InByZWZlcnJlZF91c2VybmFtZSIsImFtciI6ImlrcyIsImlrc3VpZCI6IjMwNDQiLCJyZWFsbSI6ZWRpc29uIiwicHJlZmVycmVkX3VzZXJuYW1lIjoiMzA0NCJ9.apsoidufmasodfaskldjfoasiduf0198fajsdofajsdfiq2983fpawo83lfj');
        //     assertHeader(req, 'x-masterlogsessionid', '792203');
        // }//???: One more???

        // fs.readFile('./statics/8080' + q.pathname + '/' + req.method + '.json', function(err, data) {
        //     if (err) {
        //         res.writeHead(404, {'Content-Type': 'text/html'});
        //         res.end('404 Not Found');
        //     } else {
        //         var responseSpec = JSON.parse(data);
        //         if (!responseSpec.status) {
        //             return defaultErrorResponse(res);
        //         }

        //         res.writeHead(responseSpec.status, responseSpec.headers);
        //         if (typeof responseSpec.body === 'object') {
        //             res.write(JSON.stringify(responseSpec.body));
        //         } else if (typeof responseSpec.body === 'string') {
        //             res.write(responseSpec.body);
        //         }
        //         return res.end();
        //     }
        // })
    })
});

// let receivedRequests = {
//     'POST': {
//         '/api/identity-server/edison/protocol/openid-connect/token': false,
//         '/v1/cards': false,
//         '/v2/push/EDISON/tans/query': false,
//         '/v2/push/EDISON/tans/reply': false,
//         '/o/oauth2/token': false
//     },
//     'GET': {
//         '/users/2042/customerAccounts': false,
//         '/v2/push/dev-utils/tanValue': false,
//         '/v2/push/EDISON/users/2042/tans/5452': false
//     },
//     'HEAD': {
//         '/v2/push/EDISON/users/2042/destinations': false
//     },
//     'PUT': {
//         '/v1/cards/8d437ed6c9ba4684bc3d5c4cae0cd369/activate': false
//     }
// };
testServer.on('close', () => {
    console.log('Server closing.');
    // for (var m in receivedRequests) {
    //     for (var r in receivedRequests[m]) {
    //         if (!receivedRequests[m][r]) {
    //             console.log(`Expected request ${m} ${r} not received.`);
    //         }
    //     }
    // }
});
testServer.listen(8080);
