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

% room connection on its own -> allows box moving inside the room

	
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

% move the agent into a room
goInRoom(Agent, TargetRoom) :- 
	agent(Agent),
	inRoom(Agent, CurrentRoom),
	findPathDFS(CurrentRoom, TargetRoom),
	assert(inRoom(Agent, TargetRoom)),
	retract(inRoom(Agent, CurrentRoom)),
	format("go in room: ~w  moved from ~w to ~w",[Agent, CurrentRoom, TargetRoom]),
	nl.

  

% go to a box	
goToBox(Agent, Box) :-
	inRoom(Box, TargetRoom, X, Y),
	(
		% check if we can go in the room
		goInRoom(Agent, TargetRoom);
		% or, is already in the target-room
		(
			inRoom(Agent,TargetRoom),
			format("go to box: ~w already in ~w",[Agent, TargetRoom]),
			nl
		)
	),
	format("go to box: ~w went to ~w",[Agent, Box]),
	nl.
		
% Move Box to another location
moveBox(Agent, Box, TargetRoom, X, Y) :-
	goToBox(Agent, Box),
	inRoom(Box, CurrentRoom, OldX, OldY),
	findPathDFS(CurrentRoom, TargetRoom),
	% check if box is the top most
	(
		(
			% topmost box
			not(on(BoxAbove, Box)),
			format("move box: ~w is topmost in the stack",[Box]),
			% no box ontop of this box found
			on(Box, BoxBelow),
			nl
		);
		(
			% not topmost
			% TODO: Make better
			on(BoxAbove, Box),
			% situation before moving
			format("move box: ~w is on ~w",[BoxAbove, Box]),
			nl,
			% another box is on this box
			on(Box, BoxBelow),
			% situation after moving, the top box lies now on the box below
			assert(on(BoxAbove, BoxBelow)),
			retract(on(BoxAbove, Box)),
			format("move box: ~w lies now on ~w",[BoxAbove, BoxBelow]),
			nl
		)
		
	),
	(			
		% check target location
		(
			% returns topmost box on X,Y	
			inRoom(TargetBox, TargetRoom, X, Y),
			getTopBox(TargetBox, TopBox)
		)
		;
		(
			% there are no boxes on X,Y, put our box on the ground
			not(inRoom(TargetBox, TargetRoom, X, Y)),
			TopBox = ground
		)
	),
	
	% move shakey
	assert(inRoom(Agent, TargetRoom)),
	retract(inRoom(Agent, CurrentRoom)),
	format("move agent: ~w  moved from ~w to ~w",[Agent, CurrentRoom, TargetRoom]),
	nl,
	
	% put box on stack or ground
	assert(on(Box, TopBox)),
	retract(on(Box, BoxBelow)),
	format("move box: put ~w on ~w",[Box, TopBox]),
	nl,
	
	% move box
	assert(inRoom(Box, TargetRoom, X, Y)),
	retract(inRoom(Box, CurrentRoom, OldX, OldY)),
	format("move box result: moved ~w to ~w, X: ~w, Y:~w",[Box, TargetRoom, X, Y]),
	nl.
	

		
getTopBox(Box, TopBox):-
	not(on(BoxAbove, Box)),
	TopBox = Box.
	
getTopBox(Box, TopBox):-
	on(BoxAbove, Box),
	getTopBox(BoxAbove, TopBox).
	
	
%********** Path Search Algorithm **********

%***** BFS *****
% To Be implementet

%***** DFS *****
findPathDFS(A,B) :-
	walkDFS(A,B,[]).
		
walkDFS(A,B,V) :-    % go from A to B...
  connected(A,X),   % - if A is connected to X, and
  not(member(X,V)), % - we haven't yet visited X, and 
  (                 % - either
	(
		% found X as the target
		B = X,
		append([B,A],V,Path),
		reverse(Path, OrderedPath),
		format("find path: path to ~w =",B),
		print(OrderedPath),
		nl	
	)
	; %   OR
    walkDFS(X,B,[A|V]) %   - we can get to it from X
  ).