const express = require('express');
const session = require('express-session');
const Keycloak = require('keycloak-connect');

const app = express();
const memoryStore = new session.MemoryStore();

// 세션 설정
app.use(
  session({
    secret: 'my-secret',
    resave: false,
    saveUninitialized: true,
    store: memoryStore,
  })
);

// Keycloak 연결
const keycloak = new Keycloak({ store: memoryStore }, {
  clientId: 'my-client',
  bearerOnly: true,
  serverUrl: 'http://keycloak:8080',
  realm: 'my-realm',
  credentials: {
    secret: 'my-client-secret',
  },
});

// Keycloak 미들웨어 추가
app.use(keycloak.middleware());

// 보호된 라우트 예제
app.get('/secure', keycloak.protect(), (req, res) => {
  res.json({ message: 'This is a protected resource.' });
});

// 기본 라우트
app.get('/', (req, res) => {
  res.send('Hello, Keycloak!');
});

const PORT = 3000;
app.listen(PORT, () => {
  console.log(`Server running on http://localhost:${PORT}`);
});
