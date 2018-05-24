(define (problem belkan-test2)

  (:domain belkan2-domain)

  (:objects z1 z2 z3 z4 z5 z6 z7 z8 z9 z10 z11 z12 z13 z14
	    z15 z16 z17 z18 z19 z20 z21 z22 z23 z24 z25 - room
        actor knight witch princess teacher - NPC
        belkan - player
        n e w s - orientation
        oscar gold apple rose book - object
  )
  (:init
	;-----------------------------------------------------
	; Paths from zone 1 to zone 25 and the distance between them
	;-----------------------------------------------------

	(path z1 z2 e) (= (distance z1 z2) 2)

	(path z2 z1 w) (= (distance z2 z1) 2)
	(path z2 z7 s) (= (distance z2 z7) 4)

	(path z3 z4 e) (= (distance z3 z4) 5)
	(path z3 z8 s) (= (distance z3 z8) 1)

	(path z4 z3 w)	(= (distance z4 z3) 5)
	(path z4 z9 s)	(= (distance z4 z9) 1)

	(path z5 z10 s) (= (distance z5 z10) 5)

	(path z6 z7 e) (= (distance z6 z7) 4)
	(path z6 z11 s) (= (distance z6 z11) 1)

	(path z7 z2 n) (= (distance z7 z2) 4)
	(path z7 z6 w) (= (distance z7 z6) 4)
	(path z7 z8 e) (= (distance z7 z8) 2)

	(path z8 z3 n) (= (distance z8 z3) 3)
	(path z8 z7 w) (= (distance z8 z7) 2)
	(path z8 z13 s) (= (distance z8 z13) 2)

	(path z9 z4 n) (= (distance z9 z4) 1)
	(path z9 z10 e) (= (distance z9 z10) 3)

	(path z10 z5 n) (= (distance z10 z5) 5)
	(path z10 z9 w) (= (distance z10 z9) 3)
	(path z10 z15 s) (= (distance z10 z15) 4)

	(path z11 z6 n) (= (distance z11 z6) 1)
	(path z11 z12 e) (= (distance z11 z12) 5)
	(path z11 z16 s) (= (distance z11 z16) 4)

	(path z12 z11 w) (= (distance z12 z11) 5)
	(path z12 z13 e) (= (distance z12 z13) 3)
	(path z12 z17 s) (= (distance z12 z17) 5)

	(path z13 z8 n) (= (distance z13 z8) 2)
	(path z13 z12 w) (= (distance z13 z12) 3)
	(path z13 z14 e) (= (distance z13 z14) 3)
	(path z13 z18 s) (= (distance z13 z18) 1)

	(path z14 z13 w) (= (distance z14 z13) 3)
	(path z14 z15 e) (= (distance z14 z15) 2)
	(path z14 z19 s) (= (distance z14 z19) 1)

	(path z15 z10 n) (= (distance z15 z10) 4)
	(path z15 z14 w) (= (distance z15 z14) 2)

	(path z16 z11 n) (= (distance z16 z11) 4)

	(path z17 z12 n) (= (distance z17 z12) 5)
	(path z17 z22 s) (= (distance z17 z22) 2)

	(path z18 z13 n) (= (distance z18 z13) 1)

	(path z19 z14 n) (= (distance z19 z14) 1)
	(path z19 z24 s) (= (distance z19 z24) 3)

	(path z20 z25 s) (= (distance z20 z25) 4)

	(path z21 z22 e) (= (distance z21 z22) 5)

	(path z22 z17 n) (= (distance z22 z17) 2)
	(path z22 z21 w) (= (distance z22 z21) 5)

	(path z23 z24 e) (= (distance z23 z24) 2)

	(path z24 z19 n) (= (distance z24 z19) 3)
	(path z24 z23 w) (= (distance z24 z23) 2)
	(path z24 z25 e) (= (distance z24 z25) 3)

	(path z25 z20 n) (= (distance z25 z20) 4)
	(path z25 z24 w) (= (distance z25 z24) 3)

	;-----------------------------------------------------
	; Rooms where the NPCs are located
	;-----------------------------------------------------

    (at z1 witch)
    (at z13 princess)
    (at z18 actor)
    (at z6 teacher)
    (at z25 knight)


    ;-----------------------------------------------------
    ; Rooms where the objects are located and 'on-floor' status
    ;-----------------------------------------------------

    (at z8 apple) (on-floor apple)
    (at z24 rose) (on-floor rose)
    (at z23 oscar) (on-floor oscar)
    (at z7 book) (on-floor book)
    (at z17 gold) (on-floor gold)

    ;-----------------------------------------------------
    ; Player status
    ;-----------------------------------------------------

    (at z1 belkan)
    (compass e)

    ;-----------------------------------------------------
	; Game status
	;-----------------------------------------------------

	(= (total-cost) 0)
  )

  (:goal (AND
	 (has-object witch)
	 (has-object teacher)
	 (has-object knight)
	 (has-object actor)
	 (has-object princess)
	 (<= (total-cost) 120)
         )
  )

  ;(:metric minimize(total-cost))
)
