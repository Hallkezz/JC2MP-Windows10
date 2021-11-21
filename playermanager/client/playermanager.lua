class "PlayerManager"

function PlayerManager:__init()
    Game:FireEvent( "ply.pause" )

    Events:Subscribe( "KickPlayer", self, self.KickPlayer )
end

function PlayerManager:KickPlayer()
    Network:Send( "KickPlayer" )
end

playermanager = PlayerManager()