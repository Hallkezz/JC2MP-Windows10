class "PlayerManager"

function PlayerManager:__init()
    Events:Subscribe("PlayerSpawn", self, self.PlayerSpawn)
    Network:Subscribe("KickPlayer", self, self.KickPlayer)
end

function PlayerManager:PlayerSpawn(args)
    args.player:SetPosition(Vector3(1000, 1000, 0))

    if args.player:GetValue("UserName") then
        args.player:SetNetworkValue("EnabledDesktop", 1)
    else
        args.player:SetNetworkValue("EnabledOOBE", 1)
    end

    return false
end

function PlayerManager:KickPlayer(args, sender)
    sender:Kick()
end

local playermanager = PlayerManager()