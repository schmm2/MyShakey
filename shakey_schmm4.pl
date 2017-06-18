%---Facts---

%--Objects--
box(blueBox).
box(orangeBox).
box(greyBox).
box(redBox).
box(blackBox).
box(greenBox).
box(yellowBox).

%room(Name, X-Dimension, Y-Dimension)
room(room0, 3, 3).
room(room1, 3, 3).
room(room2, 6, 3).
room(room3, 3, 6).
room(room4, 3, 3).
room(room5, 3, 3).

agent(shakey).

%--Room connections--
edge(room0, room1).
edge(room0, room2).
edge(room1, room2).
edge(room1, room4).

%--Initial object positions--
inRoom(blueBox, room4).
inRoom(orangeBox, room4).
inRoom(greyBox, room4).
inRoom(redBox, room2).
inRoom(blackBox, room2).
inRoom(greenBox, room1).
inRoom(yellowBox, room3).

onGround(greyBox, 2, 2).
onGround(blackBox, 1, 2).
onGround(greenBox, 1, 3).
onGround(yellowBox, 2, 2).

onBox(orangeBox, greyBox).
onBox(blueBox, orangeBox).
onBox(redBox, blackBox).

inRoom(shakey, room2).

format("Found possible path: ~w",[Path]).

%---Rules----

%Search paths
%Source: https://www.cpp.edu/~jrfisher/www/prolog_tutorial/2_15.html
connected(X,Y) :- edge(X,Y) ; edge(Y,X). %Connection is bidirectional

path(A,B) :-
       travel(A,B,[A],Q), 
       reverse(Q,Path), %Reverse path list for output
	   write("Found path: "), write_ln(Path).

travel(A,B,P,[B|P]) :- 
       connected(A,B).
travel(A,B,Visited,Path) :-
       connected(A,C),           
       C \== B, %not equal
       not(member(C,Visited)),
       travel(C,B,[C|Visited],Path).

%Move Agent to specific room
goInRoom(Agent, TargetRoom) :- 
	agent(Agent),
	inRoom(Agent, CurrentRoom), 
	path(CurrentRoom, TargetRoom),
	assert(inRoom(Agent, TargetRoom)),
	retract(inRoom(Agent, CurrentRoom)),
	write("Agent moved to "), write_ln(TargetRoom).

%Move Agent to room with specific box
goToBox(Agent, Box) :-
	inRoom(Box, TargetRoom),
	goInRoom(Agent, TargetRoom).
	%write("Agent moved to"), write(Box), write(" in "), write_ln(TargetRoom).
	
%Move Box to specific room
moveBox(Agent, Box, TargetRoom) :-
	goToBox(Agent, Box).
	path(CurrentRoom, TargetRoom),
	assert(inRoom(Agent, TargetRoom)),
	assert(inRoom(Box, TargetRoom)),
	write("Agent moved "), write(Box), write(" from "), write(CurrentRoom), write(" to "), write_ln(TargetRoom),
	retract(inRoom(Agent, CurrentRoom)),
	retract(inRoom(Box, CurrentRoom)).
	
	
	
	
	
	