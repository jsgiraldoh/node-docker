const ronin = require('ronin-server')
const mocks = require('ronin-mocks')
const database = require('ronin-database')

database.connect(process.env.CONNECTIONSTRING)
const server = ronin.server({ port: process.env.SERVER_PORT })

server.use('/foo', (req, res) => {
   return res.json({ "foo": "bar" })
})
server.use('/', mocks.server(server.Router(), false, false))
server.start()
