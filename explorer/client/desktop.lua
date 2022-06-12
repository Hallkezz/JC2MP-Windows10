class "Desktop"

function Desktop:__init()
    self.selectionbox_pos = Vector2.Zero
    self.savedpos_x = Mouse:GetPosition().x
    self.savedpos_y = Mouse:GetPosition().y

    Events:Subscribe( "OpenDesktop", self, self.OpenDesktop )

    if LocalPlayer:GetValue( "EnabledDesktop" ) then
        self:OpenDesktop()
    end
end

function Desktop:PostRender()
    if self.selectionbox then
        if self.selectionbox == 1 then
            self.savedpos_x = Mouse:GetPosition().x
            self.savedpos_y = Mouse:GetPosition().y

            Render:FillArea( self.selectionbox_pos, Vector2( Mouse:GetPosition().x - self.selectionbox_pos.x, Mouse:GetPosition().y - self.selectionbox_pos.y ), Color( 0, 130, 255, 100 ) )
        elseif self.selectionbox == 2 then
            Render:FillArea( self.selectionbox_pos, Vector2( self.savedpos_x - self.selectionbox_pos.x, self.savedpos_y - self.selectionbox_pos.y ), Color( 0, 130, 255, 100 ) )
        end
    end

    if self.clock_time then
        self.clock_time:SetText( os.date( "%H:%M" ) )
    end

    if self.clock_date then
        self.clock_date:SetText( os.date( "%d.%m.%Y" ) )
    end
end

