# 📐 Eventify Studio - ER & UML Architectural Diagrams

This document contains the complete set of **Entity-Relationship (ER)** and **Unified Modeling Language (UML)** engineering diagrams for **Eventify Studio**.

---

## 1. Entity-Relationship (ER) Diagram

The ER Diagram illustrates the relational data model, cardinalities, primary keys (PK), and foreign keys (FK) for the Eventify Studio platform.

```mermaid
erDiagram
    USER ||--o{ BOOKING : places
    USER ||--o{ VENUE_RESERVATION : submits
    USER ||--o{ TURNKEY_INQUIRY : requests

    ARTIST ||--o{ EVENT : headlines
    VENUE ||--o{ EVENT : hosts
    VENUE ||--o{ VENUE_RESERVATION : reserves

    EVENT ||--|{ SEAT : contains
    EVENT ||--o{ BOOKING : generates

    BOOKING ||--|{ BOOKING_ITEM : includes
    SEAT ||--o| BOOKING_ITEM : reserved_in

    PROMO_CODE ||--o{ BOOKING : discounts

    USER {
        string user_id PK
        string full_name
        string email
        string phone
        string role
        datetime created_at
    }

    ARTIST {
        string artist_id PK
        string name
        string genre
        string bio
        string image_url
        string top_tracks
    }

    VENUE {
        string venue_id PK
        string name
        string address
        float latitude
        float longitude
        int daily_rental_rate
        int max_capacity
        string included_facilities
    }

    EVENT {
        string event_id PK
        string artist_id FK
        string venue_id FK
        string title
        string category
        date event_date
        time show_time
        int base_price
        string environment_type
        int total_capacity
        int available_seats
    }

    SEAT {
        string seat_id PK
        string event_id FK
        string seat_number
        string row_label
        int column_number
        string tier_name
        int tier_price
        string status
    }

    PROMO_CODE {
        string promo_id PK
        string code
        string discount_type
        int discount_value
        int min_cart_value
        int max_discount_cap
        boolean is_active
    }

    BOOKING {
        string booking_id PK
        string booking_ref
        string user_id FK
        string event_id FK
        string promo_id FK
        int subtotal_amount
        int discount_amount
        int final_total_paid
        string payment_method
        string payment_status
        string qr_verification_hash
        datetime booked_at
    }

    BOOKING_ITEM {
        string item_id PK
        string booking_id FK
        string seat_id FK
        int unit_price
    }

    VENUE_RESERVATION {
        string reservation_id PK
        string reservation_ref
        string user_id FK
        string venue_id FK
        string event_type
        date target_date
        string time_slot
        int expected_guests
        int agreed_daily_price
        string requested_addons
        string status
        datetime created_at
    }

    TURNKEY_INQUIRY {
        string inquiry_id PK
        string inquiry_ref
        string user_id FK
        string package_name
        string event_category
        date target_date
        string budget_range
        int expected_guests
        string services_scope
        string status
        datetime created_at
    }
```

---

## 2. UML Class Diagram

The UML Class Diagram shows the object-oriented system structure, attributes (with visibility and types), methods/operations, and relationships (inheritance, association, composition, aggregation).

