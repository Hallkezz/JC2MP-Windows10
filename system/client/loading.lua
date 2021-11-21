class 'Load'

function Load:__init()
	self.LoadingCircle_Outer = Image.Create( AssetLocation.Resource, "LoadingCircle_Outer" )
	self.BackgroundImage = Image.Create( AssetLocation.Resource, "BackgroundImage" )

	Events:Subscribe( "ModuleLoad", self, self.ModuleLoad )
	Events:Subscribe( "GameLoad", self, self.GameLoad )
	Events:Subscribe( "LocalPlayerDeath", self, self.LocalPlayerDeath )
	self.PostRender = Events:Subscribe( "PostRender", self, self.PostRender )

	IsJoining = false
end

function Load:ModuleLoad()
	if Game:GetState() ~= GUIState.Loading then
		IsJoining = false
	else
		IsJoining = true
		FadeInTimer = Timer()
	end
end

function Load:GameLoad()
	FadeInTimer = nil
	if LocalPlayer:GetValue( "UserName" ) then
		Events:Fire( "OpenDesktop" )
	else
		Events:Fire( "OpenOOBE" )
	end
end

function Load:LocalPlayerDeath()
	self.BackgroundImage = Image.Create( AssetLocation.Resource, "BackgroundImage" )
	FadeInTimer = Timer()
end

function Load:PostRender()
	if Game:GetState() == GUIState.Loading then
		local CircleSize = Vector2( Render.Size.x / 55, Render.Size.x / 55 )
		local TransformOuter = Transform2()
		local Rotation = self.GetRotation()
		local Pos = Vector2( Render.Size.x / 2, Render.Size.y - 200 )

		Render:FillArea( Vector2( 0, 0 ), Vector2( Render.Size.x, Render.Size.y ), Color.Black )

		self.BackgroundImage:SetSize( Vector2( Render.Size.x / 8, Render.Size.x / 8 ) )
		self.BackgroundImage:SetPosition( Vector2( Render.Size.x / 2 - self.BackgroundImage:GetSize().x / 2, Render.Size.y / 2.3 - self.BackgroundImage:GetSize().y / 2 ) )
		self.BackgroundImage:Draw()

		if FadeInTimer then
			TransformOuter:Translate( Pos )
			TransformOuter:Rotate( math.pi * Rotation )

			Render:SetTransform( TransformOuter )
			self.LoadingCircle_Outer:Draw( -(CircleSize / 2), CircleSize, Vector2.Zero, Vector2.One )
			Render:ResetTransform()

			if FadeInTimer:GetMinutes() >= 1 then
				Events:Unsubscribe( self.PostRender )
				self:ExitWindow()
			end
		end
	end
end

function Load:GetRotation()
	if FadeInTimer then
		local RotationValue = FadeInTimer:GetSeconds()* 0.60
		return RotationValue
	end
end

Load = Load()