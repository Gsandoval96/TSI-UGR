(define (domain belkan4-domain)

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

		(compass ?x - orientation) ;True if the player is orientated in the 'x' orientation

		(path ?x ?y - room ?z - orientation) ;True if exist a path from room 'x' to room 'y' in the 'z' orientation
		(covered ?x - room ?y - surface) ;True if the room 'x' is covered by the surface 'y'

		(BIKINI) ;True if the player has a bikini in his hand or inside his bag
		(BOOTS) ;True if the player has a boots in his hand or inside his bag

		(empty-hand) ;True if the player doesn't have a object in his hand
		(empty-bag) ;True if the player doesn't have a object in his bag

		(equipable ?x - object) ;True if the object 'x' is equipable
		(in-bag ?x - object) ;True if the object 'x' is inside the bag
		(in-hand ?x - object) ;True if the object 'x' is in the player hand
		(has-object ?x - NPC) ;True if the NPC 'x' has an object
	)

	(:functions
		(total-cost) ;Total cost of the plan
		(points) ;Points that the player has gotten by taking the objects to the NPCs
		(distance ?x ?y - room) ;Distance from room 'x' to room 'y'
		(value ?x - object ?y - NPC) ;Points that the object 'x' gives the player if he gives it to the NPC 'y'
	)


	;Put an object inside the bag
	(:action PUT
		:parameters (?o - object)
		:precondition (AND
			(NOT(empty-hand))
			(in-hand ?o)
			(empty-bag)
		)
		:effect (AND
			(NOT(empty-bag))
			(in-bag ?o)
			(empty-hand)
			(NOT(in-hand ?o))
		)
	)

	;Get an object from the bag
	(:action GET
		:parameters (?o - object)
		:precondition (AND
			(empty-hand)
			(in-bag ?o)
			(NOT(empty-bag))
		)
		:effect (AND
			(NOT(empty-hand))
			(in-hand ?o)
			(empty-bag)
			(NOT(in-bag ?o))
		)
	)

	;Give an object to a NPC
	(:action GIVE
		:parameters (?o - object ?p - player ?n - NPC ?x - room )
		:precondition (AND
			(at ?x ?p)
			(at ?x ?n)
			(NOT(empty-hand))
			(in-hand ?o)
			(NOT(has-object ?n))
			(NOT(equipable ?o))
		)
		:effect (AND
			(empty-hand)
			(NOT(in-hand ?o))
			(has-object ?n)
			(increase (points)(value ?o ?n))
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
				(compass ?c)
			)
			(AND
				(at ?x ?p)
				(BIKINI)
				(covered ?y lake)
				(path ?x ?y ?c)
				(compass ?c)
			)
			(AND
				(at ?x ?p)
				(BOOTS)
				(covered ?y forest)
				(path ?x ?y ?c)
				(compass ?c)
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
					(NOT(empty-hand))
					(in-hand ?o)
				)
				(AND
					(covered ?x forest)
					(NOT(= ?o boots))
					(at ?x ?p)
					(NOT(empty-hand))
					(in-hand ?o)
				)
				(AND
					(covered ?x lake)
					(NOT(= ?o bikini))
					(at ?x ?p)
					(NOT(empty-hand))
					(in-hand ?o)
				)

			)

     		:effect (AND
				(empty-hand)
				(NOT(in-hand ?o))
				(on-floor ?o)
				(at ?x ?o)
				(WHEN(= ?o bikini)
					(NOT(BIKINI))
				)
				(WHEN(= ?o boots)
					(NOT(BOOTS))
				)
			)
	)

	;Pick an object
	(:action PICK
		:parameters (?p - player ?x - room ?o - object)
		:precondition (AND
			(on-floor ?o)
			(at ?x ?p)
			(at ?x ?o)
			(empty-hand)
		)
		:effect (AND
			(NOT(empty-hand))
			(in-hand ?o)
			(NOT(at ?x ?o))
			(NOT(on-floor ?o))
			(WHEN(= ?o bikini)
				(BIKINI)
			)
			(WHEN(= ?o boots)
				(BOOTS)
			)
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
