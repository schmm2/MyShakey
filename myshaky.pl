% ***** Facts *****

% Has Connection
connected(room0, room1).
connected(room1, room0).

connected(room2, room1).
connected(room1, room2).

connected(room5, room0).
connected(room0, room5).

connected(room0, room2).
connected(room2, room0).	
	
connected(room1, room4).
connected(room4, room1).
	
%--Initial object positions--
inRoom(blueBox, room4, 2, 2).
inRoom(orangeBox, room4, 2, 2).
inRoom(greyBox, room4, 2, 2).
inRoom(redBox, room2, 1 , 2).
inRoom(blackBox, room2, 1, 2).
inRoom(greenBox, room1, 1 , 3).
inRoom(yellowBox, room3, 2, 2).

% Agent
inRoom(shakey, room2).
agent(shakey).	

% box level
on(redBox, blackBox).
on(blackBox, ground).
on(greenBox, ground).
on(yellowBox, ground).
on(blueBox, orangeBox).
on(orangeBox, greyBox).
on(greyBox, ground).

%room(Name, X-Dimension, Y-Dimension)
room(room0, 3, 3).
room(room1, 3, 3).
room(room2, 6, 3).
room(room3, 3, 6).
room(room4, 3, 3).
room(room5, 3, 3).

		
	
		
% ***** Rules *****

add(X, L, [X|L]).

findPath(A,B) :-
	walk(A,B,[]).

goInRoom(Agent, TargetRoom) :- 
	agent(Agent),
	inRoom(Agent, CurrentRoom),
	findPath(CurrentRoom, TargetRoom),
	assert(inRoom(Agent, TargetRoom)),
	retract(inRoom(Agent, CurrentRoom)),
	format("~w  moved from ~w to ~w",[Agent, CurrentRoom, TargetRoom]),
	nl.

  
walk(A,B,V) :-    % go from A to B...
  connected(A,X),   % - if A is connected to X, and
  not(member(X,V)), % - we haven't yet visited X, and 
  (                 % - either
	(
		% found X as the target
		B = X,
		add([A,B],V,Path),
		reverse(Path, OrderedPath),
		format("To ~w ",B),
		print("Path: "),
		print(OrderedPath),
		nl	
	)
	; %   OR
    walk(X,B,[A|V]) %   - we can get to it from X
  ).
	
goToBox(Agent, Box) :-
	inRoom(Box, TargetRoom, X, Y),
	goInRoom(Agent, TargetRoom),
	format("~w went to box ~w",[Agent, Box]),
	nl.
		

moveBox(Agent, Box, TargetRoom, X, Y) :-
	goToBox(Agent, Box),
	inRoom(Box, CurrentRoom, OldX, OldY),
	findPath(CurrentRoom, TargetRoom),
	% check if box is the top most
	not(on(BoxAbove, Box)),
	(
		% 
		(
			% returns topmost box on X,Y	
			inRoom(TargetBox, TargetRoom, X, Y),
			getTopBox(TargetBox, TopBox)
		)
		;
		(
			% there are no boxes on X,Y, pur box on ground
			not(inRoom(TargetBox, TargetRoom, X, Y)),
			TopBox = ground
		)
	),
	
	% put box on stack or ground
	assert(on(Box, TopBox)),
	% move box
	assert(inRoom(Box, TargetRoom, X, Y)),
	retract(inRoom(Box, CurrentRoom, OldX, OldY)),
	% move shakey
	retract(inRoom(Agent, CurrentRoom)),
	assert(inRoom(Agent, TargetRoom)).

		
getTopBox(Box, TopBox):-
	not(on(BoxAbove, Box)),
	TopBox = Box.
	
getTopBox(Box, TopBox):-
	on(BoxAbove, Box),
	getTopBox(BoxAbove, TopBox).
		