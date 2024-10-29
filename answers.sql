const express = require('express');
const mysql = require('mysql2/promise');
const dotenv = require('dotenv');

dotenv.config();

const app = express();
const port = 3000;

// Database connection configuration
const pool = mysql.createPool({
    host: process.env.DB_HOST,
    user: process.env.DB_USERNAME,
    password: process.env.DB_PASSWORD,
    database: process.env.DB_NAME
});

// Error handling middleware
app.use((err, req, res, next) => {
    console.error(err.stack);
    res.status(500).send('Internal Server Error');
});

// 1. Retrieve all patients
app.get('/patients', async (req, res) => {
    try {
        const [rows] = await pool.query('SELECT patient_id, first_name, last_name, date_of_birth FROM patients');
        res.json(rows);
    } catch (error) {
        console.error(error);
        res.status(500).send('Error retrieving patients');
    }
});

// 2. Retrieve all providers
app.get('/providers', async (req, res) => {
    try {
        const [rows] = await pool.query('SELECT first_name, last_name, provider_specialty FROM providers');
        res.json(rows);
    } catch (error) {
        console.error(error);
        res.status(500).send('Error retrieving providers');
    }
});

// 3. Filter patients by First Name
app.get('/patients/:firstName', async (req, res) => {
    const firstName = req.params.firstName;
    try {
        const [rows] = await pool.query('SELECT * FROM patients WHERE first_name = ?', [firstName]);
        res.json(rows);
    } catch (error) {
        console.error(error);
        res.status(500).send('Error retrieving patients');
    }
});

// 4. Retrieve all providers by their specialty
app.get('/providers/:specialty', async (req, res) => {
    const specialty = req.params.specialty;
    try {
        const [rows] = await pool.query('SELECT * FROM providers WHERE provider_specialty = ?', [specialty]);
        res.json(rows);
    } catch (error) {
        console.error(error);
        res.status(500).send('Error retrieving providers');
    }
});

app.listen(port, () => {
    console.log(`Server listening on port ${port}`);
});
