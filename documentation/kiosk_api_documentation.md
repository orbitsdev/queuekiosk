# Kiosk API Documentation

This document provides comprehensive documentation for the Kiosk API endpoints used in the queuing system. These endpoints allow kiosk applications to validate branches, retrieve branch information, list available services, and create queue tickets.

## Base URL

All API endpoints are prefixed with `/api/kiosk`.

## Authentication

Currently, these endpoints do not require authentication as they are designed for public kiosk use.

## Response Format

All API responses follow a consistent format:

```json
{
  "success": true|false,
  "message": "Success or error message",
  "data": { ... } // Response data or null on error
}
```

## API Endpoints

### 1. Check Branch

Validates a branch code and returns branch details if valid.

**Endpoint:** `POST /api/kiosk/check-branch`

**Parameters:**

| Parameter | Type   | Required | Description     |
|-----------|--------|----------|-----------------|
| code      | string | Yes      | Branch code     |

**Example Request:**
```json
{
  "code": "BR001"
}
```

**Success Response (200 OK):**
```json
{
  "success": true,
  "message": "Branch found",
  "data": {
    "id": 1,
    "name": "Main Branch",
    "code": "BR001",
    "address": "123 Main Street",
    "created_at": "2025-06-17T06:10:00.000000Z",
    "updated_at": "2025-06-17T06:10:00.000000Z",
    "settings": {
      "ticket_prefix": "QUE",
      "print_logo": true
    }
  }
}
```

**Error Response (404 Not Found):**
```json
{
  "success": false,
  "message": "Branch not found",
  "data": null
}
```

**Error Response (422 Validation Error):**
```json
{
  "success": false,
  "message": "Validation error",
  "data": {
    "code": ["The code field is required."]
  }
}
```

### 2. Get Branch Details

Retrieves detailed information about a branch by its code.

**Endpoint:** `GET /api/kiosk/branch/{code}`

**Parameters:**

| Parameter | Type   | Required | Description     |
|-----------|--------|----------|-----------------|
| code      | string | Yes      | Branch code (in URL path) |

**Example Request:**
```
GET /api/kiosk/branch/BR001
```

**Success Response (200 OK):**
```json
{
  "success": true,
  "message": "Branch retrieved",
  "data": {
    "id": 1,
    "name": "Main Branch",
    "code": "BR001",
    "address": "123 Main Street",
    "created_at": "2025-06-17T06:10:00.000000Z",
    "updated_at": "2025-06-17T06:10:00.000000Z",
    "settings": {
      "ticket_prefix": "QUE",
      "print_logo": true
    }
  }
}
```

**Error Response (404 Not Found):**
```json
{
  "success": false,
  "message": "Branch not found",
  "data": null
}
```

### 3. Get Services for Branch

Lists all services available for a specific branch.

**Endpoint:** `GET /api/kiosk/services/{branchCode}`

**Parameters:**

| Parameter  | Type   | Required | Description     |
|------------|--------|----------|-----------------|
| branchCode | string | Yes      | Branch code (in URL path) |

**Example Request:**
```
GET /api/kiosk/services/BR001
```

**Success Response (200 OK):**
```json
{
  "success": true,
  "message": "Services retrieved",
  "data": [
    {
      "id": 1,
      "branch_id": 1,
      "name": "Customer Service",
      "code": "CS",
      "description": "General customer service inquiries",
      "last_ticket_number": 0,
      "created_at": "2025-06-17T06:17:57.000000Z",
      "updated_at": "2025-06-17T06:17:57.000000Z",
      "branch": {
        "id": 1,
        "name": "Main Branch",
        "code": "BR001",
        "address": "123 Main Street",
        "created_at": "2025-06-17T06:10:00.000000Z",
        "updated_at": "2025-06-17T06:10:00.000000Z",
        "settings": {
          "ticket_prefix": "QUE",
          "print_logo": true
        }
      },
      "waiting_count": 3
    },
    {
      "id": 2,
      "branch_id": 1,
      "name": "Technical Support",
      "code": "TS",
      "description": "Technical issues and support",
      "last_ticket_number": 0,
      "created_at": "2025-06-17T06:17:57.000000Z",
      "updated_at": "2025-06-17T06:17:57.000000Z",
      "branch": {
        "id": 1,
        "name": "Main Branch",
        "code": "BR001",
        "address": "123 Main Street",
        "created_at": "2025-06-17T06:10:00.000000Z",
        "updated_at": "2025-06-17T06:10:00.000000Z",
        "settings": {
          "ticket_prefix": "QUE",
          "print_logo": true
        }
      },
      "waiting_count": 1
    }
  ]
}
```

**Error Response (404 Not Found):**
```json
{
  "success": false,
  "message": "Branch not found",
  "data": null
}
```

### 4. Create Queue Ticket

Creates a new queue ticket for a specific branch and service.

**Endpoint:** `POST /api/kiosk/queue`

**Parameters:**

| Parameter   | Type    | Required | Description     |
|-------------|---------|----------|-----------------|
| branch_code | string  | Yes      | Branch code     |
| service_id  | integer | Yes      | Service ID      |

**Example Request:**
```json
{
  "branch_code": "BR001",
  "service_id": 1
}
```

**Success Response (200 OK):**
```json
{
  "success": true,
  "message": "Queue ticket created successfully",
  "data": {
    "id": 1,
    "branch_id": 1,
    "service_id": 1,
    "counter_id": null,
    "user_id": null,
    "number": 1,
    "ticket_number": "QUE1",
    "status": "waiting",
    "called_at": null,
    "serving_at": null,
    "served_at": null,
    "skipped_at": null,
    "hold_started_at": null,
    "cancelled_at": null,
    "hold_reason": null,
    "created_at": "2025-06-20T14:43:00.000000Z",
    "updated_at": "2025-06-20T14:43:00.000000Z",
    "formatted_date": "Jun 20, 2025",
    "formatted_time": "02:43 PM",
    "formatted_datetime": "Jun 20, 2025 02:43 PM",
    "service": {
      "id": 1,
      "branch_id": 1,
      "name": "Customer Service",
      "code": "CS",
      "description": "General customer service inquiries",
      "last_ticket_number": 0,
      "created_at": "2025-06-17T06:17:57.000000Z",
      "updated_at": "2025-06-17T06:17:57.000000Z",
      "branch": {
        "id": 1,
        "name": "Main Branch",
        "code": "BR001",
        "address": "123 Main Street",
        "created_at": "2025-06-17T06:10:00.000000Z",
        "updated_at": "2025-06-17T06:10:00.000000Z",
        "settings": {
          "ticket_prefix": "QUE",
          "print_logo": true
        }
      },
      "waiting_count": 4
    },
    "branch": {
      "id": 1,
      "name": "Main Branch",
      "code": "BR001",
      "address": "123 Main Street",
      "created_at": "2025-06-17T06:10:00.000000Z",
      "updated_at": "2025-06-17T06:10:00.000000Z",
      "settings": {
        "ticket_prefix": "QUE",
        "print_logo": true
      }
    },
    "counter": null
  }
}
```

**Error Response (404 Not Found - Branch):**
```json
{
  "success": false,
  "message": "Branch not found",
  "data": null
}
```

**Error Response (404 Not Found - Service):**
```json
{
  "success": false,
  "message": "Service not found or not active for this branch",
  "data": null
}
```

**Error Response (422 Validation Error):**
```json
{
  "success": false,
  "message": "Validation error",
  "data": {
    "branch_code": ["The branch code field is required."],
    "service_id": ["The service id field is required."]
  }
}
```

## Implementation Notes

1. **Queue Numbering Logic**:
   - Each branch has its own queue numbering sequence
   - Queue numbers reset daily (based on created_at date)
   - The next number is calculated as: (branch_setting.queue_number_base + today's_queue_count)
   - Ticket numbers are formatted with a prefix: (branch_setting.ticket_prefix + number)

2. **Date and Time Formatting**:
   - Queue responses include human-readable date and time formats for easier display and printing:
     - `formatted_date`: Date in "Mon DD, YYYY" format (e.g., "Jun 20, 2025")
     - `formatted_time`: Time in 12-hour format with AM/PM (e.g., "02:43 PM")
     - `formatted_datetime`: Combined date and time (e.g., "Jun 20, 2025 02:43 PM")
   - Original ISO timestamp (`created_at`) is still preserved

3. **Boolean Values**:
   - All boolean values in responses are properly cast to true/false instead of 0/1

4. **Relationships**:
   - Queue responses include related branch, service, and counter (if assigned)
   - Service responses include related branch
   - All relationships use their respective resource classes for consistent formatting

## Error Handling

All endpoints return appropriate HTTP status codes:
- 200: Success
- 404: Resource not found
- 422: Validation error

## Recommended Implementation

For kiosk developers, we recommend the following implementation flow:

1. Start by validating the branch code using the check-branch endpoint
2. Once validated, retrieve services for the branch
3. Allow the user to select a service
4. Create a queue ticket and display/print the ticket information
