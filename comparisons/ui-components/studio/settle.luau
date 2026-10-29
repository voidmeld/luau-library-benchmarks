--!strict

return function(now: () -> number, nextFrame: () -> ()): (number?) -> ()
	return function(seconds: number?)
		local untilTime = now() + (seconds or 0)
		repeat
			nextFrame()
		until now() >= untilTime
	end
end