function Desktop:OpenDesktop()
    Events:Subscribe( "ResolutionChange", self, self.ResolutionChange )
    Events:Subscribe( "PostRender", self, self.PostRender )
    Events:Subscribe( "MouseDown", self, self.MouseDown )
    Events:Subscribe( "MouseUp", self, self.MouseUp )
    --Events:Subscribe( "MouseMove", self, self.MouseMove )
    Events:Subscribe( "KeyUp", self, self.KeyUp )
    Events:Subscribe( "ModuleUnload", self, self.ModuleUnload )

    self.background = Rectangle.Create()
    self.background:SetColor( Color.Black )
    self.background:SetSize( Vector2( Render.Size.x, Render.Size.y ) )
    self.background:SetMouseInputEnabled( false )

    self.wallpaper = ImagePanel.Create()
    self.wallpaper:SetImage( Image.Create( AssetLocation.Resource, "DefaultWallpaper" ) )
    self.wallpaper:SetSize( Vector2( Render.Size.x, Render.Size.y ) )
    self.wallpaper:SetMouseInputEnabled( false )
    Mouse:SetVisible( true )

    --[[self.selectionbox = Rectangle.Create()
    self.selectionbox:SetVisible( false )
    self.selectionbox:SetColor( Color( 0, 130, 255, 100 ) )
    self.selectionbox:SetMouseInputEnabled( false )]]--

    self.taskbar = Rectangle.Create()
    self.taskbar:SetColor( Color( 0, 0, 0, 200 ) )
    self.taskbar:SetSize( Vector2( Render.Size.x, 43 ) )
    self.taskbar:SetPosition( Vector2( 0, Render.Size.y - 43 ) )
    self.taskbar:Subscribe( "HoverEnter", self, self.TaskbarHorved )
    self.taskbar:Subscribe( "HoverLeave", self, self.TaskbarLeave )

    self:TaskbarButtons()

    --Start Menu
    self.startmenu_window = Rectangle.Create()
    self.startmenu_window:SetVisible( false )
    self.startmenu_window:SetColor( Color( 25, 25, 25, 200 ) )
    self.startmenu_window:SetSize( Vector2( 400, Render.Size.x / 3 ) )

    self.startmenu_window_username = Label.Create( self.startmenu_window )
    self.startmenu_window_username:SetText( LocalPlayer:GetValue( "UserName" ) )
    self.startmenu_window_username:SetTextSize( 15 )
    self.startmenu_window_username:SetPosition( Vector2( 60, 18 ) )
    self.startmenu_window_username:SizeToContents()

    self.startmenu_window_useravatar = ImagePanel.Create( self.startmenu_window )
    self.startmenu_window_useravatar:SetImage( Image.Create( AssetLocation.Resource, "Avatar" ) )
    self.startmenu_window_useravatar:SetPosition( Vector2( 15, 5 ) )
    self.startmenu_window_useravatar:SetSize( Vector2( 35, 35 ) )

    self.startmenu_window_power = MenuItem.Create( self.startmenu_window )
    self.startmenu_window_power:SetDock( GwenPosition.Bottom )
    self.startmenu_window_power:SetText( "Power" )
    self.startmenu_window_power:SetTextNormalColor( Color.White )
    self.startmenu_window_power:SetAlignment( GwenPosition.Left )
    self.startmenu_window_power:SetTextPadding( Vector2( 50, 20 ), Vector2.Zero )
    self.startmenu_window_power:SetTextSize( 15 )
    self.startmenu_window_power:SetHeight( 50 )
    self.startmenu_window_power:SetMargin( Vector2( 0, 10 ), Vector2( 200, 0 ) )
    self.startmenu_window_power:Subscribe( "Press", self, self.PowerOff )

    self.startmenu_window_power_icon = ImagePanel.Create( self.startmenu_window_power )
    self.startmenu_window_power_icon:SetImage( Image.Create( AssetLocation.Resource, "Power" ) )
    self.startmenu_window_power_icon:SetPosition( Vector2( 10, 10 ) )
    self.startmenu_window_power_icon:SetSize( Vector2( 30, 30 ) )

    --Internet
    self.internet_window = Rectangle.Create()
    self.internet_window:SetVisible( false )
    self.internet_window:SetColor( Color( 25, 25, 25, 200 ) )
    self.internet_window:SetSize( Vector2( 500, 140 ) )

    self.internet_window_button = MenuItem.Create( self.internet_window )
    self.internet_window_button:SetDock( GwenPosition.Top )
    self.internet_window_button:SetHeight( 50 )
    self.internet_window_button:SetMargin( Vector2( 0, 10 ), Vector2( 0, 0 ) )

    self.internet_window_icon = ImagePanel.Create( self.internet_window_button )
    self.internet_window_icon:SetImage( Image.Create( AssetLocation.Resource, "Internet" ) )
    self.internet_window_icon:SetPosition( Vector2( 10, 5 ) )
    self.internet_window_icon:SetSize( Vector2( 35, 35 ) )

    self.internet_window_network_txt = Label.Create( self.internet_window_button )
    self.internet_window_network_txt:SetText( "Network" )
    self.internet_window_network_txt:SetTextSize( 15 )
    self.internet_window_network_txt:SetPosition( Vector2( 55, 12 ) )
    self.internet_window_network_txt:SizeToContents()

    self.internet_window_connected_txt = Label.Create( self.internet_window_button )
    self.internet_window_connected_txt:SetText( "Connected" )
    self.internet_window_connected_txt:SetTextSize( 15 )
    self.internet_window_connected_txt:SetTextColor( Color( 190, 190, 190 ) )
    self.internet_window_connected_txt:SetPosition( Vector2( 55, self.internet_window_network_txt:GetPosition().y + 20 ) )
    self.internet_window_connected_txt:SizeToContents()

    --Context Menu
    self.contextmenu_outline = Rectangle.Create()
    self.contextmenu_outline:SetVisible( false )
    self.contextmenu_outline:SetColor( Color( 125, 125, 125 ) )
    self.contextmenu_outline:SetSize( Vector2( 390, 205 ) )

    self.contextmenu = Rectangle.Create( self.contextmenu_outline )
    self.contextmenu:SetColor( Color( 25, 25, 25 ) )
    self.contextmenu:SetDock( GwenPosition.Fill )
    self.contextmenu:SetMargin( Vector2( 1, 1 ), Vector2( 1, 1 ) )

    self:DesktopContextMenuItems()
end

