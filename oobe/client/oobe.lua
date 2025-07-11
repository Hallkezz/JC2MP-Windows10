class 'OOBE'

function OOBE:__init()
    Events:Subscribe("OpenOOBE", self, self.OpenOOBE)

    if LocalPlayer:GetValue("EnabledOOBE") then
        self:OpenOOBE()
    end
end

function OOBE:OpenOOBE()
    Events:Subscribe("ResolutionChange", self, self.ResolutionChange)

    Mouse:SetVisible(true)

    self.background = Rectangle.Create()
    self.background:SetColor(Color(0, 90, 150))
    self.background:SetSize(Vector2(Render.Size.x, Render.Size.y))

    self.setup1 = Label.Create()
    self.setup1:SetDock(GwenPosition.Fill)

    self.title_text = Label.Create(self.setup1)
    self.title_text:SetText("Create an account for this PC")
    self.title_text:SetTextSize(45)
    self.title_text:SetTextColor(Color(255, 255, 255, 220))
    self.title_text:SetPosition(Vector2(100, 80))
    if LocalPlayer:GetValue("SystemFonts") then
        self.title_text:SetFont(AssetLocation.SystemFont, "Segoe UI")
    end
    self.title_text:SizeToContents()

    self.description_text = Label.Create(self.setup1)
    self.description_text:SetText("If you want yo use a password, choose something that will be easy for you to remember but hard for other to guess.")
    self.description_text:SetTextSize(20)
    self.description_text:SetTextColor(Color(255, 255, 255, 220))
    self.description_text:SetPosition(Vector2(100, self.title_text:GetPosition().y + 80))
    if LocalPlayer:GetValue("SystemFonts") then
        self.description_text:SetFont(AssetLocation.SystemFont, "Segoe UI")
    end
    self.description_text:SizeToContents()

    self.tbox_username_text = Label.Create(self.setup1)
    self.tbox_username_text:SetText("Who's going to use this PC?")
    self.tbox_username_text:SetTextSize(20)
    self.tbox_username_text:SetPosition(Vector2(100, self.description_text:GetPosition().y + 80))
    if LocalPlayer:GetValue("SystemFonts") then
        self.tbox_username_text:SetFont(AssetLocation.Disk, "Archivo.ttf")
    end
    self.tbox_username_text:SizeToContents()

    self.tbox_username_background = Rectangle.Create(self.setup1)
    self.tbox_username_background:SetColor(Color(0, 0, 0, 100))
    self.tbox_username_background:SetPosition(Vector2(100, self.tbox_username_text:GetPosition().y + 35))
    self.tbox_username_background:SetSize(Vector2(350, 35))

    self.tbox_username = TextBox.Create(self.tbox_username_background)
    self.tbox_username:SetText("User name")
    self.tbox_username:SetTextColor(Color(255, 255, 255, 150))
    self.tbox_username:SetBackgroundVisible(false)
    self.tbox_username:SetTextSize(20)
    self.tbox_username:SetDock(GwenPosition.Fill)
    self.tbox_username:SetMargin(Vector2(5, 5), Vector2(5, 5))
    if LocalPlayer:GetValue("SystemFonts") then
        self.tbox_username:SetFont(AssetLocation.SystemFont, "Segoe UI")
    end

    self.tbox_password_text = Label.Create(self.setup1)
    self.tbox_password_text:SetText("Make it secure.")
    self.tbox_password_text:SetTextSize(20)
    self.tbox_password_text:SetPosition(Vector2(100, self.tbox_username_background:GetPosition().y + 80))
    if LocalPlayer:GetValue("SystemFonts") then
        self.tbox_password_text:SetFont(AssetLocation.Disk, "Archivo.ttf")
    end
    self.tbox_password_text:SizeToContents()

    self.tbox_password_background = Rectangle.Create(self.setup1)
    self.tbox_password_background:SetColor(Color(0, 0, 0, 100))
    self.tbox_password_background:SetPosition(Vector2(100, self.tbox_password_text:GetPosition().y + 35))
    self.tbox_password_background:SetSize(Vector2(350, 35))

    self.tbox_password = TextBox.Create(self.tbox_password_background)
    self.tbox_password:SetText("Enter password")
    self.tbox_password:SetTextColor(Color(255, 255, 255, 150))
    self.tbox_password:SetBackgroundVisible(false)
    self.tbox_password:SetTextSize(20)
    self.tbox_password:SetDock(GwenPosition.Fill)
    self.tbox_password:SetMargin(Vector2(5, 5), Vector2(5, 5))
    if LocalPlayer:GetValue("SystemFonts") then
        self.tbox_password:SetFont(AssetLocation.SystemFont, "Segoe UI")
    end
    self.tbox_password:SetEnabled(false)

    self.tbox_password2_background = Rectangle.Create(self.setup1)
    self.tbox_password2_background:SetColor(Color(0, 0, 0, 100))
    self.tbox_password2_background:SetPosition(Vector2(100, self.tbox_password_background:GetPosition().y + 50))
    self.tbox_password2_background:SetSize(Vector2(350, 35))

    self.tbox_password2 = TextBox.Create(self.tbox_password2_background)
    self.tbox_password2:SetText("Re-enter password")
    self.tbox_password2:SetTextColor(Color(255, 255, 255, 150))
    self.tbox_password2:SetBackgroundVisible(false)
    self.tbox_password2:SetTextSize(20)
    self.tbox_password2:SetDock(GwenPosition.Fill)
    self.tbox_password2:SetMargin(Vector2(5, 5), Vector2(5, 5))
    if LocalPlayer:GetValue("SystemFonts") then
        self.tbox_password2:SetFont(AssetLocation.SystemFont, "Segoe UI")
    end
    self.tbox_password2:SetEnabled(false)

    self.tbox_password3_background = Rectangle.Create(self.setup1)
    self.tbox_password3_background:SetColor(Color(0, 0, 0, 100))
    self.tbox_password3_background:SetPosition(Vector2(100, self.tbox_password2_background:GetPosition().y + 50))
    self.tbox_password3_background:SetSize(Vector2(350, 35))

    self.tbox_password3 = TextBox.Create(self.tbox_password3_background)
    self.tbox_password3:SetText("Password hint")
    self.tbox_password3:SetTextColor(Color(255, 255, 255, 150))
    self.tbox_password3:SetBackgroundVisible(false)
    self.tbox_password3:SetTextSize(20)
    self.tbox_password3:SetDock(GwenPosition.Fill)
    self.tbox_password3:SetMargin(Vector2(5, 5), Vector2(5, 5))
    if LocalPlayer:GetValue("SystemFonts") then
        self.tbox_password3:SetFont(AssetLocation.SystemFont, "Segoe UI")
    end

    self.next_button = Rectangle.Create(self.setup1)
    self.next_button:SetColor(Color(0, 120, 215))
    self.next_button:SetSize(Vector2(160, 40))
    self.next_button:SetPosition(Vector2(Render.Size.x - 50 - self.next_button:GetSize().x, Render.Size.y - 50 - self.next_button:GetSize().y))

    self.taskview_button = MenuItem.Create(self.next_button)
    self.taskview_button:SetDock(GwenPosition.Fill)
    self.taskview_button:SetText("Next")
    self.taskview_button:SetTextNormalColor(Color.White)
    self.taskview_button:SetTextSize(17)
    if LocalPlayer:GetValue("SystemFonts") then
        self.taskview_button:SetFont(AssetLocation.SystemFont, "Segoe UI")
    end
    self.taskview_button:Subscribe("Press", self, self.Next)
end

function OOBE:Next()
    self.background:SetVisible(false)
    Mouse:SetVisible(false)

    if not self.tbox_username:GetText() or self.tbox_username:GetText() == "" then
        LocalPlayer:SetValue("UserName", LocalPlayer:GetName())
    else
        LocalPlayer:SetValue("UserName", self.tbox_username:GetText())
    end

    self.loadTimer = Timer()
    self.PostTickEvent = Events:Subscribe("PostTick", self, self.PostTick)

    Events:Fire("ShowLoadingCircle", {
        size = Vector2(Render.Size.x / 25, Render.Size.x / 25),
        position = Vector2(Render.Size.x / 2 - Render.Size.x / 25 / 2, Render.Size.y / 2 - Render.Size.x / 25 / 2),
        loadtext = "Just a moment..."
    })
end

function OOBE:PostTick()
    if self.loadTimer:GetSeconds() >= math.random(10, 15) then
        self:OpenDesktop()
        Events:Fire("HideLoadingCircle")

        Events:Unsubscribe(self.PostTickEvent)
        self.PostTickEvent = nil
        self.loadTimer = nil
    end
end

function OOBE:OpenDesktop()
    LocalPlayer:SetValue("EnabledDesktop", 1)
    LocalPlayer:SetValue("EnabledOOBE", nil)
    Events:Fire("OpenDesktop")
end

function OOBE:ResolutionChange(args)
    self.background:SetSize(Vector2(args.size.x, args.size.y))

    self.next_button:SetPosition(Vector2(args.size.x - 50 - self.next_button:GetSize().x, args.size.y - 50 - self.next_button:GetSize().y))
end

local oobe = OOBE()