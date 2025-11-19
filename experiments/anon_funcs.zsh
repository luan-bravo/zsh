# From $HISTFILE
a() { echo 'hello' 
a() { echo 'hello' }
a
function b { echo 'hallo' }
b
function b { local function hi() {echo 'hi'}; hi }
b
hi
xzsh
function b { local function hi() {echo 'hi'}; hi }
hi
b
hi
function { local function hi() {echo 'hi'}; hi }
xzsh
function { local function hi() {echo 'hi'}; hi }
hi
function { function hi() {echo 'hi'}; hi }
xzsh
function { function hi() {echo 'hi'}; hi }
hi
function { local greet='hi'; echo $greet }
xzsh
function { local greet='hi'; echo $greet }
echo $greett
echo $greet
local function {}
local function {echo fn}
local function {echo fn }
local function{ echo fn }
() {echo 'hi'
() {echo 'hi'}
() {local a='hi'; echo '$a}
