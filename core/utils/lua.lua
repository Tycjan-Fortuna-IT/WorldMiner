local lua = {}

-- Ternary operator
-- @param cond: boolean
-- @param T: any
-- @param F: any
-- @return any
--
lua.ternary = function(cond, T, F)
    if cond then return T else return F end
end

return lua
