# Cache Hit and Cache Miss

```text
Client
  |
  v
Application
  |
  v
Redis
  |\
  | \__ Hit ─────> Return cached response
  |
  \____ Miss
          |
          v
        RDS
          |
          v
     Application
          |
          v
     Store in Redis
          |
          v
     Return response
```

Redis is used for frequently requested data so repeated reads can be served without querying RDS every time. The application remains the source of truth for durable data; Redis is the performance layer.
