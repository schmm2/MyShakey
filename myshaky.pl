% ***** Facts *****

% Has Connection
connected(room0, room1).
connected(room1, room0).

connected(room2, room1).
connected(room1, room2).

connected(room0, room2).
connected(room2, room0).	
	
connected(room1, room4).
connected(room4, room1).
	
% Boxes in Room	
inRoom(redBox, room2).
inRoom(yellowBox, room3).
inRoom(greenBox, room1).
inRoom(blueBox, room4).

		
% Agent
inRoom(shakey, room2).
agent(shakey).		
		
% ***** Rules *****

findPath(A,B) :-
	walk(A,B,[]).

goInRoom(Agent, TargetRoom) :- 
	agent(Agent),
	inRoom(Agent, CurrentRoom),
	findPath(CurrentRoom, TargetRoom),
	assert(inRoom(Agent, TargetRoom)),
	retract(inRoom(Agent, CurrentRoom)),
	format("~w  moved to ~w",[Agent, TargetRoom]),
	flush_output.


walk(A,B,V) :-      % go from A to B...
  connected(A,X),   % - if A is connected to X, and
  not(member(X,V)), % - we haven't yet visited X, and
  (                 % - either
    B = X				% X is the target
	;          		%   OR
    walk(X,B,[A|V]) %   - we can get to it from X
  ).
	
getBox(Agent, Box) :-
	inRoom(Box, TargetRoom),
	goInRoom(Agent, TargetRoom).
		