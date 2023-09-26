local module = {}
-- 克隆一个表
function module.CloneTable(original)
    local clone = {}
    for key, value in pairs(original) do
        clone[key] = value
    end
    return clone
end
return module
