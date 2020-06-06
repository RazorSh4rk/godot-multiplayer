const WebSocket = require('ws')

const wss = new WebSocket.Server({ port: 9001 })

let gameState = []
 
wss.on('connection', ws => {

  ws.on('message', message => {
    let data = JSON.parse(message)
    
    if(gameState.filter(el => el.id == data.id).length > 0) {
    	gameState = gameState.map(el => {
    		if(el.id == data.id) return data
    		else return el
    	})
    } else gameState.push(data)

    ws.send(JSON.stringify(gameState))
  })
 
})