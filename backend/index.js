const express = require('express');
const bodyParser = require('body-parser');
const cors = require('cors');
const { Pool } = require('pg');
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const multer = require('multer');
const path = require('path');
const {diskStorage} = require("multer");
const nodemailer = require('nodemailer');
const crypto = require('crypto');
const {post} = require("axios");
const {GoogleGenerativeAI} = require("@google/generative-ai");
const cookieParser = require("cookie-parser");
const axios = require("axios");
require("dotenv").config();

const app = express();
const port = process.env.PORT || 3000;

axios.defaults.withCredentials = true;

const SECRET_KEY = process.env.JWT_SECRET;

const SCRAPER_API_KEY = '54279510997a8417ada10850a002753b';

// PostgreSQL connection
// const pool = new Pool({
//     user: 'postgres',
//     host: 'localhost',
//     database: 'postgres',  
//     password: 'postgres',
//     port: 5432,
// });

// URI-подключение с sslmode=require
const pool = new Pool({
  connectionString: 'postgresql://neondb_owner:npg_7LPMXUkv1OJl@ep-autumn-dawn-a28q5n30-pooler.eu-central-1.aws.neon.tech/neondb?sslmode=require',
  ssl: {
    rejectUnauthorized: false
  }
});

app.use(bodyParser.json());
app.use(cookieParser());

const allowedOrigins = ['https://educational-portal-two.vercel.app'];

app.use(cors({
  origin: function(origin, callback) {
    if (!origin || allowedOrigins.includes(origin)) {
      callback(null, true);
    } else {
      callback(new Error('Not allowed by CORS'));
    }
  },
  credentials: true
}));

app.options('*', cors());

app.listen(port, '0.0.0.0', () => {
    console.log(`Server is running on port ${port}`);
});

app.use('/uploads', express.static(path.join(__dirname, 'uploads')));

const storage = diskStorage({
    destination: (req, file, cb) => {
        cb(null, 'uploads/'); // Папка для сохранения файлов
    },
    filename: (req, file, cb) => {
        cb(null, Date.now() + path.extname(file.originalname)); // Уникальное имя файла с расширением
    }
});
const upload = multer({ storage });

// Настройки почтового сервиса (замени на свои)
const transporter = nodemailer.createTransport({
    service: 'Gmail',
    auth: {
        user: 'islomkhon1243@gmail.com', // Замени на свой email
        pass: process.env.EMAIL_PASS  // Или используй OAuth2
    }
});

const apiKey = "AIzaSyAaPCjYO4xVOcQx8_PgvH1gX7bSRWPfr3c";
// const baseURL = "https://api.aimlapi.com/v1";

const genAI = new GoogleGenerativeAI(apiKey); // Instantiate the AI client

const model = genAI.getGenerativeModel({
    model: "gemini-2.0-flash", // Specify the AI model
});

// Refactored function to get AI responses
const getAIResponse = async (systemPrompt, userPrompt) => {
    try {
        // Combine system and user prompts into a single prompt format
        const prompt = `${systemPrompt}\nUser: ${userPrompt}\n`;

        // Generate content using the model
        const result = await model.generateContent(prompt);

        // Return the response text from the generated result
        return result.response.text();
    } catch (error) {
        console.error("Error generating AI response:", error);
        return "Error generating response.";
    }
};

app.post("/api/ai", async (req, res) => {
    const { systemPrompt, userPrompt } = req.body;

    if (!userPrompt) {
        return res.status(400).json({ error: "userPrompt is required" });
    }

    // Generate the response using the refactored method
    const response = await getAIResponse(systemPrompt || "You are an assistant", userPrompt);
    res.json({ response });
});

app.post("/api/translate", async (req, res) => {
    const { text, targetLang } = req.body;

    try {
        const response = await post("https://api-free.deepl.com/v2/translate", null, {
            params: {
                auth_key: "028c7744-3021-4a87-aa7d-2b679235db92:fx",
                text: text,
                target_lang: targetLang.toUpperCase(),
            },
        });

        res.json({ translatedText: response.data.translations[0].text });
    } catch (error) {
        console.error("Ошибка перевода:", error);
        res.status(500).json({ error: "Ошибка перевода" });
    }
});

