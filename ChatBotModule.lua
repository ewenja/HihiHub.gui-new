-- ChatBotModule.lua
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TextChatService = game:GetService("TextChatService")

local ChatBot = {}
local Toggles = nil
local Options = nil

-- 資料
local Emojis = {
	"😀","😃","😄","😁","😆","😅","🤣","😂","🙂","🙃","😉","😊","😇","🥰","😍","🤩","😘","😗",
	"😚","😙","😋","😛","😜","🤪","😝","🤑","🤗","🤭","🤫","🤔","🤐","🤨","😐","😑","😶","😏",
	"😒","🙁","☹️","😔","😟","😕","😣","😖","😫","😩","🥺","😢","😭","😤","😠","😡","🤬",
	"🤯","😳","🥵","🥶","😱","😨","😰","😥","😓","🤥","😬","🙄","😯","😦","😧","😮","😲"
}
local Symbols = {"!", "#", "$", "?", '"', "'"}

local Phrases = {
	["British"] = {
		"Fancy a tea mate?",
		"Im bound to the chippy!",
		"☕☕",
		"Why are you looking at my teeth?",
		"BLOODY HELL MATE! THAT DRIVES ME BONKERS!",
		"AKSHUALLY ITS FOOTBALL NOT SOCCER",
		"God save the queen and bless the British!"
	},
	["HihiHub"] = {
		"HihiHub > All",
		"HihiHub Owns me and all others",
		"Just bought HihiHub today, I can actually hit my shots now!",
		"HihiHub on top",
		"Uno all it takes with HihiHub"
	},
	["Trashtalk"] = {
		"STOP TRYING YOU ARE AN EMBARRASSMENT",
		"GET GOOD HOLY",
		"WOW LOL YOU'RE ACTUALLY SO TRASH",
		"I CAN'T BELIEVE THAT'S YOUR AIM",
		"YAWN... YOU'RE SO BAD I FELL ASLEEP"
	}
}

-- 隨機產生訊息
local function WrapMessage()
	local phraseList = Phrases[Options.ChatbotMode.Value]
	if not phraseList then return nil end

	local emoji = Emojis[math.random(1, #Emojis)]
	local symbol = Symbols[math.random(1, #Symbols)]
	local phrase = phraseList[math.random(1, #phraseList)]

	return string.format("%s %s %s", symbol, phrase, emoji)
end

-- 啟動主邏輯
function ChatBot:Start()
	local lastTick = tick()
	RunService.Heartbeat:Connect(function()
		if not Toggles or not Toggles.ChatbotToggle or not Toggles.ChatbotToggle.Value then return end
		if tick() - lastTick >= Options.ChatbotDelay.Value then
			lastTick = tick()
			local message = WrapMessage()
			if message then
				pcall(function()
					local channel = TextChatService:FindFirstChild("TextChannels") and TextChatService.TextChannels:FindFirstChild("RBXGeneral")
					if channel then
						channel:SendAsync(message)
					end
				end)
			end
		end
	end)
end

function ChatBot:Init(injectedToggles, injectedOptions)
	Toggles = injectedToggles
	Options = injectedOptions
	self:Start()
end

return ChatBot
