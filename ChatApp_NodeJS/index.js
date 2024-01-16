const express = require("express");
const http = require("http");
const app = express();
const port = process.env.PORT || 5000;
const server = http.createServer(app);
const { Server } = require("socket.io");
const io = new Server(server);
const mongoose = require('mongoose');
const { Message } = require('./Model/MessageModel');

app.use(express.json());

mongoose.connect('mongodb://localhost:27017/chat_app', {
  useNewUrlParser: true,
  useUnifiedTopology: true,
})
.then(() => console.log('Connected to MongoDB'))
.catch(err => console.error('Error connecting to MongoDB:', err));

const clients = {};
const routes = require('./routes');
app.use("/routes", routes);
app.use("/uploads", express.static("uploads"));

io.on('connection', (socket) => {
  console.log("connected");
  console.log(socket.id, "has joined");
  socket.on("signin", (id) => {
    console.log(id);
    clients[id] = socket;
    console.log(clients);
  });
  socket.on("message", async (msg) => {
    console.log(msg);
  
    // Lưu trữ dữ liệu vào MongoDB
    const newMessage = new Message({
      sender: msg.sourceId,
      received: msg.targetId,
      message: msg.message,
      path: msg.path
    });
  
    try {
      const savedMessage = await newMessage.save();
      console.log('Message saved to MongoDB:', savedMessage);
  
      // Gửi tin nhắn đến người nhận
      const targetId = msg.targetId;
      if (clients[targetId]) clients[targetId].emit("message", msg);
    } catch (error) {
      console.error('Error saving message to MongoDB:', error);
    }
  });

  socket.on("load_messages", async (data) => {
    const { sourceId, targetId } = data;
    try {
      const messages = await Message.find({
        $or: [
          { sender: sourceId, received: targetId },
          { sender: targetId, received: sourceId },
        ],
      });
      socket.emit("loaded_messages", messages);
    } catch (error) {
      console.error("Error loading messages:", error);
    }
  });
});

app.route("/check").get((req, res) => {
  return res.json("Your app is working fine");
});

server.listen(port, "0.0.0.0", () => {
  console.log("server started");
});
