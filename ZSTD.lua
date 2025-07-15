--!optimize 2
--!native

local HttpService 	= game:GetService('HttpService')

local JSONEncode 	= HttpService.JSONEncode
local JSONDecode 	= HttpService.JSONDecode

local Fromstring 	= buffer.fromstring
local Tostring 		= buffer.tostring

local Extract 		= bit32.extract
local Lshift 		= bit32.lshift
local Rshift 		= bit32.rshift
local Band 		= bit32.band

local Findstring	= string.find
local ByteString 	= string.byte
local SubString 	= string.sub

local Concat 		= table.concat
local Create 		= table.create
local Insert 		= table.insert

local Ceil 		= math.ceil

local alphabet 		= "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
local strfinde		= '4":"(.+)"'
local izstdstr		= 'KLUv/'
local equalstr 		= "="

local ZStandard 	= {}
local Base64 		= {}

local function EncodeBase64(input)
	
	local len 	= #input
	
	local output 	= Create(Ceil(len * 4 / 3))
	
	local bytes 	= Create(len)
	
	for i = 1, len do bytes[i] = ByteString(input, i) end

	for i = 1, len, 3 do
		
		local b1 = bytes[i + 1]
		local b2 = bytes[i + 2]

		local n = Lshift(bytes[i], 16) + Lshift(b1 or 0, 8) + (b2 or 0)
		
		Insert(output, 		Base64[Extract(n, 18, 6)]		)
		Insert(output, 		Base64[Extract(n, 12, 6)]		)
		
		Insert(output, b1 and 	Base64[Extract(n, 6 , 6)] or equalstr	)
		Insert(output, b2 and 	Base64[Extract(n, 0 , 6)] or equalstr	)
		
	end

	return Concat(output)
	
end

local function DecodeBase64(Input)

	return Tostring(JSONDecode(HttpService, `\{"m":null,"t":"buffer","base64":"{Input}"}`))

end

function ZStandard:Compress(Input)
	
	local _, _, Result = Findstring(JSONEncode(HttpService, Fromstring(Input)), strfinde)
	
	return DecodeBase64(Result)
	
end

function ZStandard:Decompress(Input)
	
	local Encoded = EncodeBase64(Input)
	
	return Tostring(JSONDecode(HttpService, `\{"m":null,"t":"buffer","{SubString(Encoded, 1, 5) == izstdstr and 'z' or ''}base64":"{Encoded}"}`))

end

for i = 1, #alphabet do Base64[i - 1] = SubString(alphabet, i, i) end

return ZStandard