```mermaid
classDiagram
    direction TB

    class User {
        -String userId
        -String fullName
        -String email
        -String phone
        -String role
        +getBookingHistory() List~Booking~
        +cancelBooking(String bookingId) Boolean
    }

    class Attendee {
        -List~Ticket~ ticketWallet
        +downloadTicketPDF(String bookingId) void
        +addToGoogleCalendar(String bookingId) void
    }

    class Organizer {
        -String organizationName
        +filterTelemetryByEvent(String eventId) Report
        +exportAttendeeRosterCSV() File
        +simulateTestBooking() Booking
    }

    class Event {
        -String eventId
        -String title
        -Date date
        -String time
        -Venue venue
        -Artist artist
        -List~Seat~ seatMatrix
        -int totalSeats
        -int availableSeats
        +getAvailableSeatCount() int
        +lockSeats(List~String~ seatIds) Boolean
        +releaseSeats(List~String~ seatIds) void
    }

    class Venue {
        -String venueId
        -String name
        -String address
        -int dailyRate
        -int maxCapacity
        -List~String~ includedFacilities
        +checkAvailability(Date date) Boolean
        +calculateQuote(String timeSlot, List~String~ addons) int
    }

    class Artist {
        -String artistId
        -String name
        -String genre
        -String bio
        -List~String~ topTracks
        +getArtistProfile() Object
    }

    class Seat {
        -String seatId
        -String seatNumber
        -String rowLabel
        -int colNumber
        -SeatTier tier
        -SeatStatus status
        +select() void
        +deselect() void
        +markOccupied() void
        +release() void
    }

    class Booking {
        -String bookingId
        -String bookingRef
        -User attendee
        -Event event
        -List~Seat~ selectedSeats
        -int subtotal
        -int discount
        -int totalPaid
        -String paymentMethod
        -PaymentStatus status
        -Date bookedAt
        +applyPromoCode(String code) Boolean
        +calculateTotal() int
        +confirmPayment() Boolean
    }

    class PromoCode {
        -String code
        -String discountType
        -int discountValue
        -int minCartValue
        +validate(int subtotal) Boolean
        +computeDiscount(int subtotal) int
    }

    class TicketPDFService {
        +generateTicketPDF(Booking booking) Blob
        +embedQRCode(String verificationUrl) Canvas
    }

    class TelemetryService {
        -List~Booking~ datastore
        +calculateGrossRevenue(String eventFilter) int
        +calculateOccupancy(String eventFilter) float
        +generateCSV(List~Booking~ records) String
    }

    User <|-- Attendee
    User <|-- Organizer
    Event "1" *-- "50" Seat : contains
    Event "1" o-- "1" Venue : located at
    Event "1" o-- "1" Artist : features
    Attendee "1" --> "0..*" Booking : places
    Booking "1" o-- "1..8" Seat : reserves
    Booking "0..*" o-- "0..1" PromoCode : uses
    Booking ..> TicketPDFService : uses
    Organizer ..> TelemetryService : uses
```

---

## 3. UML Use Case Diagram

The Use Case Diagram defines the interactions between the primary actors (**Attendee**, **Event Organizer**, **Venue Coordinator**, and **System Engine**) and the system boundary.

```mermaid
graph LR
    subgraph "Actors"
        A[👤 Event Attendee]
        O[👔 Event Organizer]
        V[🏰 Venue Coordinator]
        S[⚙️ System Engine]
    end

    subgraph "Eventify Studio System Boundary"
        UC1(Browse Concerts & Venues)
        UC2(Filter by Category / Price / Location)
        UC3(Select Seats on 50-Seat Grid)
        UC4(Apply Promo Discount Code)
        UC5(Checkout & Confirm Booking)
        UC6(Download E-Ticket with QR Code)
        UC7(Add Show to Google Calendar)
        UC8(Cancel Booking & Release Seats)
        UC9(Request Custom Venue Reservation)
        UC10(Request Turnkey Management Quote)
        UC11(View Real-Time Organizer Telemetry)
        UC12(Filter Attendee Roster by Show)
        UC13(Export Attendee Roster as CSV)
        UC14(Enforce Anti-Scalping Limit max 8)
        UC15(Prevent Double-Booking via State Lock)
        UC16(Sanitize Inputs against XSS)
    end

    A --> UC1
    A --> UC2
    A --> UC3
    A --> UC4
    A --> UC5
    A --> UC6
    A --> UC7
    A --> UC8
    A --> UC9
    A --> UC10

    O --> UC11
    O --> UC12
    O --> UC13

    V --> UC9

    UC3 -.->|<<include>>| UC14
    UC5 -.->|<<include>>| UC15
    UC5 -.->|<<include>>| UC16
    UC5 -.->|<<include>>| UC6
    UC8 -.->|<<extend>>| UC15
```

