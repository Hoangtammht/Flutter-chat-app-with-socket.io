const express = require('express');
const router = express.Router();
const multer = require('multer');
const { Message } = require('./Model/MessageModel');

const storage = multer.diskStorage({
  destination: (req, file, cb) => {
    cb(null, "./uploads");
  },
  filename: (req, file, cb) => {
    cb(null, Date.now() + ".jpg");
  }
});

const upload = multer({
  storage: storage,
});

router.route("/addimage").post(
  upload.single("img"), (req, res) => {
    try {
      res.json({ path: req.file.filename });
    } catch (error) {
      return res.json({ error });
    }
  }
);

router.route("/addmessage").post((req, res) => {
  const { sourceId, targetId, message, path } = req.body;

  const newMessage = new Message({
    sender: sourceId,
    received: targetId,
    message: message,
    path: path,
  });

  newMessage.save()
    .then(savedMessage => {
      console.log('Message saved to MongoDB:', savedMessage);
      res.status(200).json({ message: 'Message saved successfully' });
    })
    .catch(error => {
      console.error('Error saving message:', error);
      res.status(500).json({ error: 'Error saving message' });
    });
});

module.exports = router;