// Отправка кода на email
app.post('/api/send-verification', async (req, res) => {
    const { email } = req.body;

    try {
        // Проверяем, существует ли уже пользователь с таким email
        const userResult = await pool.query('SELECT * FROM applicants WHERE email = $1', [email]);

        if (userResult.rows.length > 0) {
            return res.status(400).json({ message: 'User with this email already exists' });
        }

        const code = crypto.randomInt(100000, 999999).toString();
        const expiresAt = new Date(Date.now() + 60 * 60 * 1000); // Код действует 1 час

        // 🔍 Логируем, что будет вставлено
        console.log(`[EMAIL_VERIFICATION] Inserting:`, {
            email,
            code,
            expiresAt: expiresAt.toISOString()
        });
      
        const { rows } = await pool.query(
            'SELECT id FROM email_verifications WHERE email = $1',
            [email]
        );
        
        if (rows.length > 0) {
            // Запись уже существует — делаем UPDATE
            await pool.query(
                'UPDATE email_verifications SET code = $1, expires_at = $2 WHERE email = $3',
                [code, expiresAt, email]
            );
        } else {
            // Записи нет — делаем INSERT
            await pool.query(
                'INSERT INTO email_verifications (email, code, expires_at) VALUES ($1, $2, $3)',
                [email, code, expiresAt]
            );
        }

        // Отправляем код на email
        await transporter.sendMail({
            from: 'islomkhon1243@gmail.com',
            to: email,
            subject: 'Email Подтверждение',
            text: `Вы регистрируетесь на портале Futurum. Ваш код подтверждения: ${code}`
        });

        res.json({ message: 'Verification code sent!' });
    } catch (error) {
        console.error('Error sending email:', error);
        res.status(500).json({ message: 'Failed to send email' });
    }
});

app.post('/api/verify-code', async (req, res) => {
    const { email, code, name, password } = req.body;

    try {
        const result = await pool.query(
            'SELECT * FROM email_verifications WHERE email = $1 AND code = $2 AND expires_at > NOW()',
            [email, code]
        );

        if (result.rows.length === 0) {
            return res.status(400).json({ message: 'Invalid or expired code' });
        }

        const hashedPassword = await bcrypt.hash(password, 10);
        await pool.query('INSERT INTO applicants (name, email, password) VALUES ($1, $2, $3)', [name, email, hashedPassword]);

        await pool.query('DELETE FROM email_verifications WHERE email = $1', [email]); // Удаляем использованный код

        res.json({ message: 'Registration successful!' });
    } catch (error) {
        console.error('Verification error:', error);
        res.status(500).json({ message: 'Verification failed' });
    }
});

// Get all resources
app.get('/api/resources', async (req, res) => {
    const result = await pool.query('SELECT * FROM resources');
    res.json(result.rows);
});

// Add a new applicant
app.post('/api/applicants', async (req, res) => {
    const { name, email } = req.body;
    const result = await pool.query('INSERT INTO applicants (name, email) VALUES ($1, $2) RETURNING *', [name, email]);
    res.json(result.rows[0]);
});

// User registration
app.post('/api/register', async (req, res) => {
    const { name, email, password } = req.body;
    const hashedPassword = await bcrypt.hash(password, 10);
    const result = await pool.query('INSERT INTO applicants (name, email, password) VALUES ($1, $2, $3) RETURNING *', [name, email, hashedPassword]);
    res.json(result.rows[0]);
});

// User login
app.post('/api/login', async (req, res) => {
    const { email, password } = req.body;
    try {
        const result = await pool.query("SELECT * FROM applicants WHERE email = $1", [email]);
        if (result.rows.length > 0) {
            const user = result.rows[0];
            const isPasswordValid = await bcrypt.compare(password, user.password);
            if (isPasswordValid) {
                const token = jwt.sign({ id: user.id }, SECRET_KEY, { expiresIn: "1h" });

                res.cookie("token", token, {
                    httpOnly: true,  // Доступно только серверу
                    secure: true,    // Только HTTPS (уберите для локальной разработки)
                    sameSite: "None", // Защита от CSRF
                    path: "/",
                    maxAge: 60 * 60 * 1000 // 1 час
                });

                return res.json({ userId: user.id });
            }
        }
        res.status(401).json({ message: "Invalid credentials" });
    } catch (error) {
        console.error(error);
        res.status(500).json({ message: "Server error" });
    }
});

