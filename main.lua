local notifications = {}
local alpha = {}

local assets = {
    fonts = {
        roboto_medium = dxCreateFont('assets/fonts/Roboto-Medium.ttf', 14),
        roboto_light = dxCreateFont('assets/fonts/Roboto-Light.ttf', 14)
    }
}

local svgs = {
    background = [[
        <svg width="397" height="100" viewBox="0 0 397 100" fill="none" xmlns="http://www.w3.org/2000/svg">
            <path d="M0 15C0 6.71573 6.71573 0 15 0H397V100H15C6.71573 100 0 93.2843 0 85V15Z" fill="white"/>
        </svg>
    ]],
    iconSuccess = [[
        <svg width="36" height="36" viewBox="0 0 36 36" fill="none" xmlns="http://www.w3.org/2000/svg">
            <path d="M18 2C14.8355 2 11.7421 2.93838 9.11088 4.69649C6.4797 6.45459 4.42894 8.95345 3.21793 11.8771C2.00693 14.8007 1.69008 18.0177 2.30744 21.1214C2.92481 24.2251 4.44866 27.0761 6.6863 29.3137C8.92394 31.5513 11.7749 33.0752 14.8786 33.6926C17.9823 34.3099 21.1993 33.9931 24.1229 32.7821C27.0466 31.5711 29.5454 29.5203 31.3035 26.8891C33.0616 24.2579 34 21.1645 34 18C34 13.7565 32.3143 9.68687 29.3137 6.68629C26.3131 3.68571 22.2435 2 18 2V2ZM28.45 12.63L15.31 25.76L7.55001 18C7.28479 17.7348 7.13579 17.3751 7.13579 17C7.13579 16.6249 7.28479 16.2652 7.55001 16C7.81522 15.7348 8.17493 15.5858 8.55001 15.5858C8.92508 15.5858 9.28479 15.7348 9.55001 16L15.33 21.78L26.47 10.65C26.6013 10.5187 26.7572 10.4145 26.9288 10.3434C27.1004 10.2724 27.2843 10.2358 27.47 10.2358C27.6557 10.2358 27.8396 10.2724 28.0112 10.3434C28.1828 10.4145 28.3387 10.5187 28.47 10.65C28.6013 10.7813 28.7055 10.9372 28.7766 11.1088C28.8476 11.2804 28.8842 11.4643 28.8842 11.65C28.8842 11.8357 28.8476 12.0196 28.7766 12.1912C28.7055 12.3628 28.6013 12.5187 28.47 12.65L28.45 12.63Z" fill="#FFFFFF"/>
        </svg>
    ]],
    iconError = [[
        <svg width="36" height="36" viewBox="0 0 36 36" fill="none" xmlns="http://www.w3.org/2000/svg">
            <path d="M19.3261 3.79801C18.8071 2.81701 17.1931 2.81701 16.6741 3.79801L3.17406 29.298C3.05254 29.5266 2.99229 29.7827 2.99919 30.0415C3.00609 30.3002 3.07991 30.5528 3.21344 30.7745C3.34697 30.9963 3.53568 31.1797 3.76116 31.3068C3.98664 31.4339 4.24121 31.5005 4.50006 31.5H31.5001C31.7587 31.5005 32.0131 31.434 32.2385 31.307C32.4638 31.1799 32.6523 30.9966 32.7857 30.775C32.9191 30.5534 32.9928 30.301 32.9996 30.0424C33.0064 29.7838 32.9461 29.5278 32.8246 29.2995L19.3261 3.79801ZM19.5001 27H16.5001V24H19.5001V27ZM16.5001 21V13.5H19.5001L19.5016 21H16.5001Z" fill="#FFFFFF"/>
        </svg>
    ]],
    iconInfo = [[
        <svg width="36" height="36" viewBox="0 0 36 36" fill="none" xmlns="http://www.w3.org/2000/svg">
        <path d="M18 1.125C8.6805 1.125 1.125 8.6805 1.125 18C1.125 27.3195 8.6805 34.875 18 34.875C27.3195 34.875 34.875 27.3195 34.875 18C34.875 8.6805 27.3195 1.125 18 1.125ZM20.8125 29.1094H15.1875V15.6094H20.8125V29.1094ZM18 12.5156C17.2541 12.5156 16.5387 12.2193 16.0113 11.6919C15.4838 11.1644 15.1875 10.449 15.1875 9.70312C15.1875 8.9572 15.4838 8.24183 16.0113 7.71439C16.5387 7.18694 17.2541 6.89062 18 6.89062C18.7459 6.89062 19.4613 7.18694 19.9887 7.71439C20.5162 8.24183 20.8125 8.9572 20.8125 9.70312C20.8125 10.449 20.5162 11.1644 19.9887 11.6919C19.4613 12.2193 18.7459 12.5156 18 12.5156Z" fill="#FFFFFF"/>
    </svg>
    ]]
}

