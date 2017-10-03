# DefString
A module with a set of extra string functions for Defold

This is a community project you are welcome to contribute to it

View the list of functions at https://github.com/subsoap/defstring/blob/master/defstring/defstring.lua

## Installation
You can use DefString in your own project by adding this project as a [Defold library dependency](http://www.defold.com/manuals/libraries/). Open your game.project file and in the dependencies field under project add:

	https://github.com/subsoap/defstring/archive/master.zip
  
Once added, you must require the main Lua module via

```
local defstring = require("defstring.defstring")
```
Then you can use the DefString functions for example via

```
print(defstring.capitalize_every_word("hello world defstring"))
```