app.post("/api/logout", (req, res) => {
    res.clearCookie("token", {
      httpOnly: true,
      secure: true,
      sameSite: "None",
      path: "/",
    });
    res.json({ message: "Logged out successfully" });
});

app.get("/api/profile", (req, res) => {
    const token = req.cookies.token;
    console.log("TOKEN RECEIVED:", token);
    if (!token) return res.status(401).json({ message: "Unauthorized" });

    try {
        const decoded = jwt.verify(token, SECRET_KEY);
        res.json({ userId: decoded.id });
    } catch (error) {
        res.status(401).json({ message: "Invalid token" });
    }
});

app.post('/api/feedback', async (req, res) => {
    const { resource_id, user_id, comment } = req.body;
    const result = await pool.query('INSERT INTO feedback (resource_id, user_id, comment) VALUES ($1, $2, $3) RETURNING *', [resource_id, user_id, comment]);
    res.json(result.rows[0]);
});

// Get all universities
app.get('/api/universities', async (req, res) => {
    const result = await pool.query('SELECT * FROM universities');
    res.json(result.rows);
});

// Get user data
app.get('/api/user/:id', async (req, res) => {
    const { id } = req.params;
    const userId = parseInt(id, 10);

    if (isNaN(userId)) {
        return res.status(400).json({ error: 'Invalid user ID' });
    }

    try {
        const result = await pool.query('SELECT * FROM applicants WHERE id = $1', [userId]);
        if (result.rows.length === 0) {
            return res.status(404).json({ error: 'User not found' });
        }
        res.json(result.rows[0]);
    } catch (error) {
        console.error('Database error:', error);
        res.status(500).json({ error: 'Internal server error' });
    }
});

// Get university by ID
app.get('/api/universities/:id', async (req, res) => {
    const { id } = req.params;
    const result = await pool.query('SELECT * FROM universities WHERE id = $1', [id]);
    res.json(result.rows[0]);
});

app.post('/api/applications/:universityId', upload.single('file'), async (req, res) => {
    const { name, email, personalStatement, selectedFilePath, userId } = req.body;
    const universityId = req.params.universityId;

    const filePath = req.file ? req.file.path : selectedFilePath;

    if (selectedFilePath === undefined) {
        return res.status(400).send({ message: 'Selected file path is undefined.' });
    }

    if (!filePath) {
        return res.status(400).send({ message: 'No file uploaded or selected.' });
    }

    // Проверяем количество заявок от данного userId
    const result = await pool.query(
        'SELECT COUNT(*) FROM applications WHERE user_id = $1',
        [userId]
    );

    try {
        // Проверяем количество заявок от данного userId
        const result = await pool.query(
            'SELECT COUNT(*) FROM applications WHERE user_id = $1',
            [userId]
        );

        const applicationCount = parseInt(result.rows[0].count, 10);

        if (applicationCount >= 4) {
            return res.status(403).send({ message: 'Application limit reached (4 applications max).' });
        }

        // Проверяем, существует ли уже заявка на этот университет от данного userId
        const duplicateCheck = await pool.query(
            'SELECT COUNT(*) FROM applications WHERE user_id = $1 AND university_id = $2',
            [userId, universityId]
        );

        if (parseInt(duplicateCheck.rows[0].count, 10) > 0) {
            return res.status(409).send({ message: 'Duplicate application for this university detected.' });
        }

        // Если заявок меньше 4 и нет дубликатов, добавляем новую
        await pool.query(
            'INSERT INTO applications (university_id, name, email, personal_statement, file_path, user_id, created_at) VALUES ($1, $2, $3, $4, $5, $6, NOW())',
            [universityId, name, email, personalStatement, filePath, userId]
        );
        res.status(201).send({ message: 'Application submitted successfully!' });
    } catch (error) {
        console.error("Error saving application:", error);
        res.status(500).send({ message: 'Failed to submit application.' });
    }
});

