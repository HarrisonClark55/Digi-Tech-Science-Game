display.setDefault("minTextureFilter", "nearest"); display.setDefault("magTextureFilter", "nearest")

local sizeRatio = math.min(display.contentWidth / 1024, display.contentHeight / 768)

local correctAnswer, correctAnswers, incorrectAnswers, time = 0, 0, 0, 60

local isApplicationBusy = false

local applicationState = "N/A"

local choiceButtons = {}

local elementMetadataBackup = {{name = "aluminium", diagramFileName = "aluminium.png", tileFileName = "aluminiumTile.png"}, {name = "argon", diagramFileName = "argon.png", tileFileName = "argonTile.png"}, {name = "beryllium", diagramFileName = "beryllium.png", tileFileName = "berylliumTile.png"}, {name = "boron", diagramFileName = "boron.png", tileFileName = "boronTile.png"}, {name = "calcium", diagramFileName = "calcium.png", tileFileName = "calciumTile.png"}, {name = "carbon", diagramFileName = "carbon.png", tileFileName = "carbonTile.png"}, {name = "chlorine", diagramFileName = "chlorine.png", tileFileName = "chlorineTile.png"}, {name = "fluorine", diagramFileName = "fluorine.png", tileFileName = "fluorineTile.png"}, {name = "helium", diagramFileName = "helium.png", tileFileName = "heliumTile.png"}, {name = "hydrogen", diagramFileName = "hydrogen.png", tileFileName = "hydrogenTile.png"}, {name = "lithium", diagramFileName = "lithium.png", tileFileName = "lithiumTile.png"}, {name = "magnesium", diagramFileName = "magnesium.png", tileFileName = "magnesiumTile.png"}, {name = "neon", diagramFileName = "neon.png", tileFileName = "neonTile.png"}, {name = "nitrogen", diagramFileName = "nitrogen.png", tileFileName = "nitrogenTile.png"}, {name = "oxygen", diagramFileName = "oxygen.png", tileFileName = "oxygenTile.png"}, {name = "phosphorus", diagramFileName = "phosphorus.png", tileFileName = "phosphorusTile.png"}, {name = "potassium", diagramFileName = "potassium.png", tileFileName = "potassiumTile.png"}, {name = "silicon", diagramFileName = "silicon.png", tileFileName = "siliconTile.png"}, {name = "sodium", diagramFileName = "sodium.png", tileFileName = "sodiumTile.png"}, {name = "sulfur", diagramFileName = "sulfur.png", tileFileName = "sulfurTile.png"}}

local elementMetadata = {{name = "aluminium", diagramFileName = "aluminium.png", tileFileName = "aluminiumTile.png"}, {name = "argon", diagramFileName = "argon.png", tileFileName = "argonTile.png"}, {name = "beryllium", diagramFileName = "beryllium.png", tileFileName = "berylliumTile.png"}, {name = "boron", diagramFileName = "boron.png", tileFileName = "boronTile.png"}, {name = "calcium", diagramFileName = "calcium.png", tileFileName = "calciumTile.png"}, {name = "carbon", diagramFileName = "carbon.png", tileFileName = "carbonTile.png"}, {name = "chlorine", diagramFileName = "chlorine.png", tileFileName = "chlorineTile.png"}, {name = "fluorine", diagramFileName = "fluorine.png", tileFileName = "fluorineTile.png"}, {name = "helium", diagramFileName = "helium.png", tileFileName = "heliumTile.png"}, {name = "hydrogen", diagramFileName = "hydrogen.png", tileFileName = "hydrogenTile.png"}, {name = "lithium", diagramFileName = "lithium.png", tileFileName = "lithiumTile.png"}, {name = "magnesium", diagramFileName = "magnesium.png", tileFileName = "magnesiumTile.png"}, {name = "neon", diagramFileName = "neon.png", tileFileName = "neonTile.png"}, {name = "nitrogen", diagramFileName = "nitrogen.png", tileFileName = "nitrogenTile.png"}, {name = "oxygen", diagramFileName = "oxygen.png", tileFileName = "oxygenTile.png"}, {name = "phosphorus", diagramFileName = "phosphorus.png", tileFileName = "phosphorusTile.png"}, {name = "potassium", diagramFileName = "potassium.png", tileFileName = "potassiumTile.png"}, {name = "silicon", diagramFileName = "silicon.png", tileFileName = "siliconTile.png"}, {name = "sodium", diagramFileName = "sodium.png", tileFileName = "sodiumTile.png"}, {name = "sulfur", diagramFileName = "sulfur.png", tileFileName = "sulfurTile.png"}}

local function createBackground()
    background = display.newImageRect("background.png", display.contentWidth, display.contentHeight)
    background.x, background.y = display.contentCenterX, display.contentCenterY
end

local function shuffleTable(t)
    local j

    for i = #t, 2, -1 do
        j = math.random(i); t[i], t[j] = t[j], t[i]
    end

    return t
end

local function isPointInObject(x, y, object)
    local objectBounds = object.contentBounds; if x > objectBounds.xMin and x < objectBounds.xMax and y > objectBounds.yMin and y < objectBounds.yMax then return true end
end

local function createGameUI()
    correctAnswersText = display.newText("Correct: " .. correctAnswers, 30 * sizeRatio, 30 * sizeRatio, system.nativeFont, 32 * sizeRatio)
    correctAnswersText.anchorX, correctAnswersText.anchorY = 0, 0

    incorrectAnswersText = display.newText("Incorrect: " .. incorrectAnswers, display.contentWidth - (30 * sizeRatio), 30 * sizeRatio, system.nativeFont, 32 * sizeRatio)
    incorrectAnswersText.anchorX, incorrectAnswersText.anchorY = 1, 0
end

local function updateApplicationUI()
    correctAnswersText.text = "Correct: " .. correctAnswers; incorrectAnswersText.text = "Incorrect: " .. incorrectAnswers
end

local function removeGameUI()
    correctAnswersText:removeSelf(); correctAnswersText = nil; incorrectAnswersText:removeSelf(); incorrectAnswersText = nil
end

local function createElementUI()
    applicationState, isApplicationBusy = "GAME", false

    local elementMetadataIndexNum = math.random(1, #elementMetadata); local randomElement = elementMetadata[elementMetadataIndexNum]; table.remove(elementMetadata, elementMetadataIndexNum); elementMetadata = shuffleTable(elementMetadata); local options = {randomElement, elementMetadata[1], elementMetadata[2], elementMetadata[3], elementMetadata[4]}; options = shuffleTable(options); for i = 1, #options do if options[i].tileFileName == randomElement.name .. "Tile.png" then correctAnswer = i; break end end

    elementDiagram = display.newImage(randomElement.diagramFileName)
    elementDiagram.x, elementDiagram.y = display.contentCenterX, display.contentCenterY

    for x = 1, 5 do
        choiceButtons[#choiceButtons + 1] = display.newImage(options[x].tileFileName)
        choiceButtons[#choiceButtons].x, choiceButtons[#choiceButtons].y = ((x - 1) * (123 * sizeRatio)) + (display.contentCenterX - (246 * sizeRatio)), display.contentCenterY + (196 * sizeRatio); choiceButtons[#choiceButtons]:scale(0.8 * sizeRatio, 0.8 * sizeRatio)
    end
end

local function clearElementUI()
    applicationState, isApplicationBusy = "GAME", true

    elementDiagram:removeSelf(); elementDiagram = nil; for i = 1, #choiceButtons do if choiceButtons[i] ~= nil then choiceButtons[i]:removeSelf(); choiceButtons[i] = nil end end
end

local function createGameOverScreen()
    applicationState, isApplicationBusy = "OVER", false

    gameOverText = display.newText("Game over! You scored " .. correctAnswers .. "/15", display.contentCenterX, display.contentCenterY, system.nativeFont, 32 * sizeRatio)

    gameOverSubText = display.newText("Click to play again!", display.contentCenterX, display.contentHeight - (30 * sizeRatio), system.nativeFont, 16 * sizeRatio)
    gameOverSubText.anchorY = 1
end

local function removeGameOverScreen()
    gameOverText:removeSelf(); gameOverText = nil; gameOverSubText:removeSelf(); gameOverSubText = nil
end

local function resetGame()
    correctAnswers, incorrectAnswers, time = 0, 0, 60

    for i = 1, #elementMetadata do elementMetadata[i] = nil end; for i = 1, #elementMetadataBackup do elementMetadata[i] = elementMetadataBackup[i] end
end

function createTimer()
    timerText = display.newText(time, display.contentCenterX, 30 * sizeRatio, system.nativeFont, 32 * sizeRatio)
    timerText.anchorY = 0

    local function updateTimer()
        time = time - 1; timerText.text = time; if time <= 0 then clearElementUI(); removeTimer(); removeGameUI(); createGameOverScreen() end
    end; timerAction = timer.performWithDelay(1000, updateTimer, 60)
end

function removeTimer()
    timer.cancel(timerAction); timerText:removeSelf(); timerText = nil
end

local function onTouch(event)
    if event.phase == "began" then
        if applicationState == "OVER" and isApplicationBusy == false then
            resetGame(); removeGameOverScreen(); createTimer(); createGameUI(); createElementUI()
        elseif applicationState == "GAME" and isApplicationBusy == false then
            for i = 1, #choiceButtons do
                if isPointInObject(event.x, event.y, choiceButtons[i]) == true then
                    if i == correctAnswer then correctAnswers = correctAnswers + 1; updateApplicationUI() else incorrectAnswers = incorrectAnswers + 1; updateApplicationUI() end; if #elementMetadata > 5 then clearElementUI(); createElementUI() else clearElementUI(); removeTimer(); removeGameUI(); createGameOverScreen() end; break
                end
            end
        end
    end
end; Runtime:addEventListener("touch", onTouch)

local function init()
    createBackground(); createGameUI(); createTimer(); createElementUI()
end; init()