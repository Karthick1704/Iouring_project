local redis = require "resty.redis"
local red = redis:new()

red:set_timeout(1000)


local ok, err = red:connect("redis", 6379)
if not ok then
    ngx.status = ngx.HTTP_INTERNAL_SERVER_ERROR
    ngx.say("Could not connect to Redis: ", err)
    return ngx.exit(ngx.HTTP_INTERNAL_SERVER_ERROR)
end

local token = ngx.req.get_headers()["Authorization"]

if not token then
    ngx.status = ngx.HTTP_UNAUTHORIZED
    ngx.say("No token found — access denied")
    return ngx.exit(ngx.HTTP_UNAUTHORIZED)
end


local res, err = red:get("auth_token")
if not res then
    ngx.status = ngx.HTTP_INTERNAL_SERVER_ERROR
    ngx.say("Error retrieving token: ", err)
    return ngx.exit(ngx.HTTP_INTERNAL_SERVER_ERROR)
end

ngx.log(ngx.ERR, "Token", token)

if res == ngx.null or res ~= token then
    ngx.status = ngx.HTTP_UNAUTHORIZED
    ngx.say("Invalid token — you shall not pass")
    return ngx.exit(ngx.HTTP_UNAUTHORIZED)
end