app.get('/api/applications/checkUser/:universityId', async (req, res) => {
    const { userId } = req.query;
    const universityId = req.params.universityId;

    try {
        // Проверяем количество заявок от данного userId
        const result = await pool.query(
            'SELECT COUNT(*) FROM applications WHERE user_id = $1',
            [userId]
        );

        const applicationCount = parseInt(result.rows[0].count, 10);

        if (applicationCount >= 4) {
            return res.status(403).send({ message: 'Application limit reached (4 applications max).' });
        }

        // Проверяем, существует ли уже заявка на этот университет от данного userId
        const duplicateCheck = await pool.query(
            'SELECT COUNT(*) FROM applications WHERE user_id = $1 AND university_id = $2',
            [userId, universityId]
        );

        if (parseInt(duplicateCheck.rows[0].count, 10) > 0) {
            return res.status(409).send({ message: 'Duplicate application for this university detected.' });
        }

        res.status(201).send({ message: 'User is available!' });
    } catch (error) {
        console.error("Error checking user:", error);
        res.status(500).send({ message: 'Failed to check user.' });
    }
});

app.get('/api/applications/:userId', async (req, res) => {
    const userId = req.params.userId;

    if (!userId) {
        return res.status(400).json({ message: "userId обязателен" });
    }

    try {
        const result = await pool.query(
            `SELECT u.name AS university_name, a.status 
             FROM applications a 
             JOIN universities u ON a.university_id = u.id
             WHERE a.user_id = $1`,
            [userId]
        );

        res.json(result.rows);
    } catch (error) {
        console.error("Ошибка загрузки заявок:", error);
        res.status(500).json({ message: "Не удалось загрузить заявки" });
    }
});


// Новый маршрут: Получить все статьи
app.get('/api/articles', async (req, res) => {
    try {
        const result = await pool.query('SELECT * FROM articles ORDER BY created_at DESC');
        res.json(result.rows);
    } catch (error) {
        console.error('Error fetching articles:', error);
        res.status(500).json({ message: 'Failed to fetch articles' });
    }
});

// Новый маршрут: Получить статью по ID
app.get('/api/articles/:id', async (req, res) => {
    const { id } = req.params;
    try {
        const result = await pool.query('SELECT * FROM articles WHERE id = $1', [id]);
        if (result.rows.length === 0) {
            return res.status(404).json({ message: 'Article not found' });
        }
        res.json(result.rows[0]);
    } catch (error) {
        console.error('Error fetching article:', error);
        res.status(500).json({ message: 'Failed to fetch article' });
    }
});

// Новый маршрут: Добавить новую статью
app.post('/api/articles', async (req, res) => {
    const { title, category, description, content } = req.body;

    try {
        // Добавляем новую статью
        const newArticle = await pool.query(
            'INSERT INTO articles (title, category, description, content) VALUES ($1, $2, $3, $4) RETURNING *',
            [title, category, description, content]
        );

        // Получаем ID статей, отсортированных по дате (старые сверху)
        const articles = await pool.query(
            'SELECT id FROM articles ORDER BY created_at ASC'
        );

        // Если статей больше 20 — удаляем самые старые
        if (articles.rows.length > 20) {
            const idsToDelete = articles.rows
                .slice(0, articles.rows.length - 20)
                .map(row => row.id);

            await pool.query(
                'DELETE FROM articles WHERE id = ANY($1::int[])',
                [idsToDelete]
            );
        }

        res.status(201).json(newArticle.rows[0]);
    } catch (error) {
        console.error('Error adding article:', error);
        res.status(500).json({ message: 'Failed to add article' });
    }
});


// для сохранения документа в таблице документы пользователя
app.post('/api/user-documents/:userId', upload.single('file'), async (req, res) => {
    const { fileName } = req.body;
    const userId = req.params.userId;
    const filePath = req.file ? req.file.path : null; // Путь к загруженному файлу

    if (!filePath) {
        return res.status(400).send({ message: 'No file uploaded.' });
    }

    try {
        // Сохраняем данные в базе данных
        await pool.query(
            'INSERT INTO user_documents (user_id, file_name, file_path, uploaded_at) VALUES ($1, $2, $3, NOW())',
            [userId, fileName, filePath]
        );
        res.status(201).send({ message: 'Document uploaded successfully!' });
    } catch (error) {
        console.error("Error saving document:", error);
        res.status(500).send({ message: 'Failed to upload document.' });
    }
});

