const ronin = require('ronin-server')
const mocks = require('ronin-mocks')

const server = ronin.server()

server.use( '/foo', (req, res) => {
   return res.json({ "foo": "bar" })
})

server.use('/', mocks.server(server.Router(), false, true))
server.start()
