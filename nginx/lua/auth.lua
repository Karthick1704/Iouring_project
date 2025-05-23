local redis = require "resty.redis"
local red = redis:new()

-- Set how long to wait for Redis before timing out (1 second)
red:set_timeout(1000)

-- Try to connect to Redis server
local ok, err = red:connect("redis", 6379)
if not ok then
    ngx.status = ngx.HTTP_INTERNAL_SERVER_ERROR
    ngx.say("Could not connect to Redis: ", err)
    return ngx.exit(ngx.HTTP_INTERNAL_SERVER_ERROR)
end

-- Grab the token from the request headers
local token = ngx.req.get_headers()["Authorization"]

-- If no token was sent, reject the request
if not token then
    ngx.status = ngx.HTTP_UNAUTHORIZED
    ngx.say("No token found — access denied")
    return ngx.exit(ngx.HTTP_UNAUTHORIZED)
end

-- Get the stored token from Redis
local res, err = red:get("auth_token")
if not res then
    ngx.status = ngx.HTTP_INTERNAL_SERVER_ERROR
    ngx.say("Error retrieving token: ", err)
    return ngx.exit(ngx.HTTP_INTERNAL_SERVER_ERROR)
end

-- Check if token is missing in Redis or doesn't match
if res == ngx.null or res ~= token then
    ngx.status = ngx.HTTP_UNAUTHORIZED
    ngx.say("Invalid token — you shall not pass")
    return ngx.exit(ngx.HTTP_UNAUTHORIZED)
end
