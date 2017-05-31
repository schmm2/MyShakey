% ***** Facts *****

% Has Connection
hasDoor(room0, room1).
hasDoor(room1, room0).

hasDoor(room2, room1).
hasDoor(room1, room2).

hasDoor(room0, room2).
hasDoor(room2, room0).	
	
% Boxes in Room	
inRoom(redBox, room2).
inRoom(yellowBox, room3).
inRoom(greenBox, room1).
		
% Agent in Room		
inRoom(agent, room2).	
		
% ***** Rules *****

goInRoom(agent,Roomtarget) :- 
	inRoom(agent, Roomx), 
	hasDoor(Roomx, Roomtarget).
	
getBox(agent, Box) :-
	inRoom(Box, Roomx),
	goInRoom(agent, Roomx).
		