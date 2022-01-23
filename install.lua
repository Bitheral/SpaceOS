-- Copyright (c) 2022 Bitheral
-- SpaceOS
-- A ComputerCraft operating system

----------------------------------
---- SpaceOS Installer Script ----
----------------------------------
term.setCursorPos(1,1)


width, height = term.getSize()
x, y = term.getCursorPos()

center_x = width / 2
center_y = height / 2

-- Prompt the user for installation options
function installationPrompt()
    term.clear()
    title = "SpaceOS installer!"
    title_x = center_x - (#title / 2)
    term.setCursorPos(title_x, center_y)
    print(title)
end

-- Decide what to do based on the user's selection
function proceed(option)
    boolOption = option - 1
    if boolOption == 1 then
        os.reboot()
    else
        -- Get directory of this script
        local script_dir = shell.getRunningProgram()

        -- Format computer
        term.clear()
        title = "Formatting"
        title_x = center_x - (#title / 2)
        term.setCursorPos(title_x, center_y)
        print(title)
        term.setCursorPos(1,1)
        files = fs.list("/")
        for i = 1, #files do
            if not fs.isReadOnly(files[i]) then
                print("Deleting " .. files[i])
                fs.delete(files[i])
            end
        end
        print("Formatting finished!")
        
        -- Download the latest libraries for the operating system
        term.clear()
        title = "Downloading libraries..."
        title_x = center_x - (#title / 2)
        term.setCursorPos(title_x, center_y)
        print(title)
        term.setCursorPos(1,1)


        -- Install the operating system
        -- Move files from system directory to the root directory
        -- and make files read-only
        term.clear()
        title = "Installing..."
        title_x = center_x - (#title / 2)
        term.setCursorPos(title_x, center_y)
        print(title)
        term.setCursorPos(1,1)
        -- Get current directory
        local current_dir = "/" .. string.sub(shell.getRunningProgram(), 1, #shell.getRunningProgram()-11) .. "/"
        print(current_dir .. "system/")
        files = fs.list(current_dir .. "system/")
        for i = 1, #files do
            if fs.isDir(files[i]) then
                print("Is directory")
            else
                if not fs.isReadOnly(files[i]) then
                    print("Moving", current_dir .. "system/" .. files[i], "to /" .. files[i])
                    -- fs.move(files[i], "/" .. files[i])
                    fs.copy(current_dir .. "system/" .. files[i], "/" .. files[i])
                end
            end
        end

        -- Prompt user that installation is complete
        -- and reboot the computer after a short delay
        -- to allow the user to read the message and update
        -- the delay shown on the screen
        local delay = 5
        while delay ~= 0 do
            term.clear()
            title = "Installation complete!"
            title_x = center_x - (#title / 2)
            term.setCursorPos(title_x, center_y)
            print(title)
            delay_title = "Rebooting in " .. delay .. " seconds..."
            title_x = center_x - (#delay_title / 2)
            term.setCursorPos(title_x, center_y + 2)
            print(delay_title)
            sleep(1)
            delay = delay - 1
        end

        os.reboot()

    end
end

-- Display the options to the user
function selection()
    option = 1
    options = {"Install", "Exit"}

    while true do
        if option < 1 then option = 1
        elseif option > #options then option = #options end

        for k, v in pairs(options) do
            if k == option then
                term.setCursorPos(center_x - (#v / 2), center_y + k)
                term.setBackgroundColor(colors.white)
                term.setTextColor(colors.black)
                print(v)
            else
                term.setCursorPos(center_x - (#v / 2), center_y + k)
                term.setBackgroundColor(colors.black)
                term.setTextColor(colors.white)
                print(v)
            end
        end
        
        _, key = os.pullEvent("key")
        if key == keys.up then option = option - 1
        elseif key == keys.down then option = option + 1
        elseif key == keys.enter then break
        end
    end

    proceed(option)
end


installationPrompt()
selection()