app.get('/api/user-documents/:userId', async (req, res) => {
    const userId = parseInt(req.params.userId); // Добавь parseInt
    if (!userId) {
        return res.status(400).json({ message: "Invalid user ID" });
    }

    try {
        const result = await pool.query(
            'SELECT id, file_name, file_path FROM user_documents WHERE user_id = $1',
            [userId]
        );
        res.json(result.rows);
    } catch (error) {
        console.error("Ошибка получения документов:", error);
        res.status(500).json({ message: "Ошибка сервера" });
    }
});

app.post('/api/admin/login', async (req, res) => {
    try {
        const { email, password } = req.body;

        const result = await pool.query('SELECT * FROM admins WHERE email = $1', [email]);

        if (result.rows.length === 0) {
            return res.status(401).json({ message: 'Invalid credentials' });
        }

        const user = result.rows[0];

        // Проверяем пароль (обрати внимание на правильное название поля)
        const isPasswordValid = await bcrypt.compare(password, user.password_hash);
        if (!isPasswordValid) {
            return res.status(401).json({ message: 'Invalid credentials' });
        }

        const token = jwt.sign({ id: user.id }, 'your_secret_key', { expiresIn: '1h' });

        const userStatus = 'admin';

        return res.json({ token, userStatus });

    } catch (error) {
        console.error('Ошибка авторизации:', error);
        res.status(500).json({ message: 'Server error' });
    }
});

app.post('/api/results', async (req, res) => {
    const { userId, type, description, professions, universities } = req.body;
    try {
        await pool.query(`
      INSERT INTO riasec_results (user_id, type, description, professions, universities, created_at)
      VALUES ($1, $2, $3, $4, $5, NOW())
    `, [userId, type, description, JSON.stringify(professions), JSON.stringify(universities)]);
        res.status(200).json({ message: 'Результаты сохранены' });
    } catch (error) {
        console.error(error);
        res.status(500).json({ error: 'Ошибка сохранения результатов' });
    }
});

app.get('/api/results/:userId', async (req, res) => {
    const { userId } = req.params;
    try {
        const result = await pool.query(`
      SELECT * FROM riasec_results
      WHERE user_id = $1
      ORDER BY created_at DESC
      LIMIT 1
    `, [userId]);
        res.json(result.rows[0]);
    } catch (error) {
        res.status(500).json({ error: 'Ошибка получения результатов' });
    }
});

// app.get('/api/egov/callback', async (req, res) => {
//     const { code } = req.query;
//
//     const tokenResponse = await axios.post('https://idp.egov.kz/oauth2/token', null, {
//         params: {
//             grant_type: 'authorization_code',
//             code,
//             redirect_uri: 'http://localhost:3000/api/egov/callback',
//             client_id: 'ВАШ_CLIENT_ID',
//             client_secret: 'ВАШ_CLIENT_SECRET'
//         }
//     });
//
//     const { access_token } = tokenResponse.data;
//
//     const userInfoResponse = await axios.get('https://idp.egov.kz/oauth2/userinfo', {
//         headers: {
//             Authorization: `Bearer ${access_token}`
//         }
//     });
//
//     const user = userInfoResponse.data;
//
//     // По user.sub можно найти или создать пользователя
//     const userId = await findOrCreateUser(user);
//
//     // Возвращаем HTML с скриптом, чтобы сохранить userId и перейти в SPA
//     res.send(`
//     <script>
//       localStorage.setItem('userId', '${userId}');
//       window.location.href = '/';
//     </script>
//   `);
// });

// async function createAdmin(email, password) {
//     const passwordHash = await bcrypt.hash(password, 10); // Хэшируем пароль
//     const query = 'INSERT INTO admins (email, password_hash) VALUES ($1, $2)';
//
//     try {
//         await pool.query(query, [email, passwordHash]);
//         console.log('Администратор добавлен');
//     } catch (err) {
//         console.error('Ошибка при добавлении администратора:', err);
//     }
// }
//
// createAdmin('admin@gmail.com', 'admin');
