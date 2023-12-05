const functions = require("firebase-functions");
const express = require("express");
const {Storage} = require("@google-cloud/storage");
const storage = new Storage();
const app = express();

app.use(express.json());

const bucketName = "ghhdata";
const fileName = "data.json";
const bucket = storage.bucket(bucketName);
const file = bucket.file(fileName);

// Helper function to read users from data.json in GCS
async function getUsers() {
  const data = await file.download();
  return JSON.parse(data.toString()).users;
}

// Helper function to write users to data.json in GCS
async function saveUsers(users) {
  const data = Buffer.from(JSON.stringify({users}, null, 2));
  await file.save(data);
}

// Get all users
app.get("/users", async (req, res) => {
  try {
    const users = await getUsers();
    res.json(users);
  } catch (error) {
    res.status(500).send(error.message);
  }
});

// Get user by username
app.get("/users/:username", async (req, res) => {
  try {
    const users = await getUsers();
    const user = users.find((u) => u.username === req.params.username);
    if (!user) {
      return res.status(404).send("User not found");
    }
    res.json(user);
  } catch (error) {
    res.status(500).send(error.message);
  }
});

// Create a new user
app.post("/users", async (req, res) => {
  try {
    const users = await getUsers();
    users.push(req.body);
    await saveUsers(users);
    res.status(201).send("User created");
  } catch (error) {
    res.status(500).send(error.message);
  }
});

// Update user details by username
app.put("/users/:username", async (req, res) => {
  try {
    const users = await getUsers();
    const index = users.findIndex((u) => u.username === req.params.username);
    if (index === -1) {
      return res.status(404).send("User not found");
    }
    users[index] = {...users[index], ...req.body};
    await saveUsers(users);
    res.send("User updated");
  } catch (error) {
    res.status(500).send(error.message);
  }
});

// Delete a user by username
app.delete("/users/:username", async (req, res) => {
  try {
    let users = await getUsers();
    users = users.filter((u) => u.username !== req.params.username);
    await saveUsers(users);
    res.send("User deleted");
  } catch (error) {
    res.status(500).send(error.message);
  }
});

// A simple get route to verify your function is working
app.get("/", (req, res) => {
  res.send("Hello from Firebase Cloud Functions!");
});

// Export your Express server as a Cloud Function called 'api'
exports.api = functions.https.onRequest(app);
