local discount = require "discount"
local markdown = discount.compile
local doc

doc = markdown [[
% Title ::
% Author ::
% Date ::
*Text*
]]
assert(doc.title == "Title ::")
assert(doc.author == "Author ::")
assert(doc.date == "Date ::")
assert(doc.body == "<p><em>Text</em></p>")

doc = markdown "<style>a {color: red}</style>Text"
assert(doc.css == "<style>a {color: red}</style>\n")

doc = markdown("", "toc")
assert(doc.body == "")
assert(not doc.index)

doc = markdown("# Heading", "toc")
assert(doc.body)
assert(doc.index)

io.write("\27[1;32mAll tests passed\27[0m\n\n")