function Desktop:TaskbarButtons()
    self.startmenu_button = MenuItem.Create( self.taskbar )
    self.startmenu_button:SetDock( GwenPosition.Left )
    self.startmenu_button:SetWidth( 50 )
    self.startmenu_button:Subscribe( "Press", self, self.StartMenu )

    self.startmenu_icon = ImagePanel.Create( self.startmenu_button )
    self.startmenu_icon:SetImage( Image.Create( AssetLocation.Resource, "StartMenu" ) )
    self.startmenu_icon:SetDock( GwenPosition.Fill )
    self.startmenu_icon:SetMargin( Vector2( 10, 6.5 ), Vector2( 10, 6.5 ) )

    self.taskview_button = MenuItem.Create( self.taskbar )
    self.taskview_button:SetDock( GwenPosition.Left )
    self.taskview_button:SetWidth( 50 )

    self.taskview_icon = ImagePanel.Create( self.taskview_button )
    self.taskview_icon:SetImage( Image.Create( AssetLocation.Resource, "TaskView" ) )
    self.taskview_icon:SetDock( GwenPosition.Fill )
    self.taskview_icon:SetMargin( Vector2( 11, 9 ), Vector2( 11, 9 ) )

    self.clock_button = MenuItem.Create( self.taskbar )
    self.clock_button:SetDock( GwenPosition.Right )
    self.clock_button:SetWidth( 80 )

    self.clock_time = Label.Create( self.clock_button )
    self.clock_time:SetDock( GwenPosition.Top )
    self.clock_time:SetText( os.date( "%H:%M" ) )
    if LocalPlayer:GetValue( "SystemFonts" ) then
        self.clock_time:SetFont( AssetLocation.SystemFont, "Segoe UI" )
    end
    self.clock_time:SetMargin( Vector2( 23, 8 ), Vector2( 0, 0 ) )

    self.clock_date = Label.Create( self.clock_button )
    self.clock_date:SetDock( GwenPosition.Bottom )
    self.clock_date:SetText( os.date( "%d.%m.%Y" ) )
    if LocalPlayer:GetValue( "SystemFonts" ) then
        self.clock_date:SetFont( AssetLocation.SystemFont, "Segoe UI" )
    end
    self.clock_date:SetMargin( Vector2( 10, 0 ), Vector2( 0, 8 ) )

    self.internet_button = MenuItem.Create( self.taskbar )
    self.internet_button:SetDock( GwenPosition.Right )
    self.internet_button:SetWidth( 30 )
    self.internet_button:Subscribe( "Press", self, self.InternetMenu )

    self.internet_icon = ImagePanel.Create( self.internet_button )
    self.internet_icon:SetImage( Image.Create( AssetLocation.Resource, "Internet" ) )
    self.internet_icon:SetDock( GwenPosition.Fill )
    self.internet_icon:SetMargin( Vector2( 5, 11.5 ), Vector2( 5, 11.5 ) )

    --[[self.icon_button = MenuItem.Create( self.taskbar )
    self.icon_button:SetDock( GwenPosition.Right )
    self.icon_button:SetWidth( 30 )

    self.icon_button = ImagePanel.Create( self.icon_button )
    self.icon_button:SetImage( Image.Create( AssetLocation.Resource, "Volume" ) )
    self.icon_button:SetDock( GwenPosition.Fill )
    self.icon_button:SetMargin( Vector2( 2, 11.5 ), Vector2( 2, 11.5 ) )]]--
end

function Desktop:ContextItem( text, enabled, pressfunction )
    self.contextmenu_refresh = MenuItem.Create( self.contextmenu )
    self.contextmenu_refresh:SetDock( GwenPosition.Top )
    self.contextmenu_refresh:SetSize( Vector2( 50, 25 ) )
    self.contextmenu_refresh:SetText( text )
    self.contextmenu_refresh:SetTextPadding( Vector2( self.contextmenu_refresh:GetTextWidth() - 30, 0 ), Vector2( 300, 0 ) )
    self.contextmenu_refresh:SetTextNormalColor( Color.White )
    self.contextmenu_refresh:SetEnabled( enabled )
    self.contextmenu_refresh:Subscribe( "Press", self, function() self.contextmenu_outline:SetVisible( false ) end )
    if pressfunction then
        self.contextmenu_refresh:Subscribe( "Press", self, pressfunction )
    end
end

function Desktop:DesktopContextMenuItems()
    self:ContextItem( "View", true )
    self:ContextItem( "Sort by", true )
    self:ContextItem( "Refresh", true )
    self:ContextItem( "Paste", false )
    self:ContextItem( "Paste shorcut", false )
    self:ContextItem( "New", true )
    self:ContextItem( "Display settings", true, function() error( "Failed to launch Settings app" ) end )
    self:ContextItem( "Personalize", true, function() error( "Failed to launch Settings app" ) end )
end

function Desktop:ResolutionChange( args )
    self.background:SetSize( Vector2( args.size.x, args.size.y ) )
    self.wallpaper:SetSize( Vector2( args.size.x, args.size.y ) )
    self.taskbar:SetSize( Vector2( args.size.x, 43 ) )

    self.taskbar:SetPosition( Vector2( 0, args.size.y - 43 ) )
end

function Desktop:StartMenu()
    if self.contextmenu_outline:GetVisible() then
        self.contextmenu_outline:SetVisible( false )
    end
    if self.selectionbox then
        self.selectionbox = nil
    end
    if self.internet_window:GetVisible() then
        self.internet_window:SetVisible( false )
    end

    if self.startmenu_window:GetVisible() then
        self.startmenu_window:SetVisible( false )
    else
        self.startmenu_window:SetVisible( true )
    end
    self.startmenu_window:SetPosition( Vector2( 0, self.taskbar:GetPosition().y - self.startmenu_window:GetSize().y ) )
end

function Desktop:InternetMenu()
    if self.contextmenu_outline:GetVisible() then
        self.contextmenu_outline:SetVisible( false )
    end

    if self.internet_window:GetVisible() then
        self.internet_window:SetVisible( false )
    else
        self.internet_window:SetVisible( true )
    end
    self.internet_window:SetPosition( Vector2( self.internet_button:GetPosition().x - self.internet_window:GetSize().x / 2, self.taskbar:GetPosition().y - self.internet_window:GetSize().y ) )
end

function Desktop:MouseUp( args )
    if args.button == 1 or args.button == 2 then
        self.selectionbox = nil
    end

    if args.button == 2 then
        if not self.contextmenu_outline:GetVisible() then
            self.contextmenu_outline:SetVisible( true )
            self.contextmenu_outline:SetPosition( Mouse:GetPosition() )
        end
    end
end

function Desktop:MouseDown( args )
    if args.button == 1 or args.button == 2 then
        self.selectionbox = 1
        self.selectionbox_pos = Mouse:GetPosition()
        if self.startmenu_window:GetVisible() then
            self.startmenu_window:SetVisible( false )
        end
        if self.internet_window:GetVisible() then
            self.internet_window:SetVisible( false )
        end
    end

    if self.contextmenu_outline:GetVisible() then
        self.contextmenu_outline:SetVisible( false )
    end
end


--[[function Desktop:MouseMove( args )
    if self.clock_time then
        self.clock_time:SetText( os.date( "%H:%M" ) )
    end
    if self.selectionbox:GetVisible() then
        self.selectionbox:SetSize( Vector2( Mouse:GetPosition().x - self.selectionbox:GetPosition().x, Mouse:GetPosition().y - self.selectionbox:GetPosition().y ) )
    end
end]]--

function Desktop:TaskbarHorved()
    if self.selectionbox then
        self.selectionbox = 2
        self.taskbar:SetMouseInputEnabled( false )
    end
end

function Desktop:TaskbarLeave()
    self.taskbar:SetMouseInputEnabled( true )
    if self.selectionbox then
        self.selectionbox = nil
    end
end

function Desktop:KeyUp( args )
    if args.key == VirtualKey.LWin or args.key == VirtualKey.RWin then
        self:StartMenu()
    end
end

function Desktop:PowerOff()
    Game:FireEvent( "bm.loadcheckpoint.go" )
    Events:Fire( "KickPlayer" )
end

function Desktop:ModuleUnload()
    if self.sound then
        self.sound:Remove()
        self.sound = nil
    end
end

desktop = Desktop()