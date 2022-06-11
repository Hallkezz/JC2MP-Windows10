class 'LoadingCircle'

function LoadingCircle:__init()
    Events:Subscribe( "ShowLoadingCircle", self, self.ShowLoadingCircle )
    Events:Subscribe( "HideLoadingCircle", self, self.HideLoadingCircle )
end

function LoadingCircle:ShowLoadingCircle( args )
    if not self.PostRenderEvent then
        self.timer = Timer()
        self.count = 0
        self.loadImage = Image.Create( AssetLocation.Resource, tostring( self.count ) )

        self.PostRenderEvent = Events:Subscribe( "PostRender", self, self.PostRender )

        if args.size then
            self.size = args.size
        else
            self.size = Vector2( Render.Size.x / 30, Render.Size.x / 30 )
        end

        if args.position then
            self.position = args.position
        else
            self.position = Vector2( Render.Size.x / 2 - self.size.x / 2, Render.Size.y / 2 - self.size.y / 2 )
        end

        if args.speed then
            self.speed = args.speed
        else
            self.speed = 0.05
        end

        if args.loadtext then
            self.loadtext = args.loadtext
        end
    end
end

function LoadingCircle:HideLoadingCircle()
    if self.PostRenderEvent then
        self.timer = nil
        self.count = nil
        self.loadImage = nil

        self.PostRenderEvent = Events:Unsubscribe( self.PostRenderEvent )
        self.PostRenderEvent = nil
        self.size = nil
        self.position = nil
        self.speed = nil
        self.loadtext = nil
    end
end

function LoadingCircle:PostRender()
    if self.loadtext then
        if LocalPlayer:GetValue( "SystemFonts" ) then
            Render:SetFont( AssetLocation.SystemFont, "Segoe UI" )
        end
        Render:FillArea( Vector2.Zero, Render.Size, Color( 0, 90, 150 ) )
        Render:DrawText( Render.Size / 2 - Vector2( Render:GetTextWidth( self.loadtext, Render.Size.x / 70 ) / 2, - self.size.y - Render.Size.y / 150 ), self.loadtext, Color.White, Render.Size.x / 70 )
    end

    self.loadImage:Draw()

    if self.timer:GetSeconds() < self.speed then return end

    if self.count >= 75 then
        self.count = 0
    end

    self.loadImage = Image.Create( AssetLocation.Resource, tostring( self.count ) )
    self.loadImage:SetSize( self.size )
    self.loadImage:SetPosition( self.position )

    self.count = self.count + 1
    self.timer:Restart()
end

loadingcircle = LoadingCircle()