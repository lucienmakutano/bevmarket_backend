# BevMarket Backend - Copilot Instructions

## Architecture Overview

Rails 7.1 API-only backend for a **multi-tenant POS system** for wholesale beverage distribution. Each `Establishment` (distributor) is isolated—resources are scoped by `establishment_id`.

### Core Domain Model
```
Establishment (tenant root)
├── SalePoint (warehouse | truck) → has_one Warehouse/Truck
│   └── Employees → belongs_to User
├── Items → StockItems (inventory prices/quantities)
├── Clients (customers with credit)
├── Sales → SaleItems (linked to StockItems)
└── Expenses
```

### Multi-Tenancy Pattern
All tenant-scoped queries filter by `current_user.current_establishment_id`:
```ruby
@clients = Client.where(establishment_id: current_user.current_establishment_id)
```

## API Conventions

### Route Structure
All endpoints under `/api/v1/` namespace. Auth routes at root (`/login`, `/logout`, `/signup`).

### Response Format
Always use this consistent structure:
```ruby
# Success
render json: { status: "success", data: { resource: @resource } }, status: :ok

# Failure
render json: { status: "fail", error: { message: "Error description" } }, status: :unprocessable_entity
```

**Optional error fields** (include when helpful for debugging):
```ruby
# Validation errors - include model errors
render json: { status: "fail", error: { message: "Couldn't create item", errors: @item.errors } }, status: :unprocessable_entity

# Business logic errors - include context object
render json: { status: "fail", error: { message: "Not enough items in stock", stock_item: stock_item } }, status: :unprocessable_entity
```

### Controller Pattern
```ruby
class Api::V1::ResourcesController < ApplicationController
  before_action :find_resource, only: [:show, :update, :destroy]

  private

  def find_resource
    @resource = Resource.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { status: "fail", error: { message: "Resource not found" } }, status: :not_found
  end

  def resource_params
    params.require(:resource).permit(:allowed_field)
  end
end
```

### Eager Loading
Prevent N+1 queries with `includes`:
```ruby
Sale.includes(:client, :user, sale_items: :stock_item).where(...)
```

### JSON Serialization
Use `as_json(include: ...)` for nested associations (primary pattern) or `JSONAPI::Serializer` for users:
```ruby
@sale.as_json(include: { client: {}, sale_items: { include: { stock_item: { include: :item } } } })
```

## Authentication

- **Devise + JWT** via `devise-jwt` gem
- Token returned in response body after login/signup, not headers
- Custom controllers: `Users::SessionsController`, `Users::RegistrationsController`
- `RackSessionsFix` concern required for API-mode Devise compatibility
- All endpoints require `authenticate_user!` except auth routes

## Role-Based Access

Employees have `role` ("admin" | "employee") affecting data visibility:
```ruby
@current_employee = Employee.find_by(user_id: current_user.id)
if @current_employee["role"] == "admin"
  # See all establishment data
elsif @current_employee["role"] == "employee"  
  # Filtered to their sale_point_id
end
```

## Key Business Logic

### Creating Sales (`SalesController#create`)
1. Validate stock availability before sale
2. Update client credit
3. Create Sale → SaleItems
4. Record StockMovement (type: "sale")
5. Deduct from StockItem quantities

### Creating Items (`ItemsController#create`)
- Creates Item + StockItem + StockMovement (type: "purchase") in one action

### Establishment Setup (`EstablishmentsController#create`)
Uses transaction to create: Establishment → SalePoint (warehouse) → Warehouse → Employee (admin) → Update User

## Development Commands

```bash
bundle install              # Install dependencies
rails db:create db:migrate  # Setup database
rails db:seed               # Seed data
rails s                     # Start server (default: port 3000)
rails c                     # Rails console
```

## Environment Variables

### Production (required)
```bash
BEVMARKET_DATABASE_DB_NAME    # PostgreSQL database name
BEVMARKET_DATABASE_USERNAME   # Database user
BEVMARKET_DATABASE_PASSWORD   # Database password
BEVMARKET_DATABASE_PORT       # Database port (default: 5432)
BEVMARKET_DATABASE_URL        # Full connection URL (alternative)
RAILS_MAX_THREADS             # Connection pool size (default: 5)
```

### Credentials (via `rails credentials:edit`)
- `devise_jwt_secret_key` - Required for JWT token signing/verification

## Frontend Integration

### Authentication Flow
1. Client POSTs to `/login` with `{ user: { email, password } }`
2. Server returns `{ status: { data: { user, token } } }` in response body
3. Client stores token and includes in subsequent requests

### Request Headers
```
Authorization: Bearer <jwt_token>
Content-Type: application/json
```

### Token Handling
- Token is returned in response body (not `Authorization` header)
- Decode with: `Rails.application.credentials.devise_jwt_secret_key!`
- JTI (JWT ID) stored in users table for revocation

### CORS Origins
Configured in `config/initializers/cors.rb` for localhost dev ports and Azure Static Web Apps.

## Deployment

Docker image pushed to Azure Container Registry:
```bash
./deploy.sh  # Update version tag in script first
```

## Testing Conventions

### Test Structure (aspirational)
- Place tests in `test/` directory following Rails conventions
- Controller tests in `test/controllers/api/v1/`
- Model tests in `test/models/`

### Key Test Scenarios
- **Sales**: Validate stock deduction, client credit updates, StockMovement creation
- **Multi-tenancy**: Ensure users only access their establishment's data
- **Authentication**: Test JWT token generation and validation
- **Stock movements**: Test both `movement_type` values ("sale", "purchase")

### Running Tests
```bash
rails test                    # Run all tests
rails test test/models        # Run model tests only
rails test test/controllers   # Run controller tests only
```

## Data Patterns

### Stock Movements
Two movement types track inventory changes:
- `"purchase"` - Adding stock (via ItemsController#create or StockItemsController#update)
- `"sale"` - Reducing stock (via SalesController#create)

### Date Filtering
Endpoints supporting date ranges expect ISO8601 format:
- `params[:date]` - Single day
- `params[:from]`, `params[:to]` - Date range

### Unique Constraints
- `clients.phone_number` - Must be unique per establishment
