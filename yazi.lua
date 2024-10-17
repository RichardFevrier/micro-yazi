VERSION = "1.0.0"

local config = import("micro/config")
local shell = import("micro/shell")

function yazi(bp)
    local tmp, err = shell.RunCommand("mktemp -t 'yazi-chooser.XXXXXX'")
    if err == nil then
        local _, err = shell.RunInteractiveShell("yazi --chooser-file "..tmp, false, true)
        if err == nil then
            local output, err = shell.RunCommand("cat "..tmp)
            if err == nil then
                yaziOutput(output, {bp})
            end
        end
    end
    shell.RunCommand("rm -f "..tmp)
end

function yaziOutput(output, args)
    local bp = args[1]

    if output ~= "" then
        for file in output:gmatch("[^\r\n]+") do
            bp:NewTabCmd({file})
        end
    end
end

function init()
    config.MakeCommand("yazi", yazi, config.NoComplete)
    config.AddRuntimeFile("yazi", config.RTHelp, "help/yazi.md")
end
