Locale = Locale or {}

function L(key, ...)
    local str = Locale[key] or key
    if select('#', ...) > 0 then
        return string.format(str, ...)
    end
    return str
end
