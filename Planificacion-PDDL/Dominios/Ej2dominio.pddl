(define (domain belkan2-domain)

	(:requirements
		:strips
		:equality
		:typing
	)

	(:types
		object character - locatable
		player NPC - character
		orientation
		room
	)

	(:predicates
		(at ?x - room ?y - locatable) ;True if the locatable 'y' is at the room 'x'
		(on-floor ?x - object) ;True if the object 'x' is on the floor

		(compass ?x - orientation) ;True if the player is orientated in the 'x' orientation

		(path ?x ?y - room ?z - orientation) ;True if exist a path from room 'x' to room 'y' in the 'z' orientation
		(has-object ?x - character) ;True if the character 'x' has an object
	)

	(:functions
		(total-cost) ;Total cost of the plan
		(distance ?x ?y - room) ;Distance from room 'x' to room 'y'
	)

	;Pick an object
	(:action PICK
		:parameters (?o - object ?p - player ?x - room)
		:precondition (AND
			(on-floor ?o)
			(at ?x ?p)
			(at ?x ?o)
			(NOT(has-object ?p))
		)
		:effect (AND
			(has-object ?p)
			(NOT(on-floor ?o))
			(NOT(at ?x ?o))
		)
	)

	;Drop an object
	(:action DROP
     		:parameters (?o - object ?p - player ?x - room)
     		:precondition (AND
				(at ?x ?p)
				(has-object ?p)
			)

     		:effect (AND
				(NOT(has-object ?p))
				(on-floor ?o)
				(at ?x ?o)
			)
	)

	;Give an object to a NPC
	(:action GIVE
		:parameters (?p - player ?n - NPC ?x - room)
		:precondition (AND
			(at ?x ?p)
			(at ?x ?n)
			(has-object ?p)
			(NOT(has-object ?n))
		)
		:effect (AND
			(NOT(has-object ?p))
			(has-object ?n)
		)
	)

	;Go from one room to another
	(:action GO
		:parameters (?p - player ?x ?y - room ?c - orientation)
		:precondition (AND
			(at ?x ?p)
			(path ?x ?y ?c)
			(compass ?c)
		)
		:effect (AND
			(NOT(at ?x ?p))
			(at ?y ?p)
			(increase (total-cost)(distance ?x ?y))
		)
	)

	;Rotate the character's orientation 90º to the left
	(:action TURN_LEFT
		:parameters (?c - orientation)
		:precondition (compass ?c)
		:effect (AND
			(WHEN(= ?c n)
				(AND(compass w)(NOT(compass n)))
			)
			(WHEN(= ?c w)
				(AND(compass s)(NOT(compass w)))
			)
			(WHEN(= ?c e)
				(AND(compass n)(NOT(compass e)))
			)
			(WHEN(= ?c s)
				(AND(compass e)(NOT(compass s)))
			)
		)

	)

	;Rotate the character's orientation 90º to the right
	(:action TURN_RIGHT
		:parameters (?c - orientation)
		:precondition (compass ?c)
		:effect (AND
			(WHEN(= ?c n)
				(AND(compass e)(NOT(compass n)))
			)
			(WHEN(= ?c w)
				(AND(compass n)(NOT(compass w)))
			)
			(WHEN(= ?c e)
				(AND(compass s)(NOT(compass e)))
			)
			(WHEN(= ?c s)
				(AND(compass w)(NOT(compass s)))
			)

		)
	)

	;Rotate the character's orientation 180º
	(:action TURN_180
		:parameters (?c - orientation)
		:precondition (compass ?c)
		:effect (AND
			(WHEN(= ?c n)
				(AND(compass s)(NOT(compass n)))
			)
			(WHEN(= ?c w)
				(AND(compass e)(NOT(compass w)))
			)
			(WHEN(= ?c e)
				(AND(compass w)(NOT(compass e)))
			)
			(WHEN(= ?c s)
				(AND(compass n)(NOT(compass s)))
			)

		)
	)

)
