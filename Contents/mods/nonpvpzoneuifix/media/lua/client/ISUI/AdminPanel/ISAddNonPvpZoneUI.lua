-- ┓ ┏┓┏┓┳┓┏┓┳┓┳┓┏┓  ┏┓┳┳┓┏┓┳┓┏┓┓ 
-- ┃ ┣ ┃┃┃┃┣┫┣┫┃┃┃┃  ┣┫┃┃┃┣┫┣┫┣┫┃ 
-- ┗┛┗┛┗┛┛┗┛┗┛┗┻┛┗┛  ┛┗┛ ┗┛┗┛┗┛┗┗┛
-- Modified: 23/08/2024, 11:00 (UTC/GMT -03:00) 
-- Version: 2.0

-- Relevant console commands:
-- - reloadLuaFile("./media/lua/client/ISUI/AdminPanel/ISAddNonPvpZoneUI.lua")

require "ISUI/AdminPanel/ISLabel"

ISAddNonPvpZoneUI = ISPanel:derive("ISAddNonPvpZoneUI")
ISAddNonPvpZoneUI.FONT_HGT_SMALL = getTextManager():getFontHeight(UIFont.Small)
ISAddNonPvpZoneUI.FONT_HGT_MEDIUM = getTextManager():getFontHeight(UIFont.Medium)
ISAddNonPvpZoneUI.MAX_RENDER_DISTANCE = 101
ISAddNonPvpZoneUI.DEFAULT_RENDER_DISTANCE = 70

local function calculateEuclideanDistance(x1, y1, x2, y2)
    return math.sqrt((x2 - x1)^2 + (y2 - y1)^2)
end

local function isWithinEuclideanDistance(x, y, centerX, centerY, maxDistance)
    return calculateEuclideanDistance(x, y, centerX, centerY) <= maxDistance
end

local function calculateManhattanDistance(x1, y1, x2, y2)
    local x = math.abs(x1 - x2)
    local y = math.abs(y1 - y2)
    return math.abs(x + y)
end

local function isWithinManhattanDistance(x, y, centerX, centerY, maxDistance)
    return calculateManhattanDistance(x, y, centerX, centerY) <= maxDistance
end

function ISAddNonPvpZoneUI:onChooseRenderType()
    self:save()
end

function ISAddNonPvpZoneUI:initialise()
    ISPanel.initialise(self)

    local borderPad = 20
    local bottonBorderPad = 10
    local btnWidth = 100
    local btnHeight = ISAddNonPvpZoneUI.FONT_HGT_SMALL + 3 * 2
    local btnPad = 10
    local z = 20

    local lblTitle_text = string.upper(getText("IGUI_PvpZone_AddZone"))
    self.lblTitle = ISLabel:new(self:getWidth() / 2, z, ISAddNonPvpZoneUI.FONT_HGT_MEDIUM, lblTitle_text, 1, 1, 1, 1, UIFont.Medium, true)
    self.lblTitle:initialise()
    self.lblTitle.center = true
    self:addChild(self.lblTitle)

    z = z + ISAddNonPvpZoneUI.FONT_HGT_MEDIUM + 20

    local lblName_text = getText("IGUI_PvpZone_ZoneName")
    self.lblName = ISLabel:new(borderPad, z, ISAddNonPvpZoneUI.FONT_HGT_SMALL, lblName_text, 1, 1, 1, 1, UIFont.Small, true)
    self.lblName:initialise()
    self:addChild(self.lblName)

    local entryBoxText_title = "Zone #" .. NonPvpZone.getAllZones():size() + 1
    self.entryBoxTitle = ISTextEntryBox:new(entryBoxText_title, self:getWidth()/2, z, self:getWidth()/2 - borderPad, ISAddNonPvpZoneUI.FONT_HGT_SMALL)
    self.entryBoxTitle:initialise()
    self.entryBoxTitle:instantiate()
    self:addChild(self.entryBoxTitle)

    z = z + ISAddNonPvpZoneUI.FONT_HGT_SMALL + 15

    local lblStatingPoint_text = getText("IGUI_PvpZone_StartingPoint")
    self.lblStartingPoint = ISLabel:new(borderPad, z, ISAddNonPvpZoneUI.FONT_HGT_SMALL, lblStatingPoint_text, 1, 1, 1, 1, UIFont.Small, true)
    self.lblStartingPoint:initialise()
    self:addChild(self.lblStartingPoint)

    self.lblStartingPointInfo = ISLabel:new(self:getWidth()/2, z, ISAddNonPvpZoneUI.FONT_HGT_SMALL, "x = ----- , y = -----", 1, 1, 1, 1, UIFont.Small, true)
    self.lblStartingPointInfo:initialise()
    self:addChild(self.lblStartingPointInfo)

    z = z + ISAddNonPvpZoneUI.FONT_HGT_SMALL + 15

    local lblCurrentPoint_text = getText("IGUI_PvpZone_CurrentPoint")
    self.lblCurrentPoint = ISLabel:new(borderPad, z, ISAddNonPvpZoneUI.FONT_HGT_SMALL, lblCurrentPoint_text, 1, 1, 1, 1, UIFont.Small, true)
    self.lblCurrentPoint:initialise()
    self:addChild(self.lblCurrentPoint)

    self.lblCurrentPointInfo = ISLabel:new(self:getWidth()/2, z, ISAddNonPvpZoneUI.FONT_HGT_SMALL, "x = ----- , y = -----", 1, 1, 1, 1, UIFont.Small, true)
    self.lblCurrentPointInfo:initialise()
    self:addChild(self.lblCurrentPointInfo)

    z = z + ISAddNonPvpZoneUI.FONT_HGT_SMALL + 15

    local lblCurrentSize_text = getText("IGUI_PvpZone_CurrentZoneSize")
    self.lblCurrentSize = ISLabel:new(borderPad, z, ISAddNonPvpZoneUI.FONT_HGT_SMALL, lblCurrentSize_text, 1, 1, 1, 1, UIFont.Small, true)
    self.lblCurrentSize:initialise()
    self:addChild(self.lblCurrentSize)

    self.lblCurrentSizeInfo = ISLabel:new(self:getWidth()/2, z, ISAddNonPvpZoneUI.FONT_HGT_SMALL, "------", 1, 1, 1, 1, UIFont.Small, true)
    self.lblCurrentSizeInfo:initialise()
    self:addChild(self.lblCurrentSizeInfo)

    z = z + ISAddNonPvpZoneUI.FONT_HGT_SMALL + 15

    local btnLbtnOk_text = getText("IGUI_PvpZone_AddZone")
    self.btnOk = ISButton:new(borderPad, self:getHeight() - bottonBorderPad - btnHeight, btnWidth, btnHeight, btnLbtnOk_text, self, ISAddNonPvpZoneUI.onClick)
    self.btnOk.internal = "OK"
    self.btnOk.anchorTop = true
    self.btnOk.anchorBottom = false
    self.btnOk:initialise()
    self.btnOk:instantiate()
    self.btnOk.borderColor = {r=1, g=1, b=1, a=0.1}
    self:addChild(self.btnOk)

    local btnCancel_text = getText("UI_Cancel")
    self.btnCancel = ISButton:new(self:getWidth() - borderPad - btnWidth, self:getHeight() - bottonBorderPad - btnHeight, btnWidth, btnHeight, btnCancel_text, self, ISAddNonPvpZoneUI.onClick)
    self.btnCancel.internal = "CANCEL"
    self.btnCancel.anchorTop = true
    self.btnCancel.anchorBottom = false
    self.btnCancel:initialise()
    self.btnCancel:instantiate()
    self.btnCancel.borderColor = {r=1, g=1, b=1, a=0.1}
    self:addChild(self.btnCancel)

    local btnRedefine_text = getText("IGUI_PvpZone_RedefineStartingPoint")
    local btnRedefine_textSize = getTextManager():MeasureStringX(UIFont.Small, btnRedefine_text)
    local btnRedefine_size = btnRedefine_textSize + 3 * 2
    self.btnRedefine = ISButton:new(self:getWidth() - btnRedefine_size - btnPad - self.btnCancel:getWidth() - borderPad, self:getHeight() - bottonBorderPad - btnHeight, btnRedefine_size, btnHeight, btnRedefine_text, self, ISAddNonPvpZoneUI.onClick)
    self.btnRedefine.internal = "DEFINESTARTINGPOINT"
    self.btnRedefine.anchorTop = true
    self.btnRedefine.anchorBottom = false
    self.btnRedefine:initialise()
    self.btnRedefine:instantiate()
    self.btnRedefine.borderColor = {r=1, g=1, b=1, a=0.1}
    self:addChild(self.btnRedefine)

    z = self:getHeight() - borderPad - self.btnOk:getHeight() - 2 * btnPad - ISAddNonPvpZoneUI.FONT_HGT_SMALL

    local lblRenderDistance_text = getText("IGUI_PvpZone_RenderDistance")
    self.lblRenderDistance = ISLabel:new(borderPad, z, ISAddNonPvpZoneUI.FONT_HGT_SMALL, lblRenderDistance_text, 1, 1, 1, 1, UIFont.Small, true)
    self.lblRenderDistance:initialise()
    self:addChild(self.lblRenderDistance)

    local entryBoxText_render = tostring(ISAddNonPvpZoneUI.DEFAULT_RENDER_DISTANCE)
    self.entryBoxRenderDistance= ISTextEntryBox:new(entryBoxText_render, self:getWidth()/2, z, self:getWidth()/2 - borderPad - self.btnCancel:getWidth() - btnPad + 3, ISAddNonPvpZoneUI.FONT_HGT_SMALL)
    self.entryBoxRenderDistance:initialise()
    self.entryBoxRenderDistance:instantiate()
    self.entryBoxRenderDistance:setTooltip(getText("IGUI_PvpZone_RenderDistance_tooltip"))
    self.entryBoxRenderDistance.onTextChange = function () self:save() end
    self:addChild(self.entryBoxRenderDistance)

    z = z - ISAddNonPvpZoneUI.FONT_HGT_SMALL - 15

    local lblRenderType_text = getText("IGUI_PvpZone_RenderCalc")
    self.lblRenderType = ISLabel:new(borderPad, z, ISAddNonPvpZoneUI.FONT_HGT_SMALL, lblRenderType_text, 1, 1, 1, 1, UIFont.Small, true)
    self.lblRenderType:initialise()
    self:addChild(self.lblRenderType)

    self.comboBoxRenderType = ISComboBox:new(self:getWidth()/2, z, self:getWidth()/2 - borderPad, btnHeight, self, ISAddNonPvpZoneUI.onChooseRenderType, nil, nil)
    self.comboBoxRenderType:initialise()
    self.comboBoxRenderType:addOptionWithData("Euclidean", isWithinEuclideanDistance)
    self.comboBoxRenderType:addOptionWithData("Manhattan", isWithinManhattanDistance)
    self:addChild(self.comboBoxRenderType)

    self:load()
end

function ISAddNonPvpZoneUI:prerender()
    local playerX = math.floor(self.player:getX())
    local playerY = math.floor(self.player:getY())

    self:drawRect(0, 0, self.width, self.height, self.backgroundColor.a, self.backgroundColor.r, self.backgroundColor.g, self.backgroundColor.b)
    self:drawRectBorder(0, 0, self.width, self.height, self.borderColor.a, self.borderColor.r, self.borderColor.g, self.borderColor.b)

    self.lblStartingPointInfo:setName("x = " .. tostring(self.startingX) .. ", y = " .. tostring(self.startingY))
    self.lblCurrentPointInfo:setName("x = " .. tostring(playerX) .. ", y = " .. tostring(playerY))

    local startingX = self.startingX
    local startingY = self.startingY
    local endX = playerX
    local endY = playerY

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

    local width = math.abs(startingX - endX) + 1
    local height = math.abs(startingY - endY) + 1
    self.size = width * height
    self.lblCurrentSizeInfo:setName(tostring(self.size) .. " (x = " .. tostring(math.abs(startingX - endX) + 1) .. ", y = " .. tostring(math.abs(startingY - endY) + 1) .. ")")

    local renderDistance = tonumber(self.entryBoxRenderDistance:getInternalText())
    local renderDistanceOK = renderDistance and renderDistance < ISAddNonPvpZoneUI.MAX_RENDER_DISTANCE
    local radius = renderDistanceOK and renderDistance or ISAddNonPvpZoneUI.DEFAULT_RENDER_DISTANCE
    self.entryBoxRenderDistance:setValid(renderDistanceOK)

    local minX = math.max(playerX - radius, startingX)
    local maxX = math.min(playerX + radius, endX)
    local minY = math.max(playerY - radius, startingY)
    local maxY = math.min(playerY + radius, endY)

    if radius >= 0 then
        for x2 = minX, maxX do
            for y = minY, maxY do
                if self.comboBoxRenderType:getOptionData(self.comboBoxRenderType.selected)(x2, y, playerX, playerY, radius) then
                    local sq = getCell():getGridSquare(x2, y, 0)
                    if sq then
                        for n = 0, sq:getObjects():size() - 1 do
                            local obj = sq:getObjects():get(n)
                            obj:setHighlighted(true)
                            obj:setHighlightColor(0.6, 1, 0.6, 0.5)
                        end
                    end
                end
            end
        end
    end

    self:updateButtons()
end

function ISAddNonPvpZoneUI:updateButtons()
    self.btnOk.enable = self.size > 1
end

function ISAddNonPvpZoneUI:onClick(button)
    if button.internal == "OK" then
        local doneIt = true
        if NonPvpZone.getZoneByTitle(self.entryBoxTitle:getInternalText()) then
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

            NonPvpZone.addNonPvpZone(self.entryBoxTitle:getInternalText(), x1, y1, x2 + 1, y2 + 1)
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

function ISAddNonPvpZoneUI:save()
    print("Saved!")
    local currentRenderDistance = tonumber(self.entryBoxRenderDistance:getInternalText())
    local renderDistance =  currentRenderDistance and tostring(currentRenderDistance) or tostring(ISAddNonPvpZoneUI.DEFAULT_RENDER_DISTANCE)
    local renderType = self.comboBoxRenderType:getSelectedText()
    local fileWriter = getFileWriter("nonpvpzoneuifix_data.txt", true, false)
    fileWriter:writeln("renderDistance=" .. tostring(renderDistance))
    fileWriter:writeln("renderType=" .. renderType)
    fileWriter:close()
end

function ISAddNonPvpZoneUI:load()
    local fileReader = getFileReader("nonpvpzoneuifix_data.txt", true)
    local line = fileReader:readLine()

    while line do
        local key, value = string.match(line, "(%w+)=(%w+)")
        if key == "renderDistance" then
            self.entryBoxRenderDistance:setText(value)
        elseif key == "renderType" then
            self.comboBoxRenderType:select(value)
        end
        line = fileReader:readLine()
    end

    fileReader:close()
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
    o.backgroundColor = {r=0, g=0, b=0, a=0.75}
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