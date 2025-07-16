
--!optimize 2
--!native
--!strict

-- NOTE: Data being corrupted when bigger than 25,960,447 bytes, I don't know why.

local HttpService 	= game:GetService'HttpService'

local Base64		= require'@self/Base64'

local JSONEncode 	= HttpService.JSONEncode
local JSONDecode 	= HttpService.JSONDecode

local Encode		= Base64.Encode
local Decode		= Base64.Decode

local FromStr 		= buffer.fromstring
local ToStr 		= buffer.tostring
local Find		= string.find
local Sub 		= string.sub

local Compression 	= {}

function Compression:Compress(Input: string): string
	
	local _, _, Result = Find(JSONEncode(HttpService, FromStr(Input)), '4":"(.+)"')
	
	if Result then return Decode(FromStr(Result)), Result end
	
	return Input
	
end

function Compression:Decompress(Input: string, a): string
	
	local Encoded = ToStr(Encode(FromStr(Input)))
	
	local isZSTD = Sub(Encoded, 1, 5) == 'KLUv/' and 'z' or ''
	
	return ToStr(JSONDecode(HttpService, `\{"m":null,"t":"buffer","{isZSTD}base64":"{Encoded}"}`))
	
end

return Compression
