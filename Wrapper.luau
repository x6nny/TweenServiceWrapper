--> Custom Types
export type tweenInfo = {
	Time: number,
	Style: Enum.EasingStyle,
	Direction: Enum.EasingDirection,
	Repeat: number,
	Reverses: boolean,
	Delay: number,
}

--> Default Valid Tables
local DefaultTweenInfo: tweenInfo = {
	Time = 1,
	Style = Enum.EasingStyle.Linear,
	Direction = Enum.EasingDirection.In,
	Repeat = 0,
	Reverses = false,
	Delay = 0,
}

table.freeze(DefaultTweenInfo)

--> Validations
local function TableToTweenInfo(ValidTable: tweenInfo)
	return TweenInfo.new(ValidTable.Time, ValidTable.Style, ValidTable.Direction, ValidTable.Repeat, ValidTable.Reverses, ValidTable.Delay)
end

local function ValidateTweenInfo(Info: tweenInfo)
	local ValidTweenInfo = {}
	
	for i, v in pairs(Info) do
		if typeof(v) == typeof(DefaultTweenInfo[i]) then
			ValidTweenInfo[i] = v
		elseif typeof(v) ~= typeof(DefaultTweenInfo[i]) then
			ValidTweenInfo[i] = DefaultTweenInfo[i]
		end
	end
	
	for i, v in pairs(DefaultTweenInfo) do
		if ValidTweenInfo[i] == nil then
			ValidTweenInfo[i] = v
		end
	end
	
	return TableToTweenInfo(ValidTweenInfo)
end

--> Create Tween
return function CreateTween(Object: Instance, tweenInfo: tweenInfo, PropertyGoals, AutoRun: boolean?, callBack: () -> ()): Tween? | boolean?
	local ValidTweenInfo = ValidateTweenInfo(tweenInfo)
	
	local succ, tween: Tween? = pcall(function()
		return game:GetService("TweenService"):Create(Object, ValidTweenInfo, PropertyGoals)
	end)
	
	if (succ == true and tween ~= nil) and ((AutoRun ~= nil) and (AutoRun == true)) then
		tween:Play()
		
		tween.Completed:Wait()
		
		if callBack ~= nil and typeof(callBack) == "function" then
			callBack()
		end
		
		return true
	end
	
	return tween
end
