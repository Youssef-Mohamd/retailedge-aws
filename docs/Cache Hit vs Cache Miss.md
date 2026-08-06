#  ElastiCache Redis — Cache Hit vs Cache Miss
(Task 4.4 — Bonus)

---

##  Why did we add ElastiCache alongside RDS?

ElastiCache (Redis) is added to **reduce database load and improve application performance**.

### Benefits of ElastiCache Redis

| Benefit | Explanation |
| :--- | :--- |
| **Reduced RDS Load** | Frequently accessed data is served from cache, reducing RDS queries by ~70% |
| **Faster Response** | Cache returns data in <1ms vs RDS in ~10-50ms |
| **Cost Savings** | Less load = smaller RDS instance = lower cost |
| **Scalability** | Cache handles repeated requests without scaling RDS |

### Why Redis specifically?

- Redis is an **in-memory** data store (super fast).
- Supports **Session Storage**, **Caching**, **Queues**, and **Real-time analytics**.
- Works well with **PHP/Laravel** applications.

**Analogy:** Like a waiter who remembers frequent orders — doesn't need to check with the kitchen every time.

---

## 4. Draw a simple diagram showing the Cache Hit and Cache Miss flow

                    ┌─────────────────────────────────────────────┐
                    │              Application (EC2)              │
                    │              Requests Data                  │
                    └──────────────────┬──────────────────────────┘
                                       │
                                       ▼
                    ┌─────────────────────────────────────────────┐
                    │              Check Cache                    │
                    │         (ElastiCache Redis)                 │
                    └──────────────────┬──────────────────────────┘
                                       │
                                       ▼
              ┌────────────────────────┼────────────────────────┐
              │                        │                        │
              ▼                        ▼                        ▼
    ┌─────────────────┐    ┌─────────────────┐    ┌─────────────────┐
    │   Redis Cache   │    │   Cache Hit?    │    │    RDS MySQL    │
    │  (ElastiCache)  │    │                 │    │                 │
    └─────────────────┘    └────────┬────────┘    └─────────────────┘
                                     │
                    ┌────────────────┼────────────────┐
                    │                │                │
                    ▼                ▼                ▼
           ┌─────────────┐  ┌─────────────┐  ┌─────────────┐
           │  ✅ YES     │  │  ❌ NO      │  │             │
           │  Cache Hit  │  │  Cache Miss │  │             │
           └──────┬──────┘  └──────┬──────┘  └──────┬──────┘
                  │                │                │
                  ▼                ▼                ▼
        ┌─────────────────┐  ┌─────────────────┐  ┌─────────────────┐
        │ Return cached   │  │  Fetch from RDS │  │  Store in cache │
        │ data to user    │  │                 │  │  (for next time)│
        └─────────────────┘  └────────┬────────┘  └────────┬────────┘
                                      │                    │
                                      └────────────────────┘
                                                   │
                                                   ▼
                                        ┌─────────────────┐
                                        │ Return data to  │
                                        │     user        │
                                        └─────────────────┘

##  Cache Hit vs Cache Miss — Comparison

| Aspect | Cache Hit | Cache Miss |
| :--- | :--- | :--- |
| **Definition** | Data found in cache | Data not found in cache |
| **Response Time** | ~1ms (very fast) | ~10-50ms (slower) |
| **RDS Impact** | No RDS query | RDS query performed |
| **User Experience** | Instant response | Slightly slower (first time only) |
| **Frequency** | Most requests (after initial load) | First request only |

---
## ✅ Cache Hit Flow (~1ms)

| Step | Action |
| :--- | :--- |
| 1 | Application requests data |
| 2 | Redis has the data → returns immediately |
| 3 | User gets fast response |
| 4 | No RDS query is performed |
---
## ❌ Cache Miss Flow (~50ms)

| Step | Action |
| :--- | :--- |
| 1 | Application requests data |
| 2 | Redis doesn't have it → fetch from RDS |
| 3 | RDS returns data → store in Redis (for next time) |
| 4 | User gets data (slightly slower the first time) |
---
