require "ISUI/AdminPanel/ISLabel"

ISAddNonPvpZoneUI = ISPanel:derive("ISAddNonPvpZoneUI")

local FONT_HGT_SMALL = getTextManager():getFontHeight(UIFont.Small)
local FONT_HGT_MEDIUM = getTextManager():getFontHeight(UIFont.Medium)
local MAX_RENDER_DISTANCE = 101
local DEFAULT_RENDER_DISTANCE = 60

local function calculateEuclideanDistance(x1, y1, x2, y2)
    return math.sqrt((x2 - x1)^2 + (y2 - y1)^2)
end

local function isWithinDistance(x, y, centerX, centerY, maxDistance)
    return calculateEuclideanDistance(x, y, centerX, centerY) <= maxDistance
end

function ISAddNonPvpZoneUI:initialise()
    ISPanel.initialise(self)

    local btnLabel_ok = getText("IGUI_PvpZone_AddZone")
    local btnLabel_cancel = getText("UI_Cancel")
    local btnLabel_redefine = getText("IGUI_PvpZone_RedefineStartingPoint")

    --local btnTextWidth_ok= getTextManager():MeasureStringX(UIFont.Small, btnLabel_ok)
    --local btnTextWidth_cancel = getTextManager():MeasureStringX(UIFont.Small, btnLabel_cancel)
    local btnTextWidth_redefine = getTextManager():MeasureStringX(UIFont.Small, btnLabel_redefine)

    local btnWidth = 100
    local btnHeight = FONT_HGT_SMALL + 3 * 2

    local btnWidth_ok = btnWidth
    local btnWidth_cancel = btnWidth
    local btnWidth_redefine = btnTextWidth_redefine + 3 * 2

    local btnHeight_ok = btnHeight
    local btnHeight_cancel = btnHeight
    local btnHeight_redefine = btnHeight

    local btnPadX = 10
    local btnPadY = 10

    local btnPosX_ok = btnPadX
    local btnPosY_ok = self:getHeight() - btnPadY - btnHeight

    local btnPosX_cancel = self:getWidth() - btnPadX - btnWidth_cancel
    local btnPosY_cancel = self:getHeight() - btnPadY - btnHeight

    local btnPosX_redefine = self:getWidth() - 2 * btnPadX - btnWidth_cancel - btnWidth_redefine
    local btnPosY_redefine = self:getHeight() - btnPadY - btnHeight

    self.btnOk = ISButton:new(btnPosX_ok, btnPosY_ok, btnWidth_ok, btnHeight_ok, btnLabel_ok, self, ISAddNonPvpZoneUI.onClick)
    self.btnOk.internal = "OK"
    self.btnOk.anchorTop = true
    self.btnOk.anchorBottom = false
    self.btnOk:initialise()
    self.btnOk:instantiate()
    self.btnOk.borderColor = {r=1, g=1, b=1, a=0.1}
    self:addChild(self.btnOk)

    self.btnOk.infos = {}
    self.btnOk.infos.posX = btnPosX_ok
    self.btnOk.infos.posY = btnPosY_ok
    self.btnOk.infos.width = btnWidth_ok
    self.btnOk.infos.height = btnHeight_ok

    self.btnCancel = ISButton:new(btnPosX_cancel, btnPosY_cancel, btnWidth_cancel, btnHeight_cancel, btnLabel_cancel, self, ISAddNonPvpZoneUI.onClick)
    self.btnCancel.internal = "CANCEL"
    self.btnCancel.anchorTop = true
    self.btnCancel.anchorBottom = false
    self.btnCancel:initialise()
    self.btnCancel:instantiate()
    self.btnCancel.borderColor = {r=1, g=1, b=1, a=0.1}
    self:addChild(self.btnCancel)

    self.btnCancel.infos = {}
    self.btnCancel.infos.posX = btnPosX_cancel
    self.btnCancel.infos.posX = btnPosY_cancel
    self.btnCancel.infos.posX = btnWidth_cancel
    self.btnCancel.infos.posX = btnHeight_cancel

    self.btnRedefine = ISButton:new(btnPosX_redefine, btnPosY_redefine, btnWidth_redefine, btnHeight_redefine, btnLabel_redefine, self, ISAddNonPvpZoneUI.onClick)
    self.btnRedefine.internal = "DEFINESTARTINGPOINT"
    self.btnRedefine.anchorTop = true
    self.btnRedefine.anchorBottom = false
    self.btnRedefine:initialise()
    self.btnRedefine:instantiate()
    self.btnRedefine.borderColor = {r=1, g=1, b=1, a=0.1}
    self:addChild(self.btnRedefine)

    self.btnRedefine.infos = {}
    self.btnRedefine.infos.posX = btnPosX_redefine
    self.btnRedefine.infos.posX = btnPosY_redefine
    self.btnRedefine.infos.posX = btnWidth_redefine
    self.btnRedefine.infos.posX = btnHeight_redefine

    local entryBoxText_title = "Zone #" .. NonPvpZone.getAllZones():size() + 1
    local entryBoxText_render = tostring(DEFAULT_RENDER_DISTANCE)

    self.titleEntry = ISTextEntryBox:new(entryBoxText_title, 10, 10, self:getWidth()/2 - 10, FONT_HGT_SMALL + 2 * 2)
    self.titleEntry:initialise()
    self.titleEntry:instantiate()
    self:addChild(self.titleEntry)

    self.renderDistanceEntry= ISTextEntryBox:new(entryBoxText_render, 10, 10, self:getWidth()/4 - 10, FONT_HGT_SMALL + 2 * 2)
    self.renderDistanceEntry:initialise()
    self.renderDistanceEntry:instantiate()
    self.renderDistanceEntry:setTooltip(getText("IGUI_PvpZone_RenderDistance_tooltip"))
    self:addChild(self.renderDistanceEntry)
