--!optimize 2
--!native

local HttpService 	= game:GetService('HttpService')

local JSONEncode 	= HttpService.JSONEncode
local JSONDecode 	= HttpService.JSONDecode

local Fromstring 	= buffer.fromstring
local Tostring 		= buffer.tostring

local Findstring	= string.find
local SubString 	= string.sub

local strfinde		= '4":"(.+)"'
local izstdstr		= 'KLUv/'

local ZStandard 	= {}

function ZStandard:Compress(Input)
	
	local _, _, Result = Findstring(JSONEncode(HttpService, Fromstring(Input)), strfinde)
	
	return Result
	
end

function ZStandard:Decompress(Input)
	
	return Tostring(JSONDecode(HttpService, `\{"m":null,"t":"buffer","{SubString(Input, 1, 5) == izstdstr and 'z' or ''}base64":"{Input}"}`))

end

return ZStandard
