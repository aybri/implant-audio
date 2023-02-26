local aukit = require "aukit"

local tArgs = {...} --websocket url

if not chatbox.hasCapability("command") or not chatbox.hasCapability("tell") then
	  error("Chatbox does not have the required permissions. Did you register the license?")
end

local BOT_NAME = "Aaron" -- You can colour bot names!

local audioOn

local handle, err = http.websocket(tArgs[1])
if not handle then error(err, 0) end

parallel.waitForAny(function()
    local function playAudio()
        while true do
            if audioOn then
                return handle.receive(5)
            else
                sleep(0.5)
            end
        end
    end

    aukit.play(aukit.stream.pcm(playAudio, 16, "signed", 2, 48000), peripheral.find("speaker"))
    sleep(0.5)
end, function()
    while true do
        local _, user, command = os.pullEvent("command")

        if user == "EmeraldImpulse" then
            if command == "togglemute" then
                if audioOn then
                    chatbox.tell(user, "Muting...", BOT_NAME)
                    audioOn = false
                else
                    chatbox.tell(user, "Unmuting...", BOT_NAME)
                    audioOn = true
                end
            end
        end
    end
end)