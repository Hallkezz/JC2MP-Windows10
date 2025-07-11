class "Window"

function Window:__init()
    self.selectionbox_pos = Vector2.Zero
    self.savedpos_x = Mouse:GetPosition().x
    self.savedpos_y = Mouse:GetPosition().y

    Events:Subscribe("ModuleError", self, self.ModuleError)

    Events:Subscribe("OpenWindow", self, self.OpenWindow)
    Events:Subscribe("CloseWindow", self, self.CloseWindow)
    Console:Subscribe("ow", self, self.OpenWindow)
    Console:Subscribe("cw", self, self.CloseWindow)
end

function Window:CreateWindow(titletext, size, tabcolor, windowcolor, titletextcolor, contenttext)
    local window = Rectangle.Create()
    window:SetSize(size)
    window:SetPosition(Vector2(Render.Size.x / 2 - window:GetSize().x / 2, Render.Size.y / 2 - window:GetSize().y / 2))
    window:SetColor(windowcolor)

    local window_tab = Rectangle.Create(window)
    window_tab:SetColor(tabcolor)
    window_tab:SetHeight(30)
    window_tab:SetDock(GwenPosition.Top)
    window_tab:Subscribe("Render", self, function()
        if window_tab:GetHovered() and Key:IsDown(1) then
            window:SetPosition(Vector2(Mouse:GetPosition().x - window:GetSize().x / 2, Mouse:GetPosition().y - window_tab:GetSize().y / 2))
        end
    end)

    local window_title = Label.Create(window_tab)
    window_title:SetDock(GwenPosition.Left)
    window_title:SetText(titletext)
    window_title:SetTextColor(titletextcolor)
    window_title:SetMargin(Vector2(10, 10), Vector2(0, 0))

    local window_content = Label.Create(window)
    window_content:SetDock(GwenPosition.Fill)
    window_content:SetText(contenttext)
    window_content:SetTextColor(Color.Black)
    window_content:SetMargin(Vector2(10, 10), Vector2(10, 10))

    local bottom_background = Rectangle.Create(window)
    bottom_background:SetDock(GwenPosition.Bottom)
    bottom_background:SetHeight(50)
    bottom_background:SetColor(Color(230, 230, 230))

    local window_ok_button_outline = Rectangle.Create(bottom_background)
    window_ok_button_outline:SetDock(GwenPosition.Right)
    window_ok_button_outline:SetMargin(Vector2(10, 12), Vector2(10, 12))
    window_ok_button_outline:SetColor(Color(0, 110, 215))
    window_ok_button_outline:SetWidth(80)

    local window_ok_button_background = Rectangle.Create(window_ok_button_outline)
    window_ok_button_background:SetDock(GwenPosition.Fill)
    window_ok_button_background:SetMargin(Vector2(2, 2), Vector2(2, 2))
    window_ok_button_background:SetColor(Color(230, 230, 230))
    window_ok_button_background:SetWidth(50)

    local window_ok_button = MenuItem.Create(window_ok_button_background)
    window_ok_button:SetDock(GwenPosition.Fill)
    window_ok_button:SetText("OK")
    window_ok_button:SetTextNormalColor(titletextcolor)
    window_ok_button:SetTextHoveredColor(titletextcolor)
    window_ok_button:SetTextPressedColor(titletextcolor)

    local window_close_button = MenuItem.Create(window_tab)
    window_close_button:SetDock(GwenPosition.Right)
    window_close_button:SetText("x")
    window_close_button:SetTextSize(15)
    window_close_button:SetWidth(50)
    window_close_button:SetTextNormalColor(titletextcolor)
    window_close_button:SetTextHoveredColor(titletextcolor)
    window_close_button:SetTextPressedColor(titletextcolor)
    window_close_button:Subscribe("Press", self, function()
        window:Remove()
        window_tab:Remove()
        window_title:Remove()
        window_close_button:Remove()
        window_content:Remove()
        bottom_background:Remove()
        window_ok_button_outline:Remove()
        window_ok_button_background:Remove()
        window_ok_button:Remove()
    end)

    window_ok_button:Subscribe("Press", self, function()
        window:Remove()
        window_tab:Remove()
        window_title:Remove()
        window_close_button:Remove()
        window_content:Remove()
        bottom_background:Remove()
        window_ok_button_outline:Remove()
        window_ok_button_background:Remove()
        window_ok_button:Remove()
    end)
end

function Window:OpenWindow()
    self:CreateWindow("Credits", Vector2(600, 500), Color.Black, Color.White, Color.White, "Windows 10 In JC2MP By Hallkezz")
end

function Window:ModuleError(e)
    self:CreateWindow(e.module, Vector2(500, 200), Color.White, Color.White, Color.Black, e.error)
end

function Window:CloseWindow()
    self.window_tab:SetVisible(false)
end

window = Window()