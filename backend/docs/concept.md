# Fix-N-Go Concept Doc

## Concept
Fix-N-Go is a full-stack doorstep repair platform. It has a customer app and a technician app, similar to Rapido/Captain flow.

### Customer app
- Register/login
- Browse services such as screen, battery, charging port
- Select brand/model
- Book order
- Track technician
- View orders history

### Technician app
- Login as technician
- See nearby service requests
- Accept/decline orders
- Update job status: assigned, in_progress, completed
- Track earnings/location

### Backend behaviors
- Auth with email/password
- Roles: customer, technician
- Orders lifecycle: pending -> assigned -> in_progress -> completed or cancelled
- Location and distance keywords for matching nearby requests
- Token based auth (JWT)

## Frontend Behavior & UX changes (helpful for team)
- Customer login -> redirect to customer screen flow
- Technician login -> redirect to technician screen flow
- Tech availability behavior similar to Uber/Ola driver; accept job workflow similar to Rapido Captain
- Use API for flows instead of local state
- Retain modes; on token failure redirect to login screen
- Loading and error states must be handled
