-- Get directory of this script
local current_dir = "/" .. string.sub(shell.getRunningProgram(), 1, #shell.getRunningProgram()-11) .. "/"
local width, height = term.getSize()


os.loadAPI(current_dir .. "lib/json.lua")
os.loadAPI(current_dir .. "lib/textapi.lua")
os.loadAPI(current_dir .. "lib/sha256.lua")


function splashscreen()
    term.clear()

    splash_img = paintutils.loadImage(current_dir .. "img/splash.nfp")
    paintutils.drawImage(splash_img, 0, 1)

    textapi.printString(textapi.center_x, 15, "Welcome to SpaceOS!", true)

    sleep(3)
end

function userlist()
    term.clear()

    option = 1
    usersFile = fs.exists(current_dir .. "data/.users.json")
    
    if usersFile then
        -- Read the users file
        -- Allow the user to select an existing user
        -- or create a new user

        -- Read the users file
        usersFile = fs.open(current_dir .. "data/.users.json", "r")
        users = json.decode(usersFile.readAll())
        usersFile.close()        

        if #users > 1 then
            -- options = users
            while true do
                if option < 1 then option = 1
                elseif option > #users then option = #users end
                
                for k, v in pairs(users) do
                    
                    username = v.username

                    if k == option then
                        term.setCursorPos(textapi.center_x - (#v / 2), textapi.center_y + k)
                        term.setBackgroundColor(colors.white)
                        term.setTextColor(colors.black)
                        print(username)
                    else
                        term.setCursorPos(textapi.center_x - (#v / 2), textapi.center_y + k)
                        term.setBackgroundColor(colors.black)
                        term.setTextColor(colors.white)
                        print(username)
                    end
                end
                
                _, key = os.pullEvent("key")
                if key == keys.up then option = option - 1
                elseif key == keys.down then option = option + 1
                elseif key == keys.enter then break
                end
            end
        else
            user = users[1]
            textapi.printString(textapi.center_x, textapi.center_y, "Hello, ".. user.username, true)
            textapi.printString(textapi.center_x, textapi.center_y + 1, "Password: ", true, false)
            password = read("*")
            if sha256.sha256(password) == user.password then
                return user
            else
                textapi.printString(textapi.center_x, textapi.center_y + 2, "Incorrect password!", true)
                sleep(2)
                userlist()
            end
        end

    else

        -- Ask the user for a username
        -- Ask the user for a password
        -- Create a new user and save it to the users file

        -- Ask the user for a username
        term.clear()
        textapi.printString(textapi.center_x, 1, "Enter a username", true)
        username = read()
        term.clear()
        textapi.printString(textapi.center_x, 1, "Enter a password", true)
        password = read("*")

        -- Create a new user and save it to the users file
        users = {}
        users[1] = {}
        users[1].username = username
        users[1].password = sha256.sha256(password)
        usersFile = fs.open(current_dir .. "data/.users.json", "w")
        usersFile.write(json.encode(users))
        usersFile.close()
    end
end

splashscreen()
userlist()