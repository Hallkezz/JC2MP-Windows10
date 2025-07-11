class "PlayerManager"

function PlayerManager:__init()
    Game:FireEvent("ply.pause")

    if not self.sound then
        self.sound = ClientSound.Create(AssetLocation.Game, {
            bank_id = 14,
            sound_id = 4,
            position = Camera:GetPosition(),
            angle = Angle()
        })
    else
        self.sound:SetPosition(Camera:GetPosition())
    end

    Events:Subscribe("GameLoad", self, self.GameLoad)
    Events:Subscribe("KickPlayer", self, self.KickPlayer)
end

function PlayerManager:GameLoad()
    self.timer = Timer()
    self.PostTickEvent = Events:Subscribe("PostTick", self, self.PostTick)
end

function PlayerManager:PostTick()
    if self.timer:GetSeconds() <= 1 then return end

    if not self.sound then
        self.sound = ClientSound.Create(AssetLocation.Game, {
            bank_id = 14,
            sound_id = 4,
            position = Camera:GetPosition(),
            angle = Angle()
        })
    else
        self.sound:SetPosition(Camera:GetPosition())
    end

    Events:Unsubscribe(self.PostTickEvent)
    self.PostTickEvent = nil
    self.timer = nil
end

function PlayerManager:KickPlayer()
    Network:Send("KickPlayer")
end

local playermanager = PlayerManager()