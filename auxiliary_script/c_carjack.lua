-- Check for this variable in other parts of your code
-- to determine if the button has been held down for +/- 1 second.
local pressed = false

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
-- Create a timer variable
        local timer = 0
-- Loop as long as the control is held down.
        while IsControlPressed(0, <control>) do
            Citizen.Wait(0)
-- Add 1 to the timer
            timer = timer + 1
-- If the timer is 60 or more, stop the loop (60 ticks/frames = +/- 1second)
            if timer > 60 then
                SetRelationshipBetweenGroups(2, 'player', 'player')
                break -- Stop the loop
            end
        end
-- Now wait until the button is released (to avoid running the timer above
-- again and again if the player keeps holding down the button)
-- Remove this while not loop if you don't want to wait for the user to
-- let go of the button before re-running the task again.
        while not IsControlJustReleased(0, <control>) do
            Citizen.Wait(0)
        end
-- Reset the pressed variable (remove this if you call a function instead)
        pressed = false
    end
end)

