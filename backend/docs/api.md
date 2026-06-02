# Fix-N-Go API Documentation

## Base URL
- Dev server: `http://localhost:5000/api`
- Android emulator: `http://10.0.2.2:5000/api`

## Auth Endpoints
- POST `/api/auth/register`
  - Body: `{ name, email, phone, password, role? }`
  - Response: `{ success, token, user }`

- POST `/api/auth/login`
  - Body: `{ email, password, role? }`
  - Response: `{ success, token, user }`

Responsible file:
- `backend/src/routes/authRoutes.js`
- `backend/src/controllers/authController.js`
Behavior: register/create JWT; login verify credentials and return JWT + user.

## Customer/General Endpoints
- GET `/api/services/issues`
  - Headers: `Authorization: Bearer <token>`
  - Response: `{ success, count, data: [issues] }`

- GET `/api/orders`
  - Headers: `Authorization: Bearer <token>`
  - Response: `{ success, count, data: [orders] }`

- POST `/api/orders`
  - Headers: `Authorization: Bearer <token>`
  - Body: `{ brand, model, issues: [], total, date }`
  - Response: `{ success, data: order }`

- GET `/api/orders/:id`
  - Headers: `Authorization: Bearer <token>`
  - Response: `{ success, data: order }`

- PATCH `/api/orders/:id/status`
  - Headers: `Authorization: Bearer <token>`
  - Body: `{ status }`

Responsible files:
- `backend/src/routes/serviceRoutes.js`
- `backend/src/controllers/serviceController.js`
- `backend/src/routes/orderRoutes.js`
- `backend/src/controllers/orderController.js`

## Technician Endpoints
- GET `/api/technician/orders/nearby`
  - Headers: `Authorization: Bearer <token>`
  - Response: `{ success, count, data: [pending orders] }`

- POST `/api/technician/orders/:id/accept`
  - Headers: `Authorization: Bearer <token>`
  - Response: `{ success, message, data: order }`

- PATCH `/api/technician/status`
  - Headers: `Authorization: Bearer <token>`
  - Body: `{ status }`

- PATCH `/api/technician/profile`
  - Headers: `Authorization: Bearer <token>`
  - Body: `{ name, phone, location }`
  - Response: `{ success, data: user }`

Responsible files:
- `backend/src/routes/technicianRoutes.js`
- `backend/src/controllers/technicianController.js`

## Data Models
- User: `backend/src/models/userModel.js` (customer/technician)
- Issue: `backend/src/models/issueModel.js` (service catalog)
- Order: `backend/src/models/orderModel.js` (customer order)

## Frontend Connection
- Use `lib/services/api_service.dart` to call API.
- After login, store token somewhere and set for requests.
- Replace in-memory state with API response mapping based on role.