local renderSvgs = {
    back = svgCreate(397, 100, svgs.background),
    success = svgCreate(36, 36, svgs.iconSuccess),
    error = svgCreate(36, 36, svgs.iconError),
    info = svgCreate(36, 36, svgs.iconInfo)
}

addEventHandler('onClientRender', root,
    function ()
        if (notifications and #notifications > 0) then
            for i, v in ipairs(notifications) do

                if ((getTickCount() - v.tick) > v.seconds) then
                    v.start = 255
                    v.stop = 0
                    v.tick = getTickCount()
                end

                alpha[i] = interpolateBetween(v.start, 0, 0, v.stop, 0, 0, (getTickCount() - v.tick)/350, 'Linear')
                animBar = interpolateBetween(383, 0, 0, 0, 0, 0, (getTickCount() - v.tickBar)/v.seconds, 'Linear')

                if (alpha[i] == 0) then
                    alpha[i] = nil
                    table.remove(notifications, i)
                else
                    dxDrawImage(1523, ((518 - 116) + 116 * i), 397, 100, renderSvgs.back, 0, 0, 0, tocolor(255, 255, 255, alpha[i]))
                    dxDrawImage(1542, ((550 - 116) + 116 * i), 36, 36, renderSvgs[v.type], 0, 0, 0, tocolor(v.color[1], v.color[2], v.color[3], alpha[i]))
                    dxDrawRectangle(1537, ((613 - 116) + 116 * i), animBar, 5, tocolor(v.color[1], v.color[2], v.color[3], alpha[i]))

                    dxDrawText(v.type, 1588, ((537 - 116) + 116 * i), 69, 21, tocolor(0, 0, 0, alpha[i]), 1, assets.fonts.roboto_medium, 'left', 'center')
                    dxDrawText(v.message, 1588, ((563 - 116) + 116 * i), 306, (21 + v.size / 30), tocolor(0, 0, 0, alpha[i]), 1, assets.fonts.roboto_light, 'left', 'center', false, true)
                    dxDrawText('x', 1885, ((518 - 116) + 116 * i), 29, 29, tocolor(0, 0, 0, alpha[i]), 1, assets.fonts.roboto_medium, 'center', 'center')
                end
            end 
        end
    end
, false, 'low-1')

addEventHandler('onClientClick', root,
    function (b, s)
        if (notifications and #notifications > 0) then
            if ( b == 'left' and s == 'down') then
                for i, v in ipairs(notifications) do
                    if (isCursorOnElement(1885, ((518 - 116) + 116 * i), 29, 29)) then
                        v.start = 255
                        v.stop = 0
                        v.tick = getTickCount()

                        if (alpha[i] == 0) then
                            alpha[i] = nil
                            table.remove(notifications, i)   
                        end
                    end
                end 
            end
        end
    end
)

addEvent('notification', true)
addEventHandler('notification', root,
    function (message, typeMessage)
        message, typeMessage = tostring(message), tostring(typeMessage)

        local tableItems = {
            tick = getTickCount(),
            tickBar = getTickCount(),
            message = message,
            type = typeMessage,
            seconds = (7 * 1000),
            start = 0,
            stop = 255,
            size = dxGetTextWidth(message, 1, assets.fonts.roboto_light),
            color = system.types[typeMessage] and system.types[typeMessage] or system.types[system.defaultType]
        }
        table.insert(notifications, tableItems)
    end
)

addCommandHandler('success',
    function (cmd)
        triggerEvent('notification', localPlayer, 'This is just a text, bigger than the original, and now even bigger.', 'success')
    end
)

addCommandHandler('error',
    function (cmd)
        triggerEvent('notification', localPlayer, "Your changes don't saved.", 'error')
    end
)

addCommandHandler('info',
    function (cmd)
        triggerEvent('notification', localPlayer, 'You have one notification', 'info')
    end
)