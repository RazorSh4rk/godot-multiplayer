const WebSocket = require('ws')

const port = 9001
const wss = new WebSocket.Server({ port: port })

let gameState = []

console.log(`running on ws://127.0.0.1:${port}`)

wss.on('connection', ws => {

  ws.on('message', message => {
    let data = JSON.parse(message)
    
    if(gameState.filter(el => el.id == data.id).length > 0) {
    	gameState = gameState.map(el => {
    		if(el.id == data.id) return data
    		else return el
    	})
    } else {
    	console.log(`new player, id: ${data.id}`)
	  	gameState.push(data)
    }

    ws.send(JSON.stringify(gameState))
  })

  ws.on('close', (code, reason) => {
  	gameState = gameState.filter(el => el.id != parseInt(reason))
  	console.log(`player ${reason} disconnected`)
  })
 
})