---

## 4. UML Sequence Diagram (Seat Booking & QR Ticket Generation Flow)

This sequence diagram illustrates the step-by-step runtime interaction across UI, State Engine, Promo Engine, and PDF Generator during a booking transaction.

```mermaid
sequenceDiagram
    autonumber
    actor User as 👤 Attendee
    participant UI as 🖥️ Events UI
    participant Modal as 🪟 SeatModal
    participant Promo as 🏷️ PromoEngine
    participant Storage as 💾 LocalStorage / State
    participant PDF as 📄 TicketPDFService (jsPDF)
    participant QR as 📱 QRCode.js
    participant Telemetry as 📊 OrganizerDashboard

    User->>UI: Clicks "Select Seats" (e.g. AP Dhillon)
    UI->>Storage: getShowBookedSeats("AP Dhillon")
    Storage-->>UI: Returns locked seats [A3, A8, B4, ...]
    UI->>Modal: Renders 50-seat grid with locked seats in gray
    Modal-->>User: Displays arena layout

    User->>Modal: Selects seats A1, A2 (Count <= 8)
    Modal->>Modal: Validates Anti-Scalping Limit
    User->>Modal: Clicks "Proceed to Attendee Details"

    User->>Modal: Enters Promo Code "PUNE2026"
    Modal->>Promo: applyPromoCode("PUNE2026", subtotal)
    Promo-->>Modal: Returns ₹200 discount + new total
    Modal-->>User: Updates itemized summary

    User->>Modal: Submits name, email, phone & payment method
    Modal->>Modal: Validates inputs + runs escapeHtml()

    Modal->>Storage: addShowBookedSeats("AP Dhillon", [A1, A2])
    Modal->>Storage: unshift(bookingData) to 'eventify_bookings'

    Modal->>QR: generateQRCode("https://eventifystudio.com/verify?id=#EVT-9821")
    QR-->>PDF: Returns PNG Data URL
    Modal->>PDF: generateTicketPDFCustom(bookingData, qrDataUrl)
    PDF-->>User: Triggers automatic PDF download with QR Code

    Modal->>Modal: Sets up 1-Click Google Calendar link
    Modal-->>User: Displays Step 3 Success Screen

    Modal->>Telemetry: loadOrganizerDashboard() & updateCardCapacities()
    Telemetry->>Storage: Reads updated bookings
    Telemetry-->>UI: Updates live attendee roster & decrements card capacity
```

---

## 5. UML State Machine Diagram (Seat & Ticket Lifecycle)

Demonstrates all lifecycle transitions of a seat from initial creation to reservation, locking, confirmation, and release.

```mermaid
stateDiagram-v2
    [*] --> Available : Show Published (50 Seats)

    Available --> Selected : User clicks seat (Count <= 8)
    Selected --> Available : User deselects seat

    Selected --> HeldInCheckout : Clicks "Proceed to Checkout"
    HeldInCheckout --> Selected : Clicks "Back to Seats"
    HeldInCheckout --> Available : Modal closed / Aborted

    HeldInCheckout --> BookedOccupied : Submits Booking Form & Confirms
    BookedOccupied --> BookedOccupied : Reopening modal renders gray & disabled

    BookedOccupied --> ReleasedAvailable : User clicks "Cancel Pass" in Wallet
    ReleasedAvailable --> Available : Seats restored to pool & counter increments

    BookedOccupied --> ArchivedCompleted : Event Showtime Ends
    ArchivedCompleted --> [*]
```

---

## 6. Relational Database Schema (SQL DDL for Production)

If your professor asks: *"How would this schema be implemented in a relational database like PostgreSQL or MySQL?"*, present this DDL:

```sql
-- 1. Users Table
CREATE TABLE users (
    user_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(150) UNIQUE NOT NULL,
    phone VARCHAR(15) NOT NULL,
    role VARCHAR(20) DEFAULT 'attendee' CHECK (role IN ('attendee', 'organizer', 'admin')),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- 2. Venues Table
CREATE TABLE venues (
    venue_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(150) NOT NULL,
    location VARCHAR(200) NOT NULL,
    latitude DECIMAL(9,6),
    longitude DECIMAL(9,6),
    daily_rate INTEGER NOT NULL,
    max_capacity INTEGER NOT NULL,
    facilities_included TEXT[] NOT NULL
);

-- 3. Artists Table
CREATE TABLE artists (
    artist_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name VARCHAR(100) NOT NULL,
    genre VARCHAR(50) NOT NULL,
    bio TEXT,
    image_url TEXT
);

-- 4. Events Table
CREATE TABLE events (
    event_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    artist_id UUID REFERENCES artists(artist_id) ON DELETE SET NULL,
    venue_id UUID REFERENCES venues(venue_id) ON DELETE RESTRICT,
    title VARCHAR(200) NOT NULL,
    event_date DATE NOT NULL,
    show_time TIME NOT NULL,
    base_price INTEGER NOT NULL,
    total_seats INTEGER DEFAULT 50,
    available_seats INTEGER DEFAULT 50,
    status VARCHAR(20) DEFAULT 'scheduled' CHECK (status IN ('scheduled', 'live', 'completed', 'cancelled'))
);

-- 5. Seats Table
CREATE TABLE seats (
    seat_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    event_id UUID REFERENCES events(event_id) ON DELETE CASCADE,
    seat_number VARCHAR(10) NOT NULL,
    row_label CHAR(1) NOT NULL,
    col_number INTEGER NOT NULL,
    tier VARCHAR(20) DEFAULT 'Silver',
    price INTEGER NOT NULL,
    status VARCHAR(20) DEFAULT 'available' CHECK (status IN ('available', 'held', 'occupied')),
    UNIQUE (event_id, seat_number)
);

-- 6. Promo Codes Table
CREATE TABLE promo_codes (
    promo_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    code VARCHAR(30) UNIQUE NOT NULL,
    discount_type VARCHAR(15) CHECK (discount_type IN ('flat', 'percentage')),
    discount_value INTEGER NOT NULL,
    min_cart_value INTEGER DEFAULT 0,
    max_discount_cap INTEGER,
    is_active BOOLEAN DEFAULT TRUE
);

-- 7. Bookings Table
CREATE TABLE bookings (
    booking_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    booking_ref VARCHAR(30) UNIQUE NOT NULL,
    user_id UUID REFERENCES users(user_id) ON DELETE RESTRICT,
    event_id UUID REFERENCES events(event_id) ON DELETE RESTRICT,
    promo_id UUID REFERENCES promo_codes(promo_id) ON DELETE SET NULL,
    subtotal INTEGER NOT NULL,
    discount INTEGER DEFAULT 0,
    total_paid INTEGER NOT NULL,
    payment_method VARCHAR(50) NOT NULL,
    payment_status VARCHAR(20) DEFAULT 'confirmed' CHECK (payment_status IN ('pending', 'confirmed', 'refunded')),
    qr_hash VARCHAR(256),
    booked_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- 8. Booking Items Table
CREATE TABLE booking_items (
    item_id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    booking_id UUID REFERENCES bookings(booking_id) ON DELETE CASCADE,
    seat_id UUID REFERENCES seats(seat_id) ON DELETE RESTRICT,
    unit_price INTEGER NOT NULL,
    UNIQUE (booking_id, seat_id)
);

-- Index for concurrent seat-locking performance
CREATE INDEX idx_seats_event_status ON seats(event_id, status);
CREATE INDEX idx_bookings_user ON bookings(user_id);
```
