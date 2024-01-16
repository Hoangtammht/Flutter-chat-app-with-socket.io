const mongoose = require('mongoose');

const messageSchema = new mongoose.Schema({
  sender: Number,
  received: Number,
  message: String,
  path: String,
  timestamp: { type: Date, default: Date.now }
});

const Message = mongoose.model('Message', messageSchema);

module.exports = { Message };
