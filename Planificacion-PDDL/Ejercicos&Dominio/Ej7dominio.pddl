(define (domain belkan7-domain)

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
		surface
		object
	)

	(:predicates
		(at ?x - room ?y - locatable) ;True if the locatable 'y' is at the room 'x'
		(on-floor ?x - object) ;True if the object 'x' is on the floor

		(compass ?x - player ?y - orientation) ;True if the player 'x' is orientated in the 'y' orientation
		(robot ?x - player) ;True if the player 'x' can pick items from the ground and give them to another player

		(NPC ?x - character) ;True if the character 'x' is a NPC

		(path ?x ?y - room ?z - orientation) ;True if exist a path from room 'x' to room 'y' in the 'z' orientation
		(covered ?x - room ?y - surface) ;True if the room 'x' is covered by the surface 'y'

		(BIKINI ?x - character) ;True if the player 'x' has a bikini in his hand or inside his bag
		(BOOTS ?x - character) ;True if the player 'x' has a boots in his hand or inside his bag

		(empty-hand ?x - character) ;True if the player 'x' doesn't have a object in his hand
		(empty-bag ?x - player) ;True if the player 'x' doesn't have a object in his bag

		(equipable ?x - object) ;True if the object 'x' is equipable
		(in-bag ?x - player ?y - object) ;True if the object 'x' is inside the 'x' player's bag
		(in-hand ?x - character ?y - object) ;True if the object 'x' is in the 'x' player's hand
	)

	(:functions
		(max-objects) ;Maximun number of objects that any NPC can hold in his magic pocket
		(magic-pocket ?x - character) ;Number of objects that the NPC 'x' has

		(total-cost) ;Total cost of the plan
		(distance ?x ?y - room) ;Distance from room 'x' to room 'y'

		(total-score) ;Total score that both players have
		(value ?x - object ?y - character) ;Points that the object 'x' gives the player if he gives it to the NPC 'y'
	)


	;Put an object inside the bag
	(:action PUT
		:parameters (?o - object ?p - player)
		:precondition (AND
			(NOT(empty-hand ?p))
			(in-hand ?p ?o)
			(empty-bag ?p)
		)
		:effect (AND
			(NOT(empty-bag ?p))
			(in-bag ?p ?o)
			(empty-hand ?p)
			(NOT(in-hand ?p ?o))
		)
	)

	;Get an object from the bag
	(:action GET
		:parameters (?o - object ?p - player)
		:precondition (AND
			(empty-hand ?p)
			(in-bag ?p ?o)
			(NOT(empty-bag ?p))
		)
		:effect (AND
			(NOT(empty-hand ?p))
			(in-hand ?p ?o)
			(empty-bag ?p)
			(NOT(in-bag ?p ?o))
		)
	)

	;Give an object to a NPC
	(:action GIVE
		:parameters (?o - object ?p - player ?r - character ?x - room )
		:precondition (OR
			(AND
				(NPC ?r)
				(at ?x ?p)
				(at ?x ?r)
				(NOT(empty-hand ?p))
				(in-hand ?p ?o)
				(NOT(equipable ?o))
				(< (magic-pocket ?r)(max-objects))
			)
			(AND
				(at ?x ?p)
				(at ?x ?r)
				(NOT(empty-hand ?p))
				(in-hand ?p ?o)
				(empty-hand ?r)
			)
		)
		:effect (AND
			(WHEN(AND(NOT(robot ?p))(NPC ?r))
				(AND
					(increase (total-score)(value ?o ?r))
					(increase (magic-pocket ?r) 1)
				)
			)
			(WHEN(AND(= ?o bikini)(NOT(NPC ?r)))
				(AND
					(NOT(BIKINI ?p))
					(BIKINI ?r)
					(NOT(empty-hand ?r))
					(in-hand ?r ?o)
				)
			)
			(WHEN(AND(= ?o boots)(NOT(NPC ?r)))
				(AND
					(NOT(BOOTS ?p))
					(BOOTS ?r)
					(NOT(empty-hand ?r))
					(in-hand ?r ?o)
				)
			)
			(WHEN(AND(NOT(= ?o bikini))(NOT(= ?o boots))(NOT(NPC ?r)))
				(AND
					(NOT(empty-hand ?r))
					(in-hand ?r ?o)
				)
			)
			(empty-hand ?p)
			(NOT(in-hand ?p ?o))
		)
	)

	;Go from one room to another
	(:action GO
		:parameters (?p - player ?x ?y - room ?c - orientation)
		:precondition (OR
			(AND
				(at ?x ?p)
				(NOT(covered ?y cliff))
				(NOT(covered ?y lake))
				(NOT(covered ?y forest))
				(path ?x ?y ?c)
				(compass ?p ?c)
			)
			(AND
				(at ?x ?p)
				(BIKINI ?p)
				(covered ?y lake)
				(path ?x ?y ?c)
				(compass ?p ?c)
			)
			(AND
				(at ?x ?p)
				(BOOTS ?p)
				(covered ?y forest)
				(path ?x ?y ?c)
				(compass ?p ?c)
			)
		)

		:effect (AND
			(NOT(at ?x ?p))
			(at ?y ?p)
			(increase (total-cost)(distance ?x ?y))
		)
	)

	;Drop an object
	(:action DROP
     		:parameters (?p - player ?x - room ?o - object )
			:precondition (OR
				(AND
					(NOT(covered ?x forest))
					(NOT(covered ?x lake))
					(NOT(covered ?x cliff))
					(at ?x ?p)
					(NOT(empty-hand ?p))
					(in-hand ?p ?o)
				)
				(AND
					(covered ?x forest)
					(NOT(= ?o boots))
					(at ?x ?p)
					(NOT(empty-hand ?p))
					(in-hand ?p ?o)
				)
				(AND
					(covered ?x lake)
					(NOT(= ?o bikini))
					(at ?x ?p)
					(NOT(empty-hand ?p))
					(in-hand ?p ?o)
				)

			)
     		:effect (AND
				(empty-hand ?p)
				(NOT(in-hand ?p ?o))
				(on-floor ?o)
				(at ?x ?o)
				(WHEN(= ?o bikini)
					(NOT(BIKINI ?p))
				)
				(WHEN(= ?o boots)
					(NOT(BOOTS ?p))
				)
			)
	)

	;Pick an object
	(:action PICK
		:parameters (?p - player ?o - object ?x - room)
		:precondition (AND
			(on-floor ?o)
			(robot ?p)
			(at ?x ?p)
			(at ?x ?o)
			(empty-hand ?p)
		)
		:effect (AND
			(NOT(empty-hand ?p))
			(in-hand ?p ?o)
			(NOT(at ?x ?o))
			(NOT(on-floor ?o))
			(WHEN(= ?o bikini)
				(BIKINI ?p)
			)
			(WHEN(= ?o boots)
				(BOOTS ?p)
			)
		)
	)

	;Rotate the character's orientation 90º to the left
	(:action TURN_LEFT
		:parameters (?c - orientation ?p - player)
		:precondition (compass ?p ?c)
		:effect (AND
			(WHEN(= ?c n)
				(AND(compass ?p w)(NOT(compass ?p n)))
			)
			(WHEN(= ?c w)
				(AND(compass ?p s)(NOT(compass ?p w)))
			)
			(WHEN(= ?c e)
				(AND(compass ?p n)(NOT(compass ?p e)))
			)
			(WHEN(= ?c s)
				(AND(compass ?p e)(NOT(compass ?p s)))
			)
		)

	)

	;Rotate the character's orientation 90º to the right
	(:action TURN_RIGHT
		:parameters (?c - orientation ?p - player)
		:precondition (compass ?p ?c)
		:effect (AND
			(WHEN(= ?c n)
				(AND(compass ?p e)(NOT(compass ?p n)))
			)
			(WHEN(= ?c w)
				(AND(compass ?p n)(NOT(compass ?p w)))
			)
			(WHEN(= ?c e)
				(AND(compass ?p s)(NOT(compass ?p e)))
			)
			(WHEN(= ?c s)
				(AND(compass ?p w)(NOT(compass ?p s)))
			)

		)
	)

	;Rotate the character's orientation 180º
	(:action TURN_180
		:parameters (?c - orientation ?p - player)
		:precondition (compass ?p ?c)
		:effect (AND
			(WHEN(= ?c n)
				(AND(compass ?p s)(NOT(compass ?p n)))
			)
			(WHEN(= ?c w)
				(AND(compass ?p e)(NOT(compass ?p w)))
			)
			(WHEN(= ?c e)
				(AND(compass ?p w)(NOT(compass ?p e)))
			)
			(WHEN(= ?c s)
				(AND(compass ?p n)(NOT(compass ?p s)))
			)

		)
	)

)
