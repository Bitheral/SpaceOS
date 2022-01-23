width, height = term.getSize()
x, y = term.getCursorPos()

center_x = width / 2
center_y = height / 2

function printString(xPos, yPos, str, centerString, newline)
    if newline == nil then newline = true end
    centerString = centerString or false
    if centerString == true then
        xPos = center_x - (#str / 2)
    end
    term.setCursorPos(xPos, yPos)
    term.write(str)
    if not newline then
        term.setCursorPos(xPos + #str, yPos)
    else
        term.setCursorPos(1, yPos + 1)
    end
end