end

function ISAddNonPvpZoneUI:prerender()
    local z = 20
    local splitPoint = 200
    local x = 10

    -- Desenha o fundo e a borda do painel
    self:drawRect(0, 0, self.width, self.height, self.backgroundColor.a, self.backgroundColor.r, self.backgroundColor.g, self.backgroundColor.b)
    self:drawRectBorder(0, 0, self.width, self.height, self.borderColor.a, self.borderColor.r, self.borderColor.g, self.borderColor.b)

    -- Desenha o texto do título
    self:drawText(string.upper(getText("IGUI_PvpZone_AddZone")), self.width/2 - (getTextManager():MeasureStringX(UIFont.Medium, string.upper(getText("IGUI_PvpZone_AddZone"))) / 2), z, 1, 1, 1, 1, UIFont.Medium)

    z = z + FONT_HGT_MEDIUM + 20

    -- Desenha o texto do nome da zona e posiciona a entrada de texto
    self:drawText(getText("IGUI_PvpZone_ZoneName"), x, z + 2, 1, 1, 1, 1, UIFont.Small)
    self.titleEntry:setY(z)
    self.titleEntry:setX(splitPoint)

    z = z + FONT_HGT_SMALL + 15

    -- Desenha o ponto inicial e suas coordenadas
    self:drawText(getText("IGUI_PvpZone_StartingPoint"), x, z, 1, 1, 1, 1, UIFont.Small)
    self:drawText(luautils.round(self.startingX, 0) .. " x " .. luautils.round(self.startingY, 0), splitPoint, z, 1, 1, 1, 1, UIFont.Small)

    z = z + FONT_HGT_SMALL + 15

    -- Desenha o ponto atual e suas coordenadas
    self:drawText(getText("IGUI_PvpZone_CurrentPoint"), x, z, 1, 1, 1, 1, UIFont.Small)
    self:drawText(luautils.round(self.player:getX(), 0) .. " x " .. luautils.round(self.player:getY(), 0), splitPoint, z, 1, 1, 1, 1, UIFont.Small)

    z = z + FONT_HGT_SMALL + 15

    -- Calcula e desenha o tamanho da zona
    local playerX = math.floor(self.player:getX())
    local playerY = math.floor(self.player:getY())

    local startingX = self.startingX
    local startingY = self.startingY
    local endX = playerX
    local endY = playerY

    -- Garante que startingX seja menor ou igual a endX e startingY seja menor ou igual a endY
    if startingX > endX then
        local x2 = endX
        endX = startingX
        startingX = x2
    end
    if startingY > endY then
        local y2 = endY
        endY = startingY
        startingY = y2
    end

    -- Calcula a largura e altura da zona
    local width = math.abs(startingX - endX) + 1
    local height = math.abs(startingY - endY) + 1
    self:drawText(getText("IGUI_PvpZone_CurrentZoneSize"), x, z, 1, 1, 1, 1, UIFont.Small)
    self.size = width * height
    self:drawText(self.size .. "", splitPoint, z, 1, 1, 1, 1, UIFont.Small)

    z = self:getHeight() - self.btnOk.infos.height - 40

    local renderDistance = tonumber(self.renderDistanceEntry:getInternalText())
    local renderDistanceOK = renderDistance and renderDistance < MAX_RENDER_DISTANCE
    local radius = renderDistanceOK and renderDistance or DEFAULT_RENDER_DISTANCE

    self:drawText(getText("IGUI_PvpZone_RenderDistance"), x, z + 2, 1, 1, 1, 1, UIFont.Small)
    self.renderDistanceEntry:setValid(renderDistanceOK)
    self.renderDistanceEntry:setY(z)
    self.renderDistanceEntry:setX(splitPoint)

    -- Destaca objetos dentro da zona se a largura ou altura forem menores que 100
    local minX = math.max(playerX - radius, startingX)
    local maxX = math.min(playerX + radius, endX)
    local minY = math.max(playerY - radius, startingY)
    local maxY = math.min(playerY + radius, endY)

    for x2 = minX, maxX do
        for y = minY, maxY do
            if isWithinDistance(x2, y, playerX, playerY, radius) then
                local sq = getCell():getGridSquare(x2, y, 0)
                if sq then
                    for n = 0, sq:getObjects():size() - 1 do
                        local obj = sq:getObjects():get(n)
                        obj:setHighlighted(true)
                        obj:setHighlightColor(0.3, 1, 0.3, 0.75)
                    end
                end
            end
        end
    end
    self:updateButtons()
    --print("NonPvp - " .. "S: " .. tostring(self.startingX) .. " x " .. tostring(self.startingY))
    --print("NonPvp - " .. "E: " .. tostring(playerX) .. " x " .. tostring(playerY))
end

function ISAddNonPvpZoneUI:updateButtons()
    self.btnOk.enable = self.size > 1;
end

function ISAddNonPvpZoneUI:onClick(button)
    if button.internal == "OK" then
        local doneIt = true
        if NonPvpZone.getZoneByTitle(self.titleEntry:getInternalText()) then
            doneIt = false
            local modal = ISModalDialog:new(0, 0, 350, 150, getText("IGUI_PvpZone_ZoneAlreadyExistTitle", self.selectedPlayer), false, nil, nil)
            modal:initialise()
            modal:addToUIManager()
            modal.moveWithMouse = true
        end
        if doneIt then
            self:setVisible(false)
            self:removeFromUIManager()

            local x1 = self.startingX
            local y1 = self.startingY
            local x2 = math.floor(self.player:getX())
            local y2 = math.floor(self.player:getY())

            if x1 > x2 then
                local temp = x1
                x1 = x2
                x2 = temp
            end

            if y1 > y2 then
                local temp = y1
                y1 = y2
                y2 = temp
            end

            NonPvpZone.addNonPvpZone(self.titleEntry:getInternalText(), x1, y1, x2 + 1, y2 + 1)
        else
            return
        end
    end
    if button.internal == "DEFINESTARTINGPOINT" then
        self.startingX = math.floor(self.player:getX())
        self.startingY = math.floor(self.player:getY())
        return
    end
    if button.internal == "CANCEL" then
        self:setVisible(false)
        self:removeFromUIManager()
    end
    self.parentUI:populateList()
    self.parentUI:setVisible(true)
    self.player:setSeeNonPvpZone(false)
end

function ISAddNonPvpZoneUI:new(x, y, width, height, player)
    local o = {}
    o = ISPanel:new(x, y, width, height)
    setmetatable(o, self)
    self.__index = self

    if y == 0 then
        o.y = o:getMouseY() - (height / 2)
        o:setY(o.y)
    end
    if x == 0 then
        o.x = o:getMouseX() - (width / 2)
        o:setX(o.x)
    end

    o.borderColor = {r=0.4, g=0.4, b=0.4, a=1}
    o.backgroundColor = {r=0, g=0, b=0, a=0.8}
    o.width = width
    o.height = height

    o.player = player
    o.startingX = math.floor(o.player:getX())
    o.startingY = math.floor(o.player:getY())

    player:setSeeNonPvpZone(true)

    o.moveWithMouse = true
    ISAddNonPvpZoneUI.instance = o
    o.buttonBorderColor = {r=0.7, g=0.7, b=0.7, a=0.5}
    return